import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SummarizerAI extends StatefulWidget {
  const SummarizerAI({super.key});

  @override
  State<SummarizerAI> createState() => _SummarizerAIState();
}

class _SummarizerAIState extends State<SummarizerAI> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  bool _isLoading = false;
  bool _isDarkMode = true;

  // Using environment variable for API token
  String get _apiToken => dotenv.env['HUGGING_FACE_TOKEN'] ?? 'default_value';

  // API configuration
  static const String _apiUrl = 'https://api-inference.huggingface.co/models/facebook/bart-large-cnn';

  final List<String> _exampleTexts = [
    "Climate change is one of the most pressing challenges facing our planet today. Rising global temperatures, extreme weather events, and melting ice caps are just some of the visible effects. Scientists warn that without immediate action to reduce greenhouse gas emissions, we could face catastrophic consequences. Governments worldwide are implementing various measures, from renewable energy adoption to carbon pricing, but many argue these efforts are insufficient. The Paris Agreement represents a global commitment to address this crisis, though its effectiveness remains debated.",
    "Artificial intelligence has transformed numerous sectors of society, from healthcare to transportation. Machine learning algorithms can now diagnose diseases, drive cars, and even create art. While these advances offer tremendous benefits, they also raise important ethical questions about privacy, bias, and job displacement. Researchers continue to push the boundaries of AI capabilities, while policymakers grapple with regulatory frameworks to ensure responsible development.",
    "The global pandemic has fundamentally changed how we work and live. Remote work has become normalized, digital transformation has accelerated, and public health infrastructure has been tested like never before. These changes have led to both challenges and opportunities, from increased mental health concerns to reduced carbon emissions from commuting. As societies adapt to this new normal, questions remain about which changes will become permanent.",
  ];

  // Theme colors
  Color get _backgroundColor => _isDarkMode 
      ? const Color(0xFF1A1A2E) 
      : const Color(0xFFF5F5F7);
  
  Color get _cardColor => _isDarkMode 
      ? const Color(0xFF252542) 
      : Colors.white;
  
  Color get _textColor => _isDarkMode 
      ? Colors.white 
      : const Color(0xFF2D2D3A);

  static const int _maxInputLength = 2048; // Maximum tokens the model can handle
  String get _characterCount => '${_textController.text.length}/$_maxInputLength';
  bool get _isInputTooLong => _textController.text.length > _maxInputLength;

  List<String> _chunkText(String text) {
    List<String> chunks = [];
    int chunkSize = _maxInputLength;
    
    // Split by sentences to avoid cutting in middle of sentence
    List<String> sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    String currentChunk = '';
    
    for (String sentence in sentences) {
      if ((currentChunk + sentence).length <= chunkSize) {
        currentChunk += (currentChunk.isEmpty ? '' : ' ') + sentence;
      } else {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk);
        }
        currentChunk = sentence;
      }
    }
    
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
    }
    
    return chunks;
  }

  Future<void> _summarizeText() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _summaryController.clear();
    });

    try {
      String textToSummarize = _textController.text;
      String finalSummary = '';

      if (_isInputTooLong) {
        // Handle long text by chunking
        List<String> chunks = _chunkText(textToSummarize);
        List<String> summaries = [];

        for (int i = 0; i < chunks.length; i++) {
          String chunk = chunks[i];
          String chunkSummary = await _getSummary(chunk);
          summaries.add(chunkSummary);

          // Update progress
          setState(() {
            _summaryController.text = 'Summarizing part ${i + 1}/${chunks.length}...\n\n' +
                summaries.join('\n\n');
          });
        }

        // If we have multiple summaries, summarize them again
        if (summaries.length > 1) {
          String combinedSummaries = summaries.join(' ');
          finalSummary = await _getSummary(combinedSummaries);
        } else {
          finalSummary = summaries.first;
        }
      } else {
        finalSummary = await _getSummary(textToSummarize);
      }

      setState(() {
        _summaryController.text = finalSummary;
        _isLoading = false;
      });
    } catch (e) {
      print('Exception details: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error summarizing text. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<String> _getSummary(String text) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'inputs': text,
        'parameters': {
          'max_length': 130,
          'min_length': 30,
          'do_sample': false,
        }
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty && result[0] is Map<String, dynamic>) {
        return result[0]['summary_text'] ?? result[0]['generated_text'] ?? 'No summary generated';
      } else {
        throw Exception('Invalid response format');
      }
    } else if (response.statusCode == 503) {
      // Model is loading
      await Future.delayed(const Duration(seconds: 20));
      return _getSummary(text); // Retry
    } else {
      throw Exception('Failed to summarize text: ${response.statusCode}');
    }
  }

  void _copyToClipboard() {
    if (_summaryController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _summaryController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Summary copied to clipboard'),
          backgroundColor: _isDarkMode ? const Color(0xFF4C4DDC) : Colors.blue,
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Text Summarizer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.2, end: 0),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(
          color: _isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: 0.2, end: 0),
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input Card
                  Card(
                    elevation: 8,
                    color: _cardColor,
                    shadowColor: _isDarkMode ? Colors.black38 : Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Text to Summarize',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 8),
                          Text(
                            'Paste your text below and let AI create a concise summary',
                            style: TextStyle(
                              color: _textColor.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms, delay: 200.ms)
                            .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _textController,
                            style: TextStyle(color: _textColor),
                            decoration: InputDecoration(
                              labelText: 'Your Text',
                              labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
                              hintText: 'Paste your text here...',
                              hintStyle: TextStyle(color: _textColor.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: _isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              counterText: _characterCount,
                              counterStyle: TextStyle(
                                color: _isInputTooLong ? Colors.red : _textColor.withOpacity(0.7),
                              ),
                              errorText: _isInputTooLong 
                                  ? 'Text will be processed in chunks'
                                  : null,
                              errorStyle: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            maxLines: 8,
                            onChanged: (text) => setState(() {}),
                          ).animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _summarizeText,
                              icon: Icon(
                                _isLoading ? Icons.hourglass_empty : Icons.auto_awesome,
                                color: Colors.white,
                              ),
                              label: Text(
                                _isLoading ? 'Summarizing...' : 'Summarize',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isDarkMode 
                                    ? const Color(0xFF4C4DDC)
                                    : const Color(0xFF2563EB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms, delay: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.8, 0.8)),

                  const SizedBox(height: 20),

                  // Example Texts
                  if (!_isLoading && _summaryController.text.isEmpty)
                    Card(
                      elevation: 4,
                      color: _cardColor,
                      shadowColor: _isDarkMode ? Colors.black38 : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Example Texts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(
                              _exampleTexts.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    _textController.text = _exampleTexts[index];
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _isDarkMode 
                                          ? const Color(0xFF4C4DDC).withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.article_outlined,
                                          color: _isDarkMode 
                                              ? const Color(0xFF4C4DDC)
                                              : Colors.blue,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _exampleTexts[index].substring(0, 100) + '...',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: _textColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate()
                                .fadeIn(duration: 600.ms, delay: (200 + (index * 100)).ms)
                                .slideX(begin: 0.2, end: 0),
                            ),
                          ],
                        ),
                      ),
                    ).animate()
                      .fadeIn(duration: 800.ms, delay: 400.ms)
                      .scale(begin: const Offset(0.8, 0.8)),

                  if (_summaryController.text.isNotEmpty)
                    Card(
                      elevation: 8,
                      color: _cardColor,
                      shadowColor: _isDarkMode ? Colors.black38 : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Summary',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _textColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _copyToClipboard,
                                  icon: Icon(
                                    Icons.copy,
                                    color: _isDarkMode ? Colors.white : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _summaryController,
                              style: TextStyle(
                                color: _textColor,
                                fontSize: 16,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: _isDarkMode 
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                              ),
                              maxLines: null,
                              readOnly: true,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _summaryController.clear();
                                    _textController.clear();
                                  });
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: _isDarkMode ? Colors.white : Colors.blue,
                                ),
                                label: Text(
                                  'Summarize Another Text',
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white : Colors.blue,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(
                                    color: _isDarkMode ? Colors.white : Colors.blue,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate()
                      .fadeIn(duration: 800.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
