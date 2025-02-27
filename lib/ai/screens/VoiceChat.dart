import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceChat extends StatefulWidget {
  @override
  _VoiceChatState createState() => _VoiceChatState();
}

class _VoiceChatState extends State<VoiceChat>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  final Gemini gemini = Gemini.instance;
  FlutterTts flutterTts = FlutterTts();
  List<ChatMessage> messages = [];
  bool isDarkMode = false;

  late stt.SpeechToText speechToText;
  bool _isListening = false;
  bool isTyping = false;
  bool isGenerating = false;
  String _text = '';
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
    "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  final ScrollController _scrollController = ScrollController();
  double _confidenceLevel = 0.0;

  // Update API key handling
  String get _huggingFaceApiKey => dotenv.env['HUGGING_FACE_TOKEN'] ?? '';
  String get _geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Add new variables for Hugging Face
  bool useHuggingFace = false;
  String huggingFaceModel = 'facebook/blenderbot-400M-distill';
  
  ChatUser huggingFaceUser = ChatUser(
    id: "2",
    firstName: "HuggingFace",
    profileImage:
        "https://huggingface.co/front/assets/huggingface_logo-noborder.svg",
  );

  // Add model options
  final List<String> availableModels = [
    'facebook/blenderbot-400M-distill',
    'microsoft/DialoGPT-medium',
    'EleutherAI/gpt-neo-1.3B'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    speechToText = stt.SpeechToText();
    _initSpeech();

    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);
    _listen();

    // Initialize confidence level listener
    speechToText.statusListener = (status) {
      if (status == 'listening') {
        setState(() => _confidenceLevel = 0.0);
      }
    };

    // Initialize Gemini with API key
    Gemini.init(apiKey: _geminiApiKey);
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
      isGenerating = true;
    });

    try {
      String response;
      if (useHuggingFace) {
        response = await _getHuggingFaceResponse(chatMessage.text);
        setState(() {
          messages = [
            ChatMessage(
              user: huggingFaceUser,
              createdAt: DateTime.now(),
              text: _cleanResponse(response),
            ),
            ...messages,
          ];
          isGenerating = false;
        });
        
        await flutterTts.speak(response);
        flutterTts.setCompletionHandler(() {
          _listen();
        });
      } else {
        // Existing Gemini implementation
        StringBuffer responseBuffer = StringBuffer();
        await for (final event in gemini.streamGenerateContent(chatMessage.text)) {
          String responsePart = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ?? "";

          responseBuffer.write(_cleanResponse(responsePart));

          setState(() {
            if (messages.isNotEmpty && messages.first.user == geminiUser) {
              messages[0] = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: responseBuffer.toString(),
              );
            } else {
              messages = [
                ChatMessage(
                  user: geminiUser,
                  createdAt: DateTime.now(),
                  text: responseBuffer.toString(),
                ),
                ...messages,
              ];
            }
          });
        }

        String finalResponse = responseBuffer.toString();
        await flutterTts.speak(finalResponse);
        flutterTts.setCompletionHandler(() {
          _listen();
        });
      }
    } catch (e) {
      print('Error generating response: $e');
      setState(() {
        isGenerating = false;
        messages = [
          ChatMessage(
            user: useHuggingFace ? huggingFaceUser : geminiUser,
            createdAt: DateTime.now(),
            text: 'Sorry, I encountered an error. Please try again.',
          ),
          ...messages,
        ];
      });
    }
  }

  String _cleanResponse(String response) {
    // Define a map of words to replace
    Map<String, String> replacements = {
      'Gemini': 'Nexia',
      'Google': 'Vishnu',
    };

    replacements.forEach((key, value) {
      response = response.replaceAll(key, value);
    });

    return response;
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        print('Starting to listen...');
        setState(() {
          isGenerating = false;
          _isListening = true;
          _text = '';  // Reset the text
        });

        // Start listening
        speechToText.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            print('Speech recognized: $_text');
            if (result.finalResult) {
              ChatMessage chatMessage = ChatMessage(
                user: currentUser,
                createdAt: DateTime.now(),
                text: _text,
              );
              _sendMessage(chatMessage);
              setState(() => _isListening = false);
            }
          },
        );

        // Add a timeout to stop listening if there's no input
        Future.delayed(Duration(seconds: 7), () {
          if (_text.isEmpty && _isListening) {
            speechToText.stop();
            setState(() {
              _isListening = false;
            });
          }
        });
      } else {
        print('Speech recognition not available');
      }
    } else {
      speechToText.stop();
      setState(() => _isListening = false);
    }
  }


  void _stopTTS() async {
    if (isGenerating) {
      await flutterTts.stop();
      setState(() {
        isGenerating = false;
        _isListening = false;
      });
    }
  }


  Future<void> _initSpeech() async {
    bool available = await speechToText.initialize(
      onStatus: (val) => print('Speech Status: $val'),
      onError: (val) => print('Speech Error: $val'),
    );
    print('Speech Recognition available: $available');
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(geminiUser.profileImage!),
              ),
            ),
          ),
          SizedBox(width: 12),
          Lottie.network(
            'https://assets1.lottiefiles.com/packages/lf20_b88nh30c.json',
            width: 60,
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: messages.length + (isGenerating ? 1 : 0),
          itemBuilder: (context, index) {
            if (isGenerating && index == 0) {
              return _buildTypingIndicator();
            }
            
            final messageIndex = isGenerating ? index - 1 : index;
            final message = messages[messageIndex];
            final isUser = message.user == currentUser;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    CircleAvatar(
                      backgroundImage: NetworkImage(geminiUser.profileImage!),
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser 
                            ? (isDarkMode ? Colors.blue[700] : Colors.blue[100])
                            : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildModelSelector(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => messages.clear());
            },
            icon: Icon(
              Icons.delete_outline,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            tooltip: 'Clear Chat',
          ),
          IconButton(
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [Colors.grey[900]!, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: Column(
          children: [
            _buildMessageList(),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_isListening)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(
                        value: _confidenceLevel,
                        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDarkMode ? Colors.blue[700]! : Colors.blue,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.stop,
                        color: Colors.red,
                        onPressed: isGenerating ? _stopTTS : null,
                        label: "Stop",
                      ),
                      _buildActionButton(
                        icon: Icons.mic,
                        color: _isListening ? Colors.red : Colors.green,
                        onPressed: !isGenerating ? _listen : null,
                        label: _isListening ? "Listening..." : "Start",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _buttonAnimation,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(icon, color: color),
              onPressed: onPressed,
              iconSize: 28,
              padding: EdgeInsets.all(12),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Add model selection
  void _toggleModel() {
    setState(() {
      useHuggingFace = !useHuggingFace;
    });
  }

  // Add Hugging Face API call with improved error handling
  Future<String> _getHuggingFaceResponse(String input) async {
    try {
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/$huggingFaceModel'),
        headers: {
          'Authorization': 'Bearer $_huggingFaceApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': input,
          'parameters': {
            'max_length': 1000,
            'temperature': 0.7,
            'top_p': 0.9,
            'repetition_penalty': 1.2,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0]['generated_text'] ?? 'No response generated';
        }
        return 'Invalid response format';
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception details: $e');
      return 'Error: Unable to generate response. Please try again.';
    }
  }

  // Add model selection dialog
  void _showModelSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Model'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableModels.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(availableModels[index]),
                selected: huggingFaceModel == availableModels[index],
                onTap: () {
                  setState(() {
                    huggingFaceModel = availableModels[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Update the AppBar title to include model selection
  Widget _buildModelSelector() {
    return GestureDetector(
      onTap: _toggleModel,
      onLongPress: useHuggingFace ? _showModelSelector : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              useHuggingFace 
                  ? huggingFaceUser.profileImage!
                  : geminiUser.profileImage!,
            ),
            radius: 15,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                useHuggingFace ? 'HuggingFace' : 'Gemini',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              if (useHuggingFace)
                Text(
                  huggingFaceModel.split('/').last,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Box extends StatelessWidget {
  final double scaleFactor;
  final double borderFactor;
  final int delay;
  final AnimationController controller;
  final Color borderColor;

  Box(this.scaleFactor, this.borderFactor, this.delay, this.controller,
      this.borderColor);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double animationValue =
            sin((controller.value + delay * 0.2) * pi * 2) * 0.15 + 1.0;
        return Transform.scale(
          scale: animationValue,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            width: 250 * scaleFactor,
            height: 250 * scaleFactor,
          ),
        );
      },
    );
  }
}

class LogoBox extends StatelessWidget {
  final AnimationController controller;

  LogoBox(this.controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Icon(
          Icons.music_note, // Replace with your desired icon or SVG.
          color: controller.value < 0.5 ? Colors.grey : Colors.white,
          size: 80,
        );
      },
    );
  }
}
