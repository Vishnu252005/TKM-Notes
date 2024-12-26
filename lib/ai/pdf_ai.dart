import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:Nexia/ai/constants/constants.dart';
import 'package:Nexia/ai/widgets/front_button.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'PDF Parser',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const PDFParserWidget(),
        );
      },
    );
  }
}

class PDFParserWidget extends StatefulWidget {
  const PDFParserWidget({super.key});

  @override
  State<PDFParserWidget> createState() => _PDFParserWidgetState();
}

class _PDFParserWidgetState extends State<PDFParserWidget> with SingleTickerProviderStateMixin {
  final gemini = GoogleGemini(apiKey: Constants.geminiApiKey);
  bool isLoading = false;
  String? extractedText;
  List<String> generatedQuestions = [];
  final TextEditingController queryController = TextEditingController();
  String? queryResponse;
  bool showGeneralKnowledgeButton = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('PDF Parser', style: GoogleFonts.archivo()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => pickPDF(),
          ),
        ],
      ),
      body: isLoading 
          ? Center(
              child: SpinKitFadingCircle(
                color: Colors.deepPurple,
                size: 50.0,
                controller: _controller,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (generatedQuestions.isEmpty) ...[
                    Text(
                      "Upload a PDF to get started",
                      style: GoogleFonts.archivo(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FrontWidget(
                      text: "Select PDF",
                      onPressed: () => pickPDF(),
                      iconData: Icons.upload_file,
                    ),
                  ] else ...[
                    if (queryResponse != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        "Response:",
                        style: GoogleFonts.archivo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        queryResponse!,
                        style: GoogleFonts.archivo(fontSize: 16),
                      ),
                    ],
                    if (showGeneralKnowledgeButton) ...[
                      const SizedBox(height: 20),
                      FrontWidget(
                        text: "Get Answer from General Knowledge",
                        onPressed: () => getGeneralKnowledgeAnswer(queryController.text),
                        iconData: Icons.public,
                      ),
                    ],
                    const SizedBox(height: 20),
                    FrontWidget(
                      text: "Summarize PDF",
                      onPressed: () => summarizePDF(),
                      iconData: Icons.summarize,
                    ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: queryController,
                decoration: InputDecoration(
                  labelText: "Ask a question",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => getAnswer(queryController.text),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          isLoading = true;
        });

        final bytes = result.files.single.bytes!;
        final document = PdfDocument(inputBytes: bytes);
        final extractor = PdfTextExtractor(document);
        extractedText = extractor.extractText();
        
        setState(() {
          isLoading = false;
        });

        final response = await gemini.generateFromText('''
          Generate 5 insightful questions based on this text. Ensure that the questions can be answered using the provided text. Only return the questions, one per line:
          ${extractedText}
        ''');

        setState(() {
          generatedQuestions = response.text
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .toList();
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> getAnswer(String question) async {
    if (extractedText == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await gemini.generateFromText('''
        Based on the following text, answer the question:
        Text: ${extractedText}
        Question: $question
      ''');

      if (response.text.contains("does not contain information")) {
        final generalKnowledgeResponse = await gemini.generateFromText('''
          Answer the following question based on general knowledge or information from the web:
          Question: $question
        ''');

        setState(() {
          queryResponse = generalKnowledgeResponse.text.replaceAll('*', '');
          isLoading = false;
        });
      } else {
        setState(() {
          queryResponse = response.text.replaceAll('*', '');
          isLoading = false;
        });
      }
    } catch (e) {
      try {
        final generalKnowledgeResponse = await gemini.generateFromText('''
          Answer the following question based on general knowledge or information from the web:
          Question: $question
        ''');

        setState(() {
          queryResponse = generalKnowledgeResponse.text.replaceAll('*', '');
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> getGeneralKnowledgeAnswer(String question) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await gemini.generateFromText('''
        Answer the following question based on general knowledge or information from the web:
        Question: $question
      ''');

      setState(() {
        queryResponse = response.text.replaceAll('*', '');
        isLoading = false;
        showGeneralKnowledgeButton = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> summarizePDF() async {
    if (extractedText == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await gemini.generateFromText('''
        Summarize the following text:
        ${extractedText}
      ''');

      setState(() {
        queryResponse = response.text.replaceAll('*', '');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
