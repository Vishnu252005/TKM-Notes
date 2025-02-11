import 'package:flutter/material.dart';

class ResumeGenerator extends StatefulWidget {
  @override
  _ResumeGeneratorState createState() => _ResumeGeneratorState();
}

class _ResumeGeneratorState extends State<ResumeGenerator> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _education = '';
  String _experience = '';
  String _skills = '';

  void _generateResume() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Navigate to the resume display screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumeDisplay(
            name: _name,
            email: _email,
            phone: _phone,
            education: _education,
            experience: _experience,
            skills: _skills,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Generator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Education'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your education details';
                  }
                  return null;
                },
                onSaved: (value) {
                  _education = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Work Experience'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your work experience';
                  }
                  return null;
                },
                onSaved: (value) {
                  _experience = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Skills'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your skills';
                  }
                  return null;
                },
                onSaved: (value) {
                  _skills = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateResume,
                child: Text('Generate Resume'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResumeDisplay extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String education;
  final String experience;
  final String skills;

  ResumeDisplay({
    required this.name,
    required this.email,
    required this.phone,
    required this.education,
    required this.experience,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Resume'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 20)),
            Text('Email: $email', style: TextStyle(fontSize: 20)),
            Text('Phone: $phone', style: TextStyle(fontSize: 20)),
            Text('Education: $education', style: TextStyle(fontSize: 20)),
            Text('Work Experience: $experience', style: TextStyle(fontSize: 20)),
            Text('Skills: $skills', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
} 