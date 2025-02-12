import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

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
  bool isDarkMode = false;  // Add this for theme toggle
  
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
  String _degree = 'B.Tech'; // Default value

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

  Widget _buildEducationSection() {
    return Column(
      children: [
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
        DropdownButtonFormField<String>(
          value: _degree,
          decoration: InputDecoration(labelText: 'Degree'),
          items: [
            'B.Tech',
            'M.Tech',
            'B.Arch',
            'M.Arch',
            'B.Com',
            'M.Com',
            'B.A',
            'M.A',
            'B.B.A',
            'MBA',
            'B.Sc',
            'M.Sc',
            'B.Ed',
            'M.Ed',
            'PhD',
            'Diploma',
            'Other'
          ].map((String degree) {
            return DropdownMenuItem<String>(
              value: degree,
              child: Text(degree),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _degree = value!;
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
      ],
    );
  }

  void _generateResume() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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
            degree: _degree,
            skills: _skills.join(', '),
            experiences: _experiences.map((e) => e.description).join('\n'),
            projects: _projects.map((p) => p.description).join('\n'),
          ),
        ),
      );
    }
  }

  ThemeData _getTheme() {
    return isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[900],
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[850],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _getTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Resume Generator'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Container(
          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      title: 'Personal Details',
                      children: [
                        _buildTextField(
                          label: 'Full Name',
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                          onSaved: (value) => _name = value!,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          label: 'Email',
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
                          onSaved: (value) => _email = value!,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          label: 'Phone',
                          onSaved: (value) => _phone = value!,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          label: 'About Me',
                          maxLines: 3,
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter something about yourself' : null,
                          onSaved: (value) => _aboutMe = value!,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    _buildSectionCard(
                      title: 'Education',
                      children: [
                        _buildEducationSection(),
                      ],
                    ),
                    SizedBox(height: 24),

                    _buildSectionCard(
                      title: 'Skills',
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                  controller: _skillController,
                                decoration: InputDecoration(
                                  labelText: 'Add a skill',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: _addSkill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _skills.map((skill) => Chip(
                            label: Text(skill),
                            deleteIcon: Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                _skills.remove(skill);
                              });
                            },
                          )).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    _buildSectionCard(
                      title: 'Experience',
                      children: [
                _buildExperienceForm(),
                      ],
                    ),
                    SizedBox(height: 24),

                    _buildSectionCard(
                      title: 'Projects',
                      children: [
                _buildProjectForm(),
                      ],
                    ),
                    SizedBox(height: 24),

                    Center(
                      child: ElevatedButton.icon(
                  onPressed: _generateResume,
                        icon: Icon(Icons.description),
                        label: Text('Generate Resume'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.blue[300] : Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
      ),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }
}

class ResumeDisplay extends StatefulWidget {
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
  final String degree;
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
    required this.degree,
    required this.skills,
    required this.experiences,
    required this.projects,
  });

  @override
  _ResumeDisplayState createState() => _ResumeDisplayState();
}

class _ResumeDisplayState extends State<ResumeDisplay> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController aboutMeController;
  late TextEditingController skillsController;
  late TextEditingController experiencesController;
  late TextEditingController projectsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    aboutMeController = TextEditingController(text: widget.aboutMe);
    skillsController = TextEditingController(text: widget.skills);
    experiencesController = TextEditingController(text: widget.experiences);
    projectsController = TextEditingController(text: widget.projects);
  }

  void _showEditDialog(String title, TextEditingController controller, {int maxLines = 1}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter $title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndDownloadPDF() async {
    final pdf = pw.Document();

    // Create PDF content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        nameController.text.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(emailController.text),
                          pw.Text(' | '),
                          pw.Text(phoneController.text),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // About Me
                pw.Text(
                  'ABOUT ME',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(aboutMeController.text),
                pw.SizedBox(height: 16),

                // Education
                pw.Text(
                  'EDUCATION',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text('${widget.collegeName} - ${widget.degree}'),
                pw.Text('${widget.collegeType} | Graduating Year: ${widget.collegeGraduatingYear}'),
                pw.Text('${widget.schoolName} - ${widget.schoolClass}'),
                pw.Text('Passout Year: ${widget.schoolPassoutYear}'),
                pw.SizedBox(height: 16),

                // Skills
                pw.Text(
                  'SKILLS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(skillsController.text),
                pw.SizedBox(height: 16),

                // Experience
                pw.Text(
                  'EXPERIENCE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(experiencesController.text),
                pw.SizedBox(height: 16),

                // Projects
                pw.Text(
                  'PROJECTS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(projectsController.text),
              ],
            ),
          );
        },
      ),
    );

    try {
      if (kIsWeb) {
        // For web platform
        final bytes = await pdf.save();
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download = 'resume.pdf';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile/desktop platforms
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/resume.pdf');
        await file.writeAsBytes(await pdf.save());

        // Show options dialog
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Resume Generated'),
              content: Text('What would you like to do with your resume?'),
              actions: [
                TextButton(
                  onPressed: () {
                    OpenFile.open(file.path);
                    Navigator.pop(context);
                  },
                  child: Text('Open'),
                ),
                TextButton(
                  onPressed: () {
                    Share.shareXFiles([XFile(file.path)], text: 'My Resume');
                    Navigator.pop(context);
                  },
                  child: Text('Share'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show error dialog
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to generate PDF: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Resume'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _generateAndDownloadPDF,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                    // Header Section with Edit
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                nameController.text.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, size: 20),
                                onPressed: () => _showEditDialog('Name', nameController),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(emailController.text),
                              IconButton(
                                icon: Icon(Icons.edit, size: 16),
                                onPressed: () => _showEditDialog('Email', emailController),
                              ),
                              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(phoneController.text),
                              IconButton(
                                icon: Icon(Icons.edit, size: 16),
                                onPressed: () => _showEditDialog('Phone', phoneController),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),

                    // About Me Section with Edit
                    _buildSectionWithEdit(
                      title: 'ABOUT ME',
                      content: aboutMeController.text,
                      onEdit: () => _showEditDialog('About Me', aboutMeController, maxLines: 5),
                    ),

                    // Skills Section with Edit
                    _buildSectionWithEdit(
                      title: 'SKILLS',
                      content: skillsController.text,
                      onEdit: () => _showEditDialog('Skills', skillsController),
                      contentWidget: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skillsController.text.split(', ').map((skill) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(skill.trim()),
                        )).toList(),
                      ),
                    ),

                    // Experience Section with Edit
                    _buildSectionWithEdit(
                      title: 'EXPERIENCE',
                      content: experiencesController.text,
                      onEdit: () => _showEditDialog('Experience', experiencesController, maxLines: 5),
                    ),

                    // Projects Section with Edit
                    _buildSectionWithEdit(
                      title: 'PROJECTS',
                      content: projectsController.text,
                      onEdit: () => _showEditDialog('Projects', projectsController, maxLines: 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithEdit({
    required String title,
    required String content,
    required VoidCallback onEdit,
    Widget? contentWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                letterSpacing: 1.2,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: contentWidget ?? Text(
            content,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    aboutMeController.dispose();
    skillsController.dispose();
    experiencesController.dispose();
    projectsController.dispose();
    super.dispose();
  }
} 