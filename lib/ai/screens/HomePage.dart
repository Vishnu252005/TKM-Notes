import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';  // Add this import for Timer
import 'package:Nexia/ai/screens/VoiceChat.dart';
import 'package:Nexia/ai/screens/pdf_ai.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart'; 
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'VoiceChat.dart' as nexia;
import '../widgets/Waveform.dart';
import 'NotesPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Add short response mode state
  bool _isShortMode = true;

  // Get API token from environment variables
  String get _apiToken => dotenv.env['HUGGING_FACE_TOKEN'] ?? '';
  
  // Using Mistral-7B-Instruct model which is free and powerful
  static const String _apiUrl = 'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2';
  
  FlutterTts flutterTts = FlutterTts();

  // Add typing indicator variables
  bool _isTyping = false;
  final List<String> _typingDots = ['', '.', '..', '...'];
  int _currentDotIndex = 0;
  Timer? _typingTimer;

  // Add spam protection variables
  DateTime? _lastMessageTime;
  static const int _minMessageInterval = 2; // Minimum seconds between messages

  List<ChatMessage> messages = [];
  late SharedPreferences prefs;

  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  late stt.SpeechToText speechToText;
  bool _isListening = false;
  bool _isGenerating = false;
  bool isTyping = false;
  String _text = '';
  bool isDarkMode = true;

  List<String> _filteredSuggestions = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser nexiaUser = ChatUser(
    id: "1",
    firstName: "Nexia",
    profileImage: "https://huggingface.co/front/assets/huggingface_logo-noborder.svg",
  );

  final ScrollController _suggestionsScrollController = ScrollController();
  String _currentInput = '';
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadMessages();
    _loadNotes();
    speechToText = stt.SpeechToText();
    _requestPermission();
    _initSpeech();

    // Initialize typing animation timer
    _typingTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_isTyping) {
        setState(() {
          _currentDotIndex = (_currentDotIndex + 1) % _typingDots.length;
        });
      }
    });

    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

    flutterTts.setCompletionHandler(() {
      setState(() {
        _isGenerating = false;
      });
    });

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  // Add this method to check for spam
  bool _isSpam(String message) {
    // Check for cooldown period only
    if (_lastMessageTime != null) {
      final timeDiff = DateTime.now().difference(_lastMessageTime!).inSeconds;
      if (timeDiff < _minMessageInterval) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please wait a moment before sending another message.'),
            backgroundColor: Colors.orange,
          ),
        );
        return true;
      }
    }

    // Update last message time
    _lastMessageTime = DateTime.now();
    return false;
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    // Check for spam before proceeding
    if (_isSpam(chatMessage.text)) {
      return;
    }

    setState(() {
      messages = [chatMessage, ...messages];
      _isGenerating = true;
      _isTyping = true;
    });
    _saveMessages();

    try {
      // Add typing indicator message
      ChatMessage typingMessage = ChatMessage(
        user: nexiaUser,
        createdAt: DateTime.now(),
        text: "Typing...",
        isTypingIndicator: true,
      );

      setState(() {
        messages = [typingMessage, ...messages.where((m) => !m.isTypingIndicator)];
      });

      // Format the conversation in Mistral's expected format
      String prompt = "";
      
      // Add conversation history
      final recentMessages = messages.reversed.take(2).toList(); // Reduced context to last 2 messages only
      for (var msg in recentMessages.reversed) {
        if (msg.user.id == currentUser.id) {
          prompt += "<user>${msg.text}</user>\n";
        } else {
          prompt += "<assistant>${msg.text}</assistant>\n";
        }
      }
      
      // Add system context for better initial responses
      if (messages.length <= 1) {
        prompt = """<system>You are Nexia, a casual chatbot. STRICT RULES:
1. ${_isShortMode ? 'Keep it to ONE short sentence' : 'Use 2-3 sentences to explain'}
2. Use super casual language (like texting a friend)
3. ${_isShortMode ? 'Never give long explanations' : 'Give clear but concise explanations'}
4. Never analyze or question the user's text
5. Never mention previous messages
6. No greetings or formalities</system>\n""" + prompt;
      }
      
      // Add the current message
      prompt += "<user>${chatMessage.text}</user>";

      final Map<String, dynamic> requestBody = {
        'inputs': prompt,
        'parameters': {
          'temperature': 1.0,
          'max_new_tokens': _isShortMode ? 30 : 100, // Adjust length based on mode
          'top_p': 0.9,
          'return_full_text': false,
          'do_sample': true,
          'repetition_penalty': 1.5
        }
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          String aiResponse = data[0]['generated_text'] ?? "I apologize, but I couldn't generate a response.";
          
          // Clean and format the response
          aiResponse = _cleanResponse(aiResponse);
          
          ChatMessage message = ChatMessage(
            user: nexiaUser,
            createdAt: DateTime.now(),
            text: aiResponse,
          );

          setState(() {
            messages = [message, ...messages.where((m) => !m.isTypingIndicator)];
            _isGenerating = false;
            _isTyping = false;
          });
          _saveMessages();
          
          // Read response aloud if text-to-speech is enabled
          if (_isGenerating) {
            await flutterTts.speak(aiResponse);
          }
        }
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling Hugging Face API: $e');
      setState(() {
        _isGenerating = false;
        _isTyping = false;
      });
      
      ChatMessage errorMessage = ChatMessage(
        user: nexiaUser,
        createdAt: DateTime.now(),
        text: "I apologize, but I encountered an error. Please try again.",
      );
      
      setState(() {
        messages = [errorMessage, ...messages.where((m) => !m.isTypingIndicator)];
      });
      _saveMessages();
    }
  }

  String _cleanResponse(String response) {
    // First remove any XML-like tags and their content
    response = response.replaceAll(RegExp(r'<[^>]*>.*?</[^>]*>'), '');
    response = response.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Define replacements with proper escaping
    final replacements = <String, String>{
      'AI': 'Nexia',
      'Assistant': 'Nexia',
      'Hugging Face': 'Nexia',
      'Mistral': 'Nexia',
    };

    replacements.forEach((key, value) {
      response = response.replaceAll(RegExp(key, caseSensitive: false), value);
    });

    // Remove common formal phrases and greetings
    final phrasesToRemove = [
      r'absolutely[\s!]*',
      r'sure[\s!]*',
      r'of course[\s!]*',
      r'certainly[\s!]*',
      r'I would be happy to help[\s!]*',
      r'let me explain[\s!]*',
      r'in simple terms[\s,]*',
      r'basically[\s,]*',
      r'to put it simply[\s,]*',
      r'it appears[\s,]*',
      r'it seems[\s,]*',
      r'it looks like[\s,]*',
      r'could you[\s,]*',
      r'would you[\s,]*',
      r'please[\s,]*',
      r'kindly[\s,]*',
      r'I notice[\s,]*',
      r'I see[\s,]*',
      r'I understand[\s,]*'
    ];

    for (final phrase in phrasesToRemove) {
      response = response.replaceAll(RegExp(phrase, caseSensitive: false), '');
    }

    // Remove special characters and formatting markers
    response = response
      .replaceAll(RegExp(r'\\[0-9]+'), '') // Remove \1, \2, etc.
      .replaceAll(RegExp(r'\[.*?\]'), '') // Remove [text]
      .replaceAll(RegExp(r'\{.*?\}'), '') // Remove {text}
      .replaceAll(RegExp(r'\\[a-zA-Z]'), '') // Remove \n, \t, etc.
      .replaceAll('"', '') // Remove double quotes
      .replaceAll("'", '') // Remove single quotes
      .replaceAll('"', '') // Remove smart double quotes
      .replaceAll(''', '') // Remove smart single quotes
      .replaceAll(''', ''); // Remove smart single quotes
    
    // Clean up extra whitespace and formatting
    response = response
      .trim()
      .replaceAll(RegExp(r'\s{2,}'), ' ') // Replace multiple spaces with single space
      .replaceAll(RegExp(r'([.!?])\s*'), r'\1 '); // Add space after punctuation

    // Remove any analysis of user's message
    final analysisPatterns = [
      r'^your message.*$',
      r'^you seem.*$',
      r'^you sound.*$', 
      r'^you are.*$',
      r'^youre.*$',
      r'^you appear.*$',
      r'^you mentioned.*$',
      r'^did you mean.*$',
      r'^did you intend.*$',
      r'^are you trying.*$',
      r'^are you saying.*$'
    ];

    for (final pattern in analysisPatterns) {
      response = response.replaceAll(RegExp(pattern, caseSensitive: false), '');
    }

    // Ensure the response starts with a capital letter if it doesn't
    if (response.isNotEmpty && response[0].toLowerCase() == response[0]) {
      response = response[0].toUpperCase() + response.substring(1);
    }

    return response.trim();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? true; // Load dark mode preference, default to true
    });
  }

  // Load messages from SharedPreferences
  Future<void> _loadMessages() async {
    final String? storedMessages = prefs.getString('messages');
    if (storedMessages != null) {
      List<dynamic> decoded = jsonDecode(storedMessages);
      setState(() {
        messages = decoded.map((msg) => ChatMessage.fromJson(msg)).toList();
      });
    }
  }

  // Save messages to SharedPreferences
  Future<void> _saveMessages() async {
    List<Map<String, dynamic>> encoded =
        messages.map((msg) => msg.toJson()).toList();
    await prefs.setString('messages', jsonEncode(encoded));
  }

  // Load notes from SharedPreferences
  Future<void> _loadNotes() async {
    final String? storedNotes = prefs.getString('notes');
    if (storedNotes != null) {
      setState(() {
        notes = List<String>.from(jsonDecode(storedNotes));
      });
    }
  }

  // Save notes to SharedPreferences
  Future<void> _saveNotes() async {
    await prefs.setString('notes', jsonEncode(notes));
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _focusNode.dispose();
    flutterTts.stop();
    controller.dispose();
    _suggestionsScrollController.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        await Permission.microphone.request();
      }
    }
  }

  Future<void> _initSpeech() async {
    bool available = await speechToText.initialize(
      onStatus: (val) => print('Speech Status: $val'),
      onError: (val) => print('Speech Error: $val'),
    );
    print('Speech Recognition available: $available');
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        print('Starting to listen...');
        setState(() => _isListening = true);
        speechToText.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            print('Speech recognized: $_text');
            controller.text = _text;
            setState(() => _isListening = false);
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } else {
      speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _readAloud(String message) async {
    await flutterTts.speak(message);
    setState(() {
      _isGenerating = true;
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Upload Image'),
                subtitle: Text('PNG, JPG'),
                onTap: () {
                  Navigator.pop(context);
                  _sendMediaMessage();
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text('Upload Document'),
                subtitle: Text('PDF only'),
                onTap: () {
                  Navigator.pop(context);
                  _sendDocumentMessage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendDocumentMessage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfChat(
            fileBytes: fileBytes,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a PDF document.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1A1A2E) : Colors.blue[50],
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.03)
                    : Colors.blue.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            children: [
              // Enhanced Glass Effect Header
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode 
                            ? [
                                Color(0xFF4C4DDC),
                                Color(0xFF1A1A2E),
                              ]
                            : [
                                Colors.blue[400]!,
                                Colors.blue[100]!,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.psychology_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'NEXIA AI',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                                    color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                                      prefs.setBool('isDarkMode', isDarkMode);
              });
            },
          ),
          IconButton(
                                  icon: Icon(Icons.note, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                                      MaterialPageRoute(
                                        builder: (context) => NotesPage(notes: notes),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'How can I help\nyou today?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Chat Messages
              Expanded(
                child: _chatUI(),
              ),

              // Enhanced Input Field
              _buildEnhancedTextField(),
            ],
          ),
        ],
      ),
    );
  }

