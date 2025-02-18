import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:Nexia/ai/screens/VoiceChat.dart';
import 'package:Nexia/ai/screens/pdf_ai.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart'; 
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart'; // Required for animations
import 'dart:convert'; // Add this import for JSON encoding/decoding
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

import 'VoiceChat.dart' as nexia;
// import 'CustomChatMessage.dart'; // Add this import
import '../widgets/Waveform.dart';
import 'NotesPage.dart'; // Import the NotesPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;
  FlutterTts flutterTts = FlutterTts();
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
  bool isDarkMode = false; // Added dark mode variable

  // Remove predefined suggestions
  // final List<String> _suggestions = [
  //   "How are you?",
  //   "Tell me a joke.",
  //   "What's the weather today?",
  // ];
  List<String> _filteredSuggestions = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser nexiaUser = ChatUser(
    id: "1",
    firstName: "Nexia",
    profileImage:
        "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  // Add a ScrollController for the suggestions list
  final ScrollController _suggestionsScrollController = ScrollController();

  // Store the current input for auto-completion
  String _currentInput = '';

  List<String> notes = []; // List to store notes

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadMessages(); // Load messages on init
    _loadNotes(); // Load notes on init
    speechToText = stt.SpeechToText();
    _requestPermission();
    _initSpeech();

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

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false; // Load dark mode preference
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
    _focusNode.dispose();
    flutterTts.stop();
    controller.dispose();
    _suggestionsScrollController.dispose(); // Dispose the ScrollController
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


String _cleanResponse(String response) {
  // Define a map of words to replace
  Map<String, String> replacements = {
    'Gemini': 'Nexia',
    'Google': 'Nexia',
  };

  // Replace each word in the map
  replacements.forEach((key, value) {
    response = response.replaceAll(key, value);
  });

  // Remove unwanted characters like asterisks
  response = response.replaceAll('*', ''); // Removes "*" from the response
  return response;
}

 void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    _saveMessages(); // Save after sending
    try {
      // Combine all previous messages into a single string
      String history = messages.reversed.map((msg) => msg.text).join('\n');
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      gemini
          .streamGenerateContent(
        history + '\n' + question, // Include the entire chat history
        images: images,
      )
          .listen((event) async {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";

        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user.id == nexiaUser.id) {
          lastMessage = messages.removeAt(0);
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          ChatMessage message = ChatMessage(
            user: nexiaUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
        _saveMessages(); // Save after receiving
      });
    } catch (e) {
      print(e);
    }
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
                  
                  // Message Text
                  Text(
                    isAI ? _cleanResponse(message.text) : message.text,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  
                  // Action Buttons for AI messages
                  if (isAI) ...[
                    SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy,
                            onPressed: () {
                            Clipboard.setData(ClipboardData(text: message.text));
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
                                notes.add(message.text);
                              });
                              _saveNotes();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Message saved as note!')),
                              );
                            },
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
                  child: Row(
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
    );
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

  ChatMessage({
    required this.user,
    required this.createdAt,
    required this.text,
    this.medias,
  });

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'text': text,
      'medias': medias?.map((media) => media.toJson()).toList(),
    };
  }

  // Add fromJson factory
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
