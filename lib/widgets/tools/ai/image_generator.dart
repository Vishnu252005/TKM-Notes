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

  // Using environment variable for API token
  String get _apiToken => dotenv.env['HUGGING_FACE_TOKEN'] ?? 'default_value';

  // API configuration
  static const String _apiUrl = 'https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-2';

  final List<String> _examplePrompts = [
    "A magical forest at sunset",
    "Cyberpunk city street at night",
    "Watercolor painting of mountains",
    "Cute robot making coffee",
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

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': _promptController.text,
          'parameters': {
            'negative_prompt': 'blurry, bad quality',
            'num_inference_steps': 25,
            'guidance_scale': 7.0,
          }
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _generatedImage = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        print('Error response: ${response.body}'); // For debugging
        throw Exception('Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception details: $e'); // For debugging
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating image: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
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
                          ).animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
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
}
