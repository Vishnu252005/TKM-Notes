import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:Nexia/ai/constants/constants.dart';
import 'package:Nexia/ai/constants/query.dart';
import 'package:sizer/sizer.dart';

class QueryScreen extends StatelessWidget {
  final List<String> questions;
  final String extractedText;

  const QueryScreen({
    Key? key,
    required this.questions,
    required this.extractedText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Questions', style: GoogleFonts.archivo()),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(questions[index]),
              leading: const Icon(Icons.question_answer),
            ),
          );
        },
      ),
    );
  }
}
