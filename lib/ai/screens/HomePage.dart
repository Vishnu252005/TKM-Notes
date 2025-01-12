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
import 'package:flutter/animation.dart'; // Required for animations
import 'dart:convert'; // Add this import for JSON encoding/decoding

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
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Ensure fully dark background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black), // Updated icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
          tooltip: 'Back',
        ),
        title: const Text('Ask Nexia'),
        titleTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                prefs.setBool('isDarkMode', isDarkMode); // Save preference
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.note, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage(notes: notes)),
              );
            },
            tooltip: 'View Notes',
          ),
        ],
      ),
      body: _chatUI(),
    );
  }

// Import for Clipboard functionality
// Import for Clipboard functionality
Widget _chatUI() {
  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          controller: scrollController,
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            ChatMessage message = messages[index];

            // Check if the message is a response from the AI
            bool isAI = message.user.id != "0";

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 8.0, right: 8.0),
              child: Align(
                alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isAI
                        ? (isDarkMode ? Colors.blueGrey.shade800 : Colors.blueGrey.shade100)
                        : (isDarkMode ? Colors.blueAccent.shade700 : Colors.blueAccent.shade100),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: isAI ? Radius.circular(0) : Radius.circular(12),
                      bottomRight: isAI ? Radius.circular(12) : Radius.circular(0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _cleanResponse(message.text),
                          style: TextStyle(
                            color: isAI ? (isDarkMode ? Colors.white : Colors.black87) : (isDarkMode ? Colors.white : Colors.black87),
                            fontWeight: isAI ? FontWeight.bold : FontWeight.normal,
                            fontSize: isAI ? 16 : 16,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                      if (isAI)
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.copy, size: 18, color: isDarkMode ? Colors.white : Colors.black54),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: message.text)).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Message copied to clipboard!')),
                                );
                              });
                            },
                          ),
                        ),
                      if (isAI)
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.note_add, size: 18, color: isDarkMode ? Colors.white : Colors.black54),
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
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      _textFieldUI(), // Text field remains at the bottom
    ],
  );
}
  Widget _textFieldUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: _isFocused
                        ? [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.6),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo, color: isDarkMode ? Colors.white : Colors.black54),
                        onPressed: _showUploadOptions, // Show upload options
                        tooltip: 'Send Photo or Document',
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: controller,
                          cursorColor: isDarkMode ? Colors.white : Colors.black,
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (text) {
                            if (text.isNotEmpty) {
                              _sendMessage(ChatMessage(
                                user: currentUser,
                                createdAt: DateTime.now(),
                                text: text,
                              ));
                              controller.clear();
                              FocusScope.of(context).requestFocus(_focusNode); // Refocus the text field
                              setState(() {});
                            } else {
                              _listen();
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.black54),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isListening
                              ? Icons.stop_circle
                              : (controller.text.isEmpty ? Icons.mic : Icons.send),
                          color: isDarkMode ? Colors.white : Colors.blueAccent,
                          size: 28,
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            _sendMessage(ChatMessage(
                              user: currentUser,
                              createdAt: DateTime.now(),
                              text: controller.text,
                            ));
                            controller.clear();
                            setState(() {});
                          } else {
                            _listen();
                          }
                        },
                        tooltip: controller.text.isEmpty ? 'Start Listening' : 'Send Message',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.headset, color: isDarkMode ? Colors.white : Colors.black54),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VoiceChat()),
                  );
                },
                tooltip: 'Voice Chat',
              ),
            ],
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
