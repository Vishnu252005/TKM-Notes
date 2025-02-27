import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:Nexia/ai/constants/constants.dart';
import 'package:Nexia/ai/widgets/front_button.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Nexia/ai/screens/HomePage.dart'; // Import HomePage
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() {
//   runApp(const PdfChat());
// }

class PdfChat extends StatelessWidget {
  final Uint8List? fileBytes;

  const PdfChat({super.key, this.fileBytes});

  @override
  Widget build(BuildContext context) {
    return PDFParserWidget(fileBytes: fileBytes);
  }
}

class PDFParserWidget extends StatefulWidget {
  final Uint8List? fileBytes;

  const PDFParserWidget({super.key, this.fileBytes});

  @override
  State<PDFParserWidget> createState() => _PDFParserWidgetState();
}

class _PDFParserWidgetState extends State<PDFParserWidget> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String? extractedText;
  List<String> generatedQuestions = [];
  final TextEditingController queryController = TextEditingController();
  String? queryResponse;
  bool showGeneralKnowledgeButton = false;
  late AnimationController _controller;
  bool _isDarkMode = true;
  String? _fileName;
  int _currentPage = 1;
  int _totalPages = 0;
  double _zoomLevel = 1.0;
  bool _showQuestions = true;

  // Change to T5-base model
  static const String _apiUrl = 'https://api-inference.huggingface.co/models/t5-base';
  String get _apiToken => dotenv.env['HUGGING_FACE_TOKEN'] ?? 'default_value';

  Color get _backgroundColor => _isDarkMode 
      ? const Color(0xFF1A1A2E) 
      : const Color(0xFFF5F5F7);
  
  Color get _cardColor => _isDarkMode 
      ? const Color(0xFF252542) 
      : Colors.white;
  
  Color get _textColor => _isDarkMode 
      ? Colors.white 
      : const Color(0xFF2D2D3A);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.fileBytes != null) {
      _processPDF(widget.fileBytes!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Text(
          _fileName ?? 'PDF Parser',
          style: GoogleFonts.archivo(color: _textColor),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _textColor,
            ),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
          ),
          IconButton(
            icon: Icon(Icons.upload_file, color: _textColor),
            onPressed: () => pickPDF(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _isDarkMode 
                  ? const Color(0xFF2A2A4A)
                  : Colors.blue.withOpacity(0.05),
              _isDarkMode 
                  ? const Color(0xFF1A1A2E)
                  : Colors.purple.withOpacity(0.05),
            ],
          ),
        ),
        child: isLoading 
            ? _buildLoadingState()
            : Column(
                children: [
                  if (extractedText != null) ...[
                    _buildToolbar(),
                    Expanded(
                      child: _buildMainContent(),
                    ),
                  ] else
                    _buildWelcomeState(),
                ],
              ),
      ),
      bottomNavigationBar: extractedText != null
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SpinKitFadingCircle(
            color: _isDarkMode ? Colors.blue : Colors.deepPurple,
            size: 50.0,
            controller: _controller,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Processing PDF...",
          style: GoogleFonts.archivo(
            color: _textColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file,
            size: 80,
            color: _textColor.withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            "Upload a PDF to get started",
            style: GoogleFonts.archivo(
              fontSize: 20,
              color: _textColor,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            icon: Icon(Icons.upload_file),
            label: Text("Select PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDarkMode ? Colors.blue[700] : Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => pickPDF(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Expanded(
          child: Card(
            color: _cardColor,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PDF Content',
                        style: GoogleFonts.archivo(
                          color: _textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.question_answer, color: _textColor),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: _cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => _buildQuestionsSheet(),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: _textColor),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: extractedText ?? ''));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Text copied to clipboard')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: _textColor.withOpacity(0.2)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      extractedText ?? '',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14 * _zoomLevel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _textColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Generated Questions',
                  style: GoogleFonts.archivo(
                    color: _textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: _textColor.withOpacity(0.2)),
          Expanded(
            child: ListView.builder(
              controller: controller,
              padding: EdgeInsets.all(8),
              itemCount: generatedQuestions.length,
              itemBuilder: (context, index) {
                return Card(
                  color: _isDarkMode 
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.blue.shade50,
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _isDarkMode 
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.blue.shade100,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      generatedQuestions[index],
                      style: TextStyle(color: _textColor),
                    ),
                    onTap: () {
                      queryController.text = generatedQuestions[index];
                      getAnswer(generatedQuestions[index]);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.zoom_out, color: _textColor),
            onPressed: () => setState(() => _zoomLevel = max(0.5, _zoomLevel - 0.1)),
          ),
          SizedBox(width: 8),
          Text(
            '${(_zoomLevel * 100).round()}%',
            style: TextStyle(color: _textColor),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.zoom_in, color: _textColor),
            onPressed: () => setState(() => _zoomLevel = min(2.0, _zoomLevel + 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
        color: _cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (queryResponse != null)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _isDarkMode 
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.question_answer, 
                          color: _isDarkMode ? Colors.blue : Colors.blue[700],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Response:',
                          style: GoogleFonts.archivo(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      queryResponse!,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    style: TextStyle(color: _textColor),
                    decoration: InputDecoration(
                      hintText: "Ask a question about the PDF...",
                      hintStyle: TextStyle(color: _textColor.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: _isDarkMode 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade100,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.blue[700] : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => getAnswer(queryController.text),
                  ),
                ),
              ],
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
          _fileName = result.files.single.name;
        });
        _processPDF(result.files.single.bytes!);
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

  Future<void> _processPDF(Uint8List fileBytes) async {
    setState(() {
      isLoading = true;
    });

    try {
      final document = PdfDocument(inputBytes: fileBytes);
      final extractor = PdfTextExtractor(document);
      extractedText = extractor.extractText();
      
      // Truncate text to prevent overload
      String processText = extractedText ?? '';
      if (processText.length > 1000) {
        processText = processText.substring(0, 1000) + "...";
      }

      setState(() {
        isLoading = false;
      });

      final prompt = '''
      Generate questions from this text: ${processText}
      Format: Return only questions, one per line.
      ''';

      final response = await _getHuggingFaceResponse(prompt);
      
      setState(() {
        // Process questions and ensure we have at least some questions
        List<String> questions = response
            .split('\n')
            .where((line) => line.trim().isNotEmpty && line.contains('?'))
            .take(5)
            .toList();

        generatedQuestions = questions.isEmpty ? [
          "What is the main topic of this document?",
          "What are the key points discussed?",
          "Can you summarize the main findings?",
          "What conclusions are drawn in the text?",
          "What recommendations are made in the document?"
        ] : questions;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        generatedQuestions = [
          "What is the main topic of this document?",
          "What are the key points discussed?",
          "Can you summarize the main findings?",
          "What conclusions are drawn in the text?",
          "What recommendations are made in the document?"
        ];
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using default questions due to processing error.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> getAnswer(String question) async {
    if (extractedText == null || question.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Truncate the context if it's too long
      String context = extractedText!;
      if (context.length > 800) {
        context = context.substring(0, 800) + "...";
      }

      final prompt = '''
      Question: ${question}
      Context: ${context}
      Answer the question based on the context.
      ''';

      final response = await _getHuggingFaceResponse(prompt);
      
      setState(() {
        queryResponse = response.trim();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        queryResponse = 'Error: Unable to process request. Please try again.';
      });
    }
  }

  Future<String> _getHuggingFaceResponse(String prompt) async {
    try {
      // Truncate the prompt if it's too long
      if (prompt.length > 1000) {
        prompt = prompt.substring(0, 1000) + "...";
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': prompt,
          'parameters': {
            'max_length': 512,
            'min_length': 30,
            'temperature': 0.7,
            'top_p': 0.9,
            'do_sample': true,
            'return_full_text': false
          }
        }),
      );

      if (response.statusCode == 200) {
        try {
          final List<dynamic> result = jsonDecode(response.body);
          return result[0]['generated_text'] ?? 'No response generated';
        } catch (e) {
          print('Parse error: $e');
          return 'Error parsing response';
        }
      } else if (response.statusCode == 503) {
        // Model is loading, wait and retry
        await Future.delayed(Duration(seconds: 10));
        return _getHuggingFaceResponse(prompt);
      } else {
        print('API Error Response: ${response.body}');
        return 'Error: Unable to process request';
      }
    } catch (e) {
      print('Error getting response: $e');
      return 'Error: Unable to connect to service';
    }
  }

  Future<void> getGeneralKnowledgeAnswer(String question) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _getHuggingFaceResponse('''
        Answer the following question based on general knowledge or information from the web:
        Question: $question
      ''');

      setState(() {
        queryResponse = response.replaceAll('*', '');
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
      final response = await _getHuggingFaceResponse('''
        Summarize the following text:
        ${extractedText}
      ''');

      setState(() {
        queryResponse = response.replaceAll('*', '');
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
