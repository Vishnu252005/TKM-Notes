import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:Nexia/ai/constants/constants.dart';
import 'package:Nexia/ai/screens/query_screen.dart';
import 'package:Nexia/ai/widgets/front_button.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isUploading = false;
  bool isGeneratingResponses = false;
  final gemini = GoogleGemini(apiKey: Constants.geminiApiKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 22, 22, 22),
      body: isGeneratingResponses
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF2542A3)),
                  const SizedBox(height: 15),
                  Text("Generating related questions..",
                      style: GoogleFonts.archivo(color: Colors.white))
                ],
              ),
            )
          : Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      color: const Color.fromARGB(225, 22, 22, 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "PDF Parser",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      color: const Color.fromARGB(225, 22, 22, 22),
                      child: Center(
                        child: uploadButton(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> pickAndSendData(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      final PdfDocument document = PdfDocument(inputBytes: fileBytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText();

      setState(() {
        isUploading = true;
      });

      // Generate questions from extracted text
      makeQuestionList(text);
    }
  }

  Widget uploadButton() {
    return Center(
      child: isUploading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  "Processing the PDF",
                  style: GoogleFonts.dmMono(color: Colors.white, fontSize: 16),
                ),
              ],
            )
          : GestureDetector(
              onTap: () => setState(() {
                isUploading = true;
              }),
              child: SizedBox(
                height: 70,
                child: FrontWidget(
                  text: "Upload New PDF",
                  onPressed: () => pickAndSendData(context),
                  iconData: Icons.upload,
                ),
              ),
            ),
    );
  }

  void makeQuestionList(String text) async {
    try {
      setState(() {
        isGeneratingResponses = true;
      });
      String response = await generateResponses(text);
      if (response.isNotEmpty) {
        List<String> questions = response
            .split('\n')
            .map((line) => line.replaceFirst(RegExp(r'^\s*-\s*'), ''))
            .where((line) => line.trim().isNotEmpty)
            .toList();
        setState(() {
          isGeneratingResponses = false;
          isUploading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QueryScreen(
              questions: questions,
              extractedText: text,
            ),
          ),
        );
      } else {
        setState(() {
          isGeneratingResponses = false;
          isUploading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isGeneratingResponses = false;
        isUploading = false;
      });
    }
  }

  Future<String> generateResponses(String data) async {
    try {
      final value = await gemini.generateFromText('''
      Develop an engine that generates 3-5 insightful questions related to the promoted content. These questions should cover key themes, concepts, and points in the document. Make sure about the quality, relevance, and diversity of generated questions, And only print questions in lines:
      $data
    ''');
      return value.text;
    } catch (e) {
      print(e);
      return '';
    }
  }
}

extension on GoogleGemini {
  generateFromText(String s) {}
}
