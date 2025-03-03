import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math' show max;

class CodeGenerator extends StatefulWidget {
  const CodeGenerator({super.key});

  @override
  State<CodeGenerator> createState() => _CodeGeneratorState();
}

class _CodeGeneratorState extends State<CodeGenerator> {
  final TextEditingController _promptController = TextEditingController();
  String? _generatedCode;
  bool _isLoading = false;
  bool _isDarkMode = true;
  String? _output;
  bool _isCompiling = false;
  String _selectedLanguage = 'python'; // Default language
  
  // Update the API URL and languages map
  static const String _compilerApiUrl = 'https://emkc.org/api/v2/piston/execute';

  final Map<String, String> _languages = {
    'python': 'python',
    'javascript': 'javascript',
    'java': 'java',
    'cpp': 'cpp',
    'c': 'c',
    'ruby': 'ruby',
  };

  // Using environment variable for API token
  
  String get _apiToken => dotenv.env['HUGGING_FACE_TOKEN'] ?? 'default_value';

  static const String _apiUrl = 'https://api-inference.huggingface.co/models/bigcode/starcoder';

  final List<String> _examplePrompts = [
    "Write a Python function to sort a list using bubble sort",
    "Write a Python function to find fibonacci series",
    "Write a Python function to check if a string is palindrome",
    "Write a Python function to find prime numbers in a range",
  ];

  final TextEditingController _codeController = TextEditingController();

  Color get _backgroundColor => _isDarkMode 
      ? const Color(0xFF1A1A2E) 
      : const Color(0xFFF5F5F7);
  
  Color get _cardColor => _isDarkMode 
      ? const Color(0xFF252542) 
      : Colors.white;
  
  Color get _textColor => _isDarkMode 
      ? Colors.white 
      : const Color(0xFF2D2D3A);

  Color get _terminalColor => _isDarkMode 
      ? const Color(0xFF1E1E1E)  // Dark terminal color
      : const Color(0xFF2D2D2D); // Light terminal color

  Future<void> _generateCode() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    for (int retry = 0; retry < 3; retry++) {
      try {
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            'Authorization': 'Bearer $_apiToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'inputs': "Write code only without explanation: ${_promptController.text}",
            'parameters': {
              'max_new_tokens': 500,
              'temperature': 0.2,
              'top_p': 0.95,
              'do_sample': true,
              'num_return_sequences': 1
            }
          }),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(utf8.decode(response.bodyBytes));
          String code = result[0]['generated_text'].toString();
          
          // Clean up the code to remove prompts and comments
          code = code
            .replaceAll(RegExp(r'Write code only.*?\n'), '') // Remove the initial prompt
            .replaceAll(RegExp(r'#.*?\n'), '\n') // Remove Python comments
            .replaceAll(RegExp(r'\n{3,}'), '\n\n') // Remove extra newlines
            .trim();