Widget _chatUI() {
    return ListView.builder(
      reverse: true,
          controller: scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
        final message = messages[index];
        final isAI = message.user.id == nexiaUser.id;
        return _buildMessageBubble(message, isAI);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isAI) {
    if (message.isTypingIndicator) {
      return _buildTypingIndicator();
    }

    // Format the message text with proper line breaks and spacing
    String formattedText = isAI ? _formatAIResponse(message.text) : message.text;

    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Icon
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isAI 
                  ? (isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.1) : Colors.blue[50])
                  : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[100]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAI 
                    ? (isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.2) : Colors.blue.withOpacity(0.2))
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              isAI ? Icons.psychology : Icons.person,
              color: isAI 
                  ? (isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700])
                  : (isDarkMode ? Colors.white : Colors.grey[600]),
              size: 20,
            ),
          ),
          
          // Message Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isAI
                    ? (isDarkMode ? Color(0xFF252542) : Colors.white)
                    : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isAI 
                      ? (isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.2) : Colors.blue.withOpacity(0.1))
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: isAI ? [
                  BoxShadow(
                    color: isDarkMode 
                        ? Colors.black.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.1),
                    offset: Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(isDarkMode ? 0.1 : 1),
                    offset: Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ] : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender Name
                  if (isAI) ...[
                    Row(
                      children: [
                        Text(
                          'Nexia AI',
                          style: TextStyle(
                            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                          size: 14,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  // Message Text with Rich Text Formatting
                  SelectableText(
                    formattedText,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  
                  // Action Buttons for AI messages
                  if (isAI) ...[
                    SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: formattedText));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Message copied to clipboard!')),
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.note_add,
                          onPressed: () {
                            setState(() {
                              notes.add(formattedText);
                            });
                            _saveNotes();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Message saved as note!')),
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.volume_up,
                          onPressed: () => _readAloud(formattedText),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: Duration(milliseconds: 500))
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 16,
          color: isDarkMode 
              ? Colors.white.withOpacity(0.7)
              : Colors.grey[600],
        ),
        constraints: BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildEnhancedTextField() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.blue.withOpacity(0.1),
            offset: Offset(4, 4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(isDarkMode ? 0.1 : 1),
            offset: Offset(-4, -4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Add response mode toggle
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Response:',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShortMode = !_isShortMode;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? Color(0xFF4C4DDC).withOpacity(_isShortMode ? 0.2 : 0.1)
                          : Colors.blue.withOpacity(_isShortMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isShortMode ? 'Short' : 'Long',
                      style: TextStyle(
                        color: isDarkMode 
                            ? Color(0xFF4C4DDC)
                            : Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.photo,
                  color: isDarkMode 
                      ? Color(0xFF4C4DDC)
                      : Colors.blue[700],
                ),
                onPressed: _showUploadOptions,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: _focusNode,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.blue[900],
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    hintStyle: TextStyle(
                      color: isDarkMode 
                          ? Colors.white.withOpacity(0.5)
                          : Colors.blue[900]?.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: isDarkMode 
                      ? Color(0xFF4C4DDC)
                      : Colors.blue[700],
                ),
                onPressed: _listen,
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: isDarkMode 
                      ? Color(0xFF4C4DDC)
                      : Colors.blue[700],
                ),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _sendMessage(ChatMessage(
                      user: currentUser,
                      createdAt: DateTime.now(),
                      text: controller.text,
                    ));
                    controller.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Icon
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.1) : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              ),
            ),
            child: Icon(
              Icons.psychology,
              color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
              size: 20,
            ),
          ),
          
          // Typing Indicator
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.2) : Colors.blue.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.blue.withOpacity(0.1),
                    offset: Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(isDarkMode ? 0.1 : 1),
                    offset: Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Nexia is typing${_typingDots[_currentDotIndex]}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.blue[700],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildBouncingDots(),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: Duration(milliseconds: 300))
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildBouncingDots() {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: CircleAvatar(
            radius: 3,
            backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
          ),
        ).animate(
          onPlay: (controller) => controller.repeat(),
        ).moveY(
          begin: 0,
          end: -5,
          duration: Duration(milliseconds: 600),
          delay: Duration(milliseconds: index * 200),
          curve: Curves.easeInOut,
        );
      }),
    );
  }

  // Add this method to format AI responses
  String _formatAIResponse(String text) {
    // Clean the response first
    text = _cleanResponse(text);
    
    // Add proper line breaks for lists (using a simpler, valid pattern)
    text = text.replaceAll(RegExp(r'^[-•*] ', multiLine: true), '\n• ');
    
    // Add spacing after periods and question marks if not already present
    text = text.replaceAll(RegExp(r'([.?!])\s*'), r'\1 ');
    
    // Add paragraph breaks
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    // Ensure proper spacing around lists
    text = text.replaceAll(RegExp(r'\n• '), '\n\n• ');
    
    // Remove extra whitespace
    text = text.trim().replaceAll(RegExp(r'\s{2,}'), ' ');
    
    // Ensure proper spacing around code blocks
    text = text.replaceAll(RegExp(r'```(\w+)?\n'), '\n\n```\n');
    text = text.replaceAll(RegExp(r'\n```\n'), '\n```\n\n');
    
    return text;
  }
}

