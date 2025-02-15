import 'package:flutter/material.dart';

class ProjectIdeaScreen extends StatefulWidget {
  @override
  _ProjectIdeaScreenState createState() => _ProjectIdeaScreenState();
}

class _ProjectIdeaScreenState extends State<ProjectIdeaScreen> {
  final TextEditingController _ideaController = TextEditingController();
  final List<String> _projectIdeas = [];
  String _searchQuery = '';

  void _addProjectIdea() {
    if (_ideaController.text.isNotEmpty) {
      setState(() {
        _projectIdeas.add(_ideaController.text);
        _ideaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Ideas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ideaController,
              decoration: InputDecoration(
                labelText: 'Enter your project idea',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addProjectIdea,
              child: Text('Add Idea'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Ideas',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _projectIdeas.length,
                itemBuilder: (context, index) {
                  final idea = _projectIdeas[index];
                  if (_searchQuery.isEmpty || idea.toLowerCase().contains(_searchQuery)) {
                    return ListTile(
                      title: Text(idea),
                    );
                  }
                  return Container(); // Return an empty container if it doesn't match the search query
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }
}
