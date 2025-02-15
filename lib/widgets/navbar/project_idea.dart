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
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.engineering_rounded,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 24),
              Text(
                '🚀 Coming Soon!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We\'re building something awesome!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Our Project Ideas feature will help you organize and track your innovative ideas.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Stay tuned for updates!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
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
