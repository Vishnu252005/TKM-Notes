import 'package:flutter/material.dart';

class ResumeGenerator extends StatefulWidget {
  @override
  _ResumeGeneratorState createState() => _ResumeGeneratorState();
}

class Experience {
  String companyName;
  DateTime startDate;
  DateTime? endDate;
  bool isPresent;
  String position;
  List<String> skills;
  String description;

  Experience({
    required this.companyName,
    required this.startDate,
    this.endDate,
    this.isPresent = false,
    required this.position,
    required this.skills,
    required this.description,
  });
}

class Project {
  String projectName;
  DateTime startDate;
  DateTime? endDate;
  bool isPresent;
  String description;
  List<String> technologies;
  String githubLink;

  Project({
    required this.projectName,
    required this.startDate,
    this.endDate,
    this.isPresent = false,
    required this.description,
    required this.technologies,
    required this.githubLink,
  });
}

class _ResumeGeneratorState extends State<ResumeGenerator> {
  final _formKey = GlobalKey<FormState>();
  
  // Personal Details
  String _name = '';
  String _email = '';
  String _phone = '';
  String _aboutMe = '';

  // Education
  String _schoolName = '';
  String _schoolPassoutYear = '';
  String _schoolClass = '12th'; // Default value
  String _collegeName = '';
  String _collegeType = 'Undergraduate'; // Default value
  String _collegeGraduatingYear = '';

  // Skills
  List<String> _skills = [];
  final TextEditingController _skillController = TextEditingController();

  // Experience
  List<Experience> _experiences = [];