class ChatUser {
  final String id;
  final String firstName;
  final String? profileImage;

  ChatUser({
    required this.id,
    required this.firstName,
    this.profileImage,
  });

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'profileImage': profileImage,
    };
  }

  // Add fromJson factory
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      firstName: json['firstName'],
      profileImage: json['profileImage'],
    );
  }
}

class ChatMessage {
  final ChatUser user;
  final DateTime createdAt;
  String text;
  List<ChatMedia>? medias;
  bool isTypingIndicator;

  ChatMessage({
    required this.user,
    required this.createdAt,
    required this.text,
    this.medias,
    this.isTypingIndicator = false,
  });

  // Update toJson method
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'text': text,
      'medias': medias?.map((media) => media.toJson()).toList(),
      'isTypingIndicator': isTypingIndicator,
    };
  }

  // Update fromJson factory
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      user: ChatUser.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      text: json['text'],
      medias: json['medias'] != null
          ? (json['medias'] as List)
              .map((media) => ChatMedia.fromJson(media))
              .toList()
          : null,
      isTypingIndicator: json['isTypingIndicator'] ?? false,
    );
  }
}

class ChatMedia {
  final String url;
  final String fileName;
  final MediaType type;

  ChatMedia({
    required this.url,
    required this.fileName,
    required this.type,
  });

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'fileName': fileName,
      'type': type.toString(),
    };
  }

  // Add fromJson factory
  factory ChatMedia.fromJson(Map<String, dynamic> json) {
    return ChatMedia(
      url: json['url'],
      fileName: json['fileName'],
      type: MediaType.values.firstWhere((e) => e.toString() == json['type']),
    );
  }
}

// Ensure MediaType enum is defined correctly
enum MediaType {
  image,
  video,
  audio,
  // Add other types as needed
}

class DotPatternPainter extends CustomPainter {
  final Color color;
  
  DotPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final double spacing = 20;
    final double radius = 1;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}