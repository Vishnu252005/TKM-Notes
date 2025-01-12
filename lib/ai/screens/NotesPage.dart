import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  final List<String> notes;

  NotesPage({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]),
          );
        },
      ),
    );
  }
}