          setState(() {
            _generatedCode = code;
            _codeController.text = code;
            _isLoading = false;
          });
          return;
        } else if (response.statusCode == 503) {
          await Future.delayed(const Duration(seconds: 10));
          continue;
        } else {
          throw Exception('Failed to generate code: ${response.statusCode}');
        }
      } catch (e) {
        if (retry == 2) {
          print('Exception details: $e');
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error generating code. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          await Future.delayed(const Duration(seconds: 5));
        }
      }
    }
  }

  void _copyToClipboard() {
    if (_generatedCode != null) {
      Clipboard.setData(ClipboardData(text: _generatedCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code copied to clipboard'),
          backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
        ),
      );
    }
  }

  void _initializeCodeEditor() {
    if (_generatedCode != null) {
      _codeController.text = _generatedCode!;
    }
  }

  Future<void> _runCode() async {
    final codeToRun = _codeController.text;
    if (codeToRun.isEmpty) return;

    setState(() {
      _isCompiling = true;
      _output = null;
    });

    try {
      final response = await http.post(
        Uri.parse(_compilerApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'language': _languages[_selectedLanguage],
          'version': '*',
          'files': [
            {
              'content': codeToRun,
            }
          ],
          'stdin': '',
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          if (result['run']['stderr'] != null && result['run']['stderr'].toString().isNotEmpty) {
            _output = 'Error: ${result['run']['stderr']}';
          } else {
            _output = result['run']['output'] ?? 'No output';
          }
          _isCompiling = false;
        });
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to execute code');
      }
    } catch (e) {
      print('Error details: $e');
      setState(() {
        _isCompiling = false;
        _output = 'Error: Failed to execute code. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Code Generator',
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24.0 : 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                'Generate Code',
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
                                'Describe what code you want to generate',
                                style: TextStyle(
                                  color: _textColor.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ).animate()
                                .fadeIn(duration: 600.ms, delay: 200.ms)
                                .slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _promptController,
                                style: TextStyle(color: _textColor),
                                decoration: InputDecoration(
                                  labelText: 'Code Description',
                                  labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
                                  hintText: 'Example: Create a function to calculate fibonacci series',
                                  hintStyle: TextStyle(color: _textColor.withOpacity(0.5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: _isDarkMode 
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                ),
                                maxLines: 3,
                              ).animate()
                                .fadeIn(duration: 600.ms, delay: 400.ms)
                                .slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _generateCode,
                                  icon: Icon(
                                    _isLoading ? Icons.hourglass_empty : Icons.code_rounded,
                                    color: Colors.white,
                                  ).animate(
                                    onPlay: (controller) => _isLoading ? controller.repeat() : controller.stop(),
                                  ).rotate(
                                    duration: 1.seconds,
                                  ),
                                  label: Text(
                                    _isLoading ? 'Generating...' : 'Generate Code',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isDarkMode 
                                        ? const Color(0xFF4C4DDC)
                                        : const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: _isDarkMode 
                                        ? const Color(0xFF4C4DDC).withOpacity(0.5)
                                        : const Color(0xFF2563EB).withOpacity(0.3),
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

                      if (!_isLoading && _generatedCode == null)
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
                                  'Example Prompts',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _textColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...List.generate(
                                  _examplePrompts.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _promptController.text = _examplePrompts[index];
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
                                              Icons.code,
                                              color: _isDarkMode 
                                                  ? const Color(0xFF4C4DDC)
                                                  : Colors.blue,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                _examplePrompts[index],
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

                      if (_isLoading)
                        Card(
                          elevation: 4,
                          color: _cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                const CircularProgressIndicator()
                                    .animate(onPlay: (controller) => controller.repeat())
                                    .rotate(duration: 1.seconds),
                                const SizedBox(height: 24),
                                Text(
                                  'Generating your code...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: _textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This may take a few moments',
                                  style: TextStyle(
                                    color: _textColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate()
                          .fadeIn(duration: 600.ms)
                          .scale(begin: const Offset(0.8, 0.8))

                      else if (_generatedCode != null)
                        Card(
                          elevation: 8,
                          color: _cardColor,
                          shadowColor: _isDarkMode ? Colors.black38 : Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(constraints.maxWidth > 600 ? 16.0 : 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Generated Code',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: _textColor,
                                        ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        DropdownButton<String>(
                                          value: _selectedLanguage,
                                          dropdownColor: _cardColor,
                                          style: TextStyle(color: _textColor),
                                          isDense: true,
                                          items: _languages.keys.map((String language) {
                                            return DropdownMenuItem<String>(
                                              value: language,
                                              child: Text(
                                                language.toUpperCase(),
                                                style: TextStyle(color: _textColor),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                _selectedLanguage = newValue;
                                              });
                                            }
                                          },
                                        ),
                                        IconButton(
                                          onPressed: _copyToClipboard,
                                          icon: Icon(
                                            Icons.copy,
                                            color: _isDarkMode ? Colors.white : Colors.blue,
                                          ),
                                          constraints: BoxConstraints.tightFor(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: _terminalColor,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: _isDarkMode 
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.black.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _isDarkMode 
                                              ? Colors.black.withOpacity(0.3)
                                              : Colors.grey[800],
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[400],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow[400],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[400],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Code Editor - ${_selectedLanguage.toUpperCase()}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        constraints: const BoxConstraints(
                                          maxHeight: 300,
                                          minHeight: 100,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _codeController,
                                                  style: const TextStyle(
                                                    fontFamily: 'monospace',
                                                    color: Colors.white,
                                                    height: 1.5,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Type or edit your code here...',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white.withOpacity(0.3),
                                                    ),
                                                    contentPadding: const EdgeInsets.all(8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  alignment: WrapAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _generatedCode = null;
                                          _promptController.clear();
                                          _output = null;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.refresh_rounded,
                                        color: _isDarkMode ? const Color(0xFF4C4DDC) : const Color(0xFF2563EB),
                                      ).animate(
                                        onPlay: (controller) => controller.repeat(),
                                      ).rotate(
                                        duration: 1.seconds,
                                      ),
                                      label: Text(
                                        'Generate Another',
                                        style: TextStyle(
                                          color: _isDarkMode ? const Color(0xFF4C4DDC) : const Color(0xFF2563EB),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: _isDarkMode ? const Color(0xFF4C4DDC) : const Color(0xFF2563EB),
                                          width: 2,
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ).animate()
                                      .fadeIn(duration: 400.ms)
                                      .slideX(begin: -0.2, end: 0),
                                    
                                    ElevatedButton.icon(
                                      onPressed: _isCompiling ? null : _runCode,
                                      icon: Icon(
                                        _isCompiling ? Icons.hourglass_empty : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                      ).animate(
                                        onPlay: (controller) => _isCompiling ? controller.repeat() : controller.stop(),
                                      ).rotate(
                                        duration: 1.seconds,
                                      ),
                                      label: Text(
                                        _isCompiling ? 'Running...' : 'Run Code',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isDarkMode 
                                            ? const Color(0xFF4C4DDC)
                                            : const Color(0xFF2563EB),
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor: _isDarkMode 
                                            ? const Color(0xFF4C4DDC).withOpacity(0.5)
                                            : const Color(0xFF2563EB).withOpacity(0.3),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ).animate()
                                      .fadeIn(duration: 400.ms)
                                      .slideX(begin: 0.2, end: 0),
                                  ],
                                ),
                                if (_output != null) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    'Output:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: _terminalColor,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: _isDarkMode 
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.black.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _isDarkMode 
                                                ? Colors.black.withOpacity(0.3)
                                                : Colors.grey[800],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[400],
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow[400],
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[400],
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Terminal Output',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 40),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Text(
                                                '\$ ',
                                                style: TextStyle(
                                                  color: Colors.green[400],
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: SelectableText(
                                                  _output!,
                                                  style: TextStyle(
                                                    fontFamily: 'monospace',
                                                    color: Colors.white,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
} 