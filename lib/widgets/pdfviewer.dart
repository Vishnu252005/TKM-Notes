// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:io';


import '../CHEMICAL/sem1/ chemical_sem1_screen.dart';
import '../CHEMICAL/sem2/chemical_sem2_screen.dart';
import '../CHEMICAL/sem3/chemical_sem3_screen.dart';
import '../CHEMICAL/sem4/chemical_sem4_screen.dart';
import '../CHEMICAL/sem5/chemical_sem5_screen.dart';
import '../CHEMICAL/sem6/chemical_sem6_screen.dart';
import '../CHEMICAL/sem7/chemical_sem7_screen.dart';
import '../CHEMICAL/sem8/chemical_sem8_screen.dart';

import '../CIVIL/sem1/civil_sem1_screen.dart';
import '../CIVIL/sem2/civil_sem2_screen.dart';
import '../CIVIL/sem3/civil_sem3_screen.dart';
import '../CIVIL/sem4/civil_sem4_screen.dart';
import '../CIVIL/sem5/civil_sem5_screen.dart';
import '../CIVIL/sem6/civil_sem6_screen.dart';
import '../CIVIL/sem7/civil_sem7_screen.dart';
import '../CIVIL/sem8/civil_sem8_screen.dart';

import '../CSE/sem1/cse_sem1_screen.dart';
import '../CSE/sem2/cse_sem2_screen.dart';
import '../CSE/sem3/cse_sem3_screen.dart';
import '../CSE/sem4/cse_sem4_screen.dart';
import '../CSE/sem5/cse_sem5_screen.dart';
import '../CSE/sem6/cse_sem6_screen.dart';
import '../CSE/sem7/cse_sem7_screen.dart';
import '../CSE/sem8/cse_sem8_screen.dart';

import '../EC/sem1/ec_sem1_screen.dart';
import '../EC/sem2/ec_sem2_screen.dart';
import '../EC/sem3/ec_sem3_screen.dart';
import '../EC/sem4/ec_sem4_screen.dart';
import '../EC/sem5/ec_sem5_screen.dart';
import '../EC/sem6/ec_sem6_screen.dart';
import '../EC/sem7/ec_sem7_screen.dart';
import '../EC/sem8/ec_sem8_screen.dart';

import '../EEE/sem1/eee_sem1_screen.dart';
import '../EEE/sem2/eee_sem2_screen.dart';
import '../EEE/sem2/PSP/psp.dart';
import '../EEE/sem3/eee_sem3_screen.dart';
import '../EEE/sem4/eee_sem4_screen.dart';
import '../EEE/sem5/eee_sem5_screen.dart';
import '../EEE/sem6/eee_sem6_screen.dart';
import '../EEE/sem7/eee_sem7_screen.dart';
import '../EEE/sem8/eee_sem8_screen.dart';

import '../ER/sem1/er_sem1_screen.dart';
import '../ER/sem2/er_sem2_screen.dart';
import '../ER/sem3/er_sem3_screen.dart';
import '../ER/sem4/er_sem4_screen.dart';
import '../ER/sem5/er_sem5_screen.dart';
import '../ER/sem6/er_sem6_screen.dart';
import '../ER/sem7/er_sem7_screen.dart';
import '../ER/sem8/er_sem8_screen.dart';

import '../MECH/sem1/mech_sem1_screen.dart';
import '../MECH/sem2/mech_sem2_screen.dart';
import '../MECH/sem3/mech_sem3_screen.dart';
import '../MECH/sem4/mech_sem4_screen.dart';
import '../MECH/sem5/mech_sem5_screen.dart';
import '../MECH/sem6/mech_sem6_screen.dart';
import '../MECH/sem7/mech_sem7_screen.dart';
import '../MECH/sem8/mech_sem8_screen.dart';




class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PDFViewerPage({required this.pdfUrl, required this.title});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadFile(widget.pdfUrl);
  }

  Future<void> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/temp.pdf');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          localFilePath = file.path;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      print('Error downloading file: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openChatBot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatBotPage(pdfUrl: widget.pdfUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 3, 13, 148),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : localFilePath == null
                  ? Center(child: Text('Error loading PDF'))
                  : PDFView(
                      filePath: localFilePath!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: false,
                      onError: (error) {
                        print('Error loading PDF: $error');
                      },
                      onPageError: (page, error) {
                        print('Page $page error: $error');
                      },
                    ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () => _openChatBot(context),
              child: Icon(Icons.chat),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBotPage extends StatefulWidget {
  final String pdfUrl;

  const ChatBotPage({required this.pdfUrl});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'bot', 'text': 'How can I assist you?'},
    {'sender': 'bot', 'text': '1. Summarize the PDF'},
    {'sender': 'bot', 'text': '2. Important questions'},
    {'sender': 'bot', 'text': '3. Explain the main topic'},
  ];

  void _sendMessage(String message) {
    setState(() {
      _messages.add({'sender': 'user', 'text': message});
    });
    _controller.clear();
    _fetchResponse(message);
  }

  void _fetchResponse(String message) async {
    // Replace this with your backend call
    final response = await http.post(
      Uri.parse('http://your_backend_url/ask'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'pdfUrl': widget.pdfUrl,
        'question': message,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _messages.add({'sender': 'bot', 'text': responseData['answer']});
      });
    } else {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Failed to get response from AI'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: message['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'user' ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(message['text'] ?? ''),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
