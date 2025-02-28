import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';  // Add this import for TimeoutException

class ImageGenerator extends StatefulWidget {
  const ImageGenerator({super.key});

  @override
  State<ImageGenerator> createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  final TextEditingController _promptController = TextEditingController();
  Uint8List? _generatedImage;
  bool _isLoading = false;
  bool _isDarkMode = true; // Track theme mode
  bool _isTokenValid = false;

  // Using environment variable for API token
  String get _apiToken => dotenv.env['HUGGING_FACE_TOKEN'] ?? '';

  // Update API configuration to use OpenJourney model
  static const String _apiUrl = 'https://api-inference.huggingface.co/models/prompthero/openjourney';

  final List<String> _examplePrompts = [
    "A serene Japanese garden with cherry blossoms",
    "A futuristic neon-lit cityscape at night",
    "A cozy coffee shop interior with warm lighting",
    "A majestic dragon soaring through clouds",
  ];

  // Add theme colors
  late final ThemeData _theme;
  
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
    _validateToken();
  }

  Future<void> _validateToken() async {
    if (_apiToken.isEmpty || _apiToken == 'default_value') {
      setState(() => _isTokenValid = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please set your Hugging Face API token in the .env file'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 8),
          ),
        );
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api-inference.huggingface.co/models/prompthero/openjourney'),
        headers: {'Authorization': 'Bearer $_apiToken'},
      );

      setState(() => _isTokenValid = response.statusCode != 401);
      
      if (!_isTokenValid) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid Hugging Face API token. Please check your .env file'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 8),
            ),
          );
        });
      }
    } catch (e) {
      print('Token validation error: $e');
      // Set token as valid even if there's a network error to allow attempts
      setState(() => _isTokenValid = true);
    }
  }

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedImage = null;
    });

    const int maxRetries = 3;
    const int timeoutSeconds = 45;

    for (int retry = 0; retry < maxRetries; retry++) {
      try {
        // Format the prompt for OpenJourney (Midjourney-style prompts)
        final String formattedPrompt = """
mdjrny-v4 style ${_promptController.text}, 4k, high quality, highly detailed
""".trim();

        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            'Authorization': 'Bearer $_apiToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'inputs': formattedPrompt,
            'parameters': {
              'negative_prompt': 'ugly, blurry, poor quality, deformed, malformed',
              'num_inference_steps': 25,
              'guidance_scale': 7.5,
              'width': 512,
              'height': 512,
            }
          }),
        ).timeout(
          Duration(seconds: timeoutSeconds),
          onTimeout: () {
            throw TimeoutException('Request timed out');
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            _generatedImage = response.bodyBytes;
            _isLoading = false;
          });
          return;
        } else if (response.statusCode == 503) {
          // Model is loading, wait and retry
          if (retry < maxRetries - 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Model is warming up, retrying in 5 seconds...'),
                duration: Duration(seconds: 4),
              ),
            );
            await Future.delayed(const Duration(seconds: 5));
            continue;
          }
          throw Exception('Model is still loading after multiple retries');
        } else {
          print('Error response: ${response.statusCode} - ${response.body}');
          throw Exception('Failed to generate image: ${response.statusCode}');
        }
      } catch (e) {
        print('Attempt ${retry + 1} failed: $e');
        
        if (retry == maxRetries - 1) {
          setState(() {
            _isLoading = false;
          });
          
          String errorMessage;
          if (e is TimeoutException) {
            errorMessage = 'Request timed out. Please try again.';
          } else if (e.toString().contains('token')) {
            errorMessage = 'Please check your Hugging Face API token in the .env file.';
          } else if (e.toString().contains('Failed to fetch')) {
            errorMessage = 'Network error. Please check your internet connection.';
          } else {
            errorMessage = 'Failed to generate image. Please try again later.';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: _generateImage,
              ),
            ),
          );
          return;
        }
        
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  Future<void> _downloadImage() async {
    if (_generatedImage == null) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Preparing image...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      );

      if (kIsWeb) {
        final blob = html.Blob([_generatedImage], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download = 'generated_image.png';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image downloaded successfully')),
        );
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/generated_image.png');
        await file.writeAsBytes(_generatedImage!);

        Navigator.pop(context); // Close loading dialog

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
              title: Text(
                'Image Saved',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: Text(
                'What would you like to do with the image?',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await OpenFile.open(file.path);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.open_in_new),
                  label: Text('Open'),
                  style: TextButton.styleFrom(
                    foregroundColor: _isDarkMode ? Colors.white : Colors.blue,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Share.shareXFiles([XFile(file.path)], text: 'Generated Image');
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  style: TextButton.styleFrom(
                    foregroundColor: _isDarkMode ? Colors.white : Colors.blue,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                  label: Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: _isDarkMode ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Image Generator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        )
            .animate()
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
                    shadowColor: _isDarkMode 
                        ? Colors.black38
                        : Colors.black12,
                    color: _cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Your Image',
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
                            'Enter a detailed description of the image you want to generate',
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
                              labelText: 'Image Description',
                              labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
                              hintText: 'Be creative with your description...',
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
                            focusNode: FocusNode(
                              canRequestFocus: true,
                              skipTraversal: false,
                            ),
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            mouseCursor: MaterialStateMouseCursor.textable,
                          ).animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: _buildGenerateButton(),
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

                  // Example Prompts
                  if (!_isLoading && _generatedImage == null)
                    Card(
                      elevation: 4,
                      color: _cardColor,
                      shadowColor: _isDarkMode 
                          ? Colors.black38
                          : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Try These Prompts',
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
                                          Icons.lightbulb_outline,
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
                              'Creating your masterpiece...',
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

                  else if (_generatedImage != null)
                    Card(
                      elevation: 8,
                      color: _cardColor,
                      shadowColor: _isDarkMode 
                          ? Colors.black38
                          : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Generated Image',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                _generatedImage!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _generatedImage = null;
                                        _promptController.clear();
                                      });
                                    },
                                    icon: Icon(Icons.refresh, color: _isDarkMode ? Colors.white : Colors.blue),
                                    label: Text(
                                      'Generate Another',
                                      style: TextStyle(
                                        color: _isDarkMode ? Colors.white : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _downloadImage,
                                    icon: Icon(Icons.download, color: _isDarkMode ? Colors.white : Colors.blue),
                                    label: Text(
                                      'Download',
                                      style: TextStyle(
                                        color: _isDarkMode ? Colors.white : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  Widget _buildGenerateButton() {
    if (!_isTokenValid) {
      return ElevatedButton.icon(
        onPressed: _validateToken,
        icon: Icon(Icons.refresh, color: Colors.white),
        label: Text(
          'Check API Token',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _generateImage,
      icon: Icon(
        _isLoading ? Icons.hourglass_empty : Icons.auto_awesome,
        color: _isLoading 
            ? (_isDarkMode ? Colors.white38 : Colors.black38)
            : Colors.white,
      ),
      label: Text(
        _isLoading ? 'Creating Magic...' : 'Generate Image',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _isLoading 
              ? (_isDarkMode ? Colors.white38 : Colors.black38)
              : Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLoading
            ? (_isDarkMode ? Colors.white12 : Colors.grey.shade200)
            : (_isDarkMode 
                ? const Color(0xFF4C4DDC)
                : Colors.blue.shade600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: _isLoading ? 0 : 4,
        shadowColor: _isDarkMode 
            ? const Color(0xFF4C4DDC).withOpacity(0.5)
            : Colors.blue.shade300,
      ),
    );
  }
}