  // Projects
  List<Project> _projects = [];

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate, {Experience? experience, Project? project}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (experience != null) {
          if (isStartDate) {
            experience.startDate = picked;
          } else if (!experience.isPresent) {
            experience.endDate = picked;
          }
        } else if (project != null) {
          if (isStartDate) {
            project.startDate = picked;
          } else if (!project.isPresent) {
            project.endDate = picked;
          }
        }
      });
    }
  }

  Widget _buildExperienceForm() {
    return Column(
      children: [
        ..._experiences.map((exp) => _buildExperienceCard(exp)).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _experiences.add(Experience(
                companyName: '',
                startDate: DateTime.now(),
                position: '',
                skills: [],
                description: '',
              ));
            });
          },
          child: Text('Add Experience'),
        ),
      ],
    );
  }

  Widget _buildExperienceCard(Experience experience) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Company Name'),
              onChanged: (value) => experience.companyName = value,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Start Date'),
                    subtitle: Text(experience.startDate.toString().split(' ')[0]),
                    onTap: () => _selectDate(context, true, experience: experience),
                  ),
                ),
                Expanded(
                  child: experience.isPresent
                      ? CheckboxListTile(
                          title: Text('Present'),
                          value: experience.isPresent,
                          onChanged: (bool? value) {
                            setState(() {
                              experience.isPresent = value ?? false;
                              if (!experience.isPresent) {
                                experience.endDate = DateTime.now();
                              }
                            });
                          },
                        )
                      : ListTile(
                          title: Text('End Date'),
                          subtitle: Text(experience.endDate?.toString().split(' ')[0] ?? 'Select'),
                          onTap: () => _selectDate(context, false, experience: experience),
                        ),
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Position'),
              onChanged: (value) => experience.position = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Skills (comma separated)',
                hintText: 'e.g., Flutter, Dart, Firebase',
              ),
              onChanged: (value) {
                experience.skills = value.split(',').map((e) => e.trim()).toList();
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) => experience.description = value,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _experiences.remove(experience);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectForm() {
    return Column(
      children: [
        ..._projects.map((proj) => _buildProjectCard(proj)).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _projects.add(Project(
                projectName: '',
                startDate: DateTime.now(),
                description: '',
                technologies: [],
                githubLink: '',
              ));
            });
          },
          child: Text('Add Project'),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Project Name'),
              onChanged: (value) => project.projectName = value,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Start Date'),
                    subtitle: Text(project.startDate.toString().split(' ')[0]),
                    onTap: () => _selectDate(context, true, project: project),
                  ),
                ),
                Expanded(
                  child: project.isPresent
                      ? CheckboxListTile(
                          title: Text('Present'),
                          value: project.isPresent,
                          onChanged: (bool? value) {
                            setState(() {
                              project.isPresent = value ?? false;
                              if (!project.isPresent) {
                                project.endDate = DateTime.now();
                              }
                            });
                          },
                        )
                      : ListTile(
                          title: Text('End Date'),
                          subtitle: Text(project.endDate?.toString().split(' ')[0] ?? 'Select'),
                          onTap: () => _selectDate(context, false, project: project),
                        ),
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) => project.description = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Technologies (comma separated)',
                hintText: 'e.g., Flutter, Dart, Firebase',
              ),
              onChanged: (value) {
                project.technologies = value.split(',').map((e) => e.trim()).toList();
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'GitHub Link'),
              onChanged: (value) => project.githubLink = value,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _projects.remove(project);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

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
            aboutMe: _aboutMe,
            schoolName: _schoolName,
            schoolPassoutYear: _schoolPassoutYear,
            schoolClass: _schoolClass,
            collegeName: _collegeName,
            collegeType: _collegeType,
            collegeGraduatingYear: _collegeGraduatingYear,
            skills: _skills.join(', '),
            experiences: _experiences.map((e) => e.description).join('\n'),
            projects: _projects.map((p) => p.description).join('\n'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Details Section
                Text('Personal Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  decoration: InputDecoration(labelText: 'Phone (optional)'),
                  onSaved: (value) {
                    _phone = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'About Me'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter something about yourself';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _aboutMe = value!;
                  },
                ),
                SizedBox(height: 20),

                // Education Section
                Text('Education', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                TextFormField(
                  decoration: InputDecoration(labelText: 'School Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your school name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _schoolName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Passout Year'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your passout year';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _schoolPassoutYear = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _schoolClass,
                  decoration: InputDecoration(labelText: 'Class'),
                  items: ['12th', 'Diploma'].map((String className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _schoolClass = value!;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'College Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your college name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _collegeName = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _collegeType,
                  decoration: InputDecoration(labelText: 'College Type'),
                  items: ['Undergraduate', 'Graduate'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _collegeType = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Graduating Year'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your graduating year';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _collegeGraduatingYear = value!;
                  },
                ),
                SizedBox(height: 20),

                // Skills Section
                Text('Skills', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _skillController,
                  decoration: InputDecoration(labelText: 'Add a skill'),
                ),
                ElevatedButton(
                  onPressed: _addSkill,
                  child: Text('Add Skill'),
                ),
                SizedBox(height: 10),
                Text('Skills: ${_skills.join(', ')}', style: TextStyle(fontSize: 16)),

                // Experience Section
                Text('Experience', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                _buildExperienceForm(),
                SizedBox(height: 20),

                // Projects Section
                Text('Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                _buildProjectForm(),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _generateResume,
                  child: Text('Generate Resume'),
                ),
              ],
            ),
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
  final String aboutMe;
  final String schoolName;
  final String schoolPassoutYear;
  final String schoolClass;
  final String collegeName;
  final String collegeType;
  final String collegeGraduatingYear;
  final String skills;
  final String experiences;
  final String projects;

  ResumeDisplay({
    required this.name,
    required this.email,
    required this.phone,
    required this.aboutMe,
    required this.schoolName,
    required this.schoolPassoutYear,
    required this.schoolClass,
    required this.collegeName,
    required this.collegeType,
    required this.collegeGraduatingYear,
    required this.skills,
    required this.experiences,
    required this.projects,
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
            Text('About Me: $aboutMe', style: TextStyle(fontSize: 20)),
            Text('School: $schoolName', style: TextStyle(fontSize: 20)),
            Text('Passout Year: $schoolPassoutYear', style: TextStyle(fontSize: 20)),
            Text('Class: $schoolClass', style: TextStyle(fontSize: 20)),
            Text('College: $collegeName', style: TextStyle(fontSize: 20)),
            Text('College Type: $collegeType', style: TextStyle(fontSize: 20)),
            Text('Graduating Year: $collegeGraduatingYear', style: TextStyle(fontSize: 20)),
            Text('Skills: $skills', style: TextStyle(fontSize: 20)),
            Text('Work Experience: $experiences', style: TextStyle(fontSize: 20)),
            Text('Projects: $projects', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
} 