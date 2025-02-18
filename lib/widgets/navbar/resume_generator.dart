import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

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
  String _schoolPassoutYear = DateTime.now().year.toString();
  String _schoolClass = '12th'; // Default value
  String _collegeName = '';
  String _collegeType = 'Undergraduate'; // Default value
  String _collegeGraduatingYear = DateTime.now().year.toString();
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
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.blue.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with company name and delete button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? Color(0xFF4C4DDC).withOpacity(0.1)
                  : Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                    ),
                    SizedBox(width: 12),
                    Text(
                      experience.companyName.isEmpty ? 'New Experience' : experience.companyName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[300],
                  ),
                  onPressed: () {
                    setState(() {
                      _experiences.remove(experience);
                    });
                  },
                ),
              ],
            ),
          ),

          Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                _buildTextField(
                  label: 'Company Name',
                  onSaved: (value) => experience.companyName = value ?? '',
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Position',
                  onSaved: (value) => experience.position = value ?? '',
                ),
                SizedBox(height: 16),

                // Date Range Row
            Row(
              children: [
                Expanded(
                      child: InkWell(
                    onTap: () => _selectDate(context, true, experience: experience),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Color(0xFF4C4DDC).withOpacity(0.1)
                                : Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white60 : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                experience.startDate.toString().split(' ')[0],
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                Expanded(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(
                              'Present',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          value: experience.isPresent,
                            activeColor: Color(0xFF4C4DDC),
                            onChanged: (bool value) {
                            setState(() {
                                experience.isPresent = value;
                                if (value) {
                                  experience.endDate = null;
                              }
                            });
                          },
                          ),
                          if (!experience.isPresent)
                            InkWell(
                          onTap: () => _selectDate(context, false, experience: experience),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDarkMode 
                                      ? Color(0xFF4C4DDC).withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Date',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white60 : Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      experience.endDate?.toString().split(' ')[0] ?? 'Select',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.w500,
                        ),
                ),
              ],
            ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Skills
                _buildTextField(
                  label: 'Skills (comma separated)',
                  onSaved: (value) {
                    experience.skills = value?.split(',').map((e) => e.trim()).toList() ?? [];
                  },
                ),
                SizedBox(height: 16),

                // Description
                _buildTextField(
                  label: 'Description',
                  maxLines: 3,
                  onSaved: (value) => experience.description = value ?? '',
                ),
          ],
        ),
      ),
        ],
      ),
    ).animate().fadeIn().slideX();
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
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.blue.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with project name and delete button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? Color(0xFF4C4DDC).withOpacity(0.1)
                  : Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                    ),
                    SizedBox(width: 12),
                    Text(
                      project.projectName.isEmpty ? 'New Project' : project.projectName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[300],
                  ),
                  onPressed: () {
                    setState(() {
                      _projects.remove(project);
                    });
                  },
                ),
              ],
            ),
          ),

          Padding(
        padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                _buildTextField(
                  label: 'Project Name',
                  onSaved: (value) => project.projectName = value ?? '',
                ),
                SizedBox(height: 16),

                // Date Range Row
            Row(
              children: [
                Expanded(
                      child: InkWell(
                    onTap: () => _selectDate(context, true, project: project),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Color(0xFF4C4DDC).withOpacity(0.1)
                                : Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white60 : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                project.startDate.toString().split(' ')[0],
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                Expanded(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(
                              'Ongoing',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          value: project.isPresent,
                            activeColor: Color(0xFF4C4DDC),
                            onChanged: (bool value) {
                            setState(() {
                                project.isPresent = value;
                                if (value) {
                                  project.endDate = null;
                              }
                            });
                          },
                          ),
                          if (!project.isPresent)
                            InkWell(
                          onTap: () => _selectDate(context, false, project: project),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDarkMode 
                                      ? Color(0xFF4C4DDC).withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Date',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white60 : Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      project.endDate?.toString().split(' ')[0] ?? 'Select',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.w500,
                        ),
                ),
              ],
            ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Technologies
                _buildTextField(
                  label: 'Technologies (comma separated)',
                  onSaved: (value) {
                    project.technologies = value?.split(',').map((e) => e.trim()).toList() ?? [];
                  },
                ),
                SizedBox(height: 16),

                // Description
                _buildTextField(
                  label: 'Description',
                  maxLines: 3,
                  onSaved: (value) => project.description = value ?? '',
                ),
                SizedBox(height: 16),

                // GitHub Link
                _buildTextField(
                  label: 'GitHub Link',
                  onSaved: (value) => project.githubLink = value ?? '',
                ),
          ],
        ),
      ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildEducationSection() {
    // Generate a list of years from 1990 to current year + 10
    final List<String> years = List.generate(
      DateTime.now().year + 10 - 1990 + 1,
      (index) => (1990 + index).toString(),
    ).reversed.toList();  // Reverse to show recent years first

    return _buildSectionCard(
      title: 'Education',
      children: [
        // School Education
        Text(
          'School Education',
          style: TextStyle(
            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideX(),
        SizedBox(height: 16),
        
        _buildTextField(
          label: 'School Name',
          validator: (value) => value?.isEmpty ?? true ? 'Please enter school name' : null,
          onSaved: (value) => _schoolName = value!,
        ).animate().fadeIn().slideX(delay: 100.ms),
        
        SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isDarkMode 
                        ? Color(0xFF4C4DDC).withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                          ? Colors.black.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.05),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _schoolClass,
                  decoration: InputDecoration(
                    labelText: 'Class',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  dropdownColor: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  items: ['10th', '12th'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _schoolClass = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isDarkMode 
                        ? Color(0xFF4C4DDC).withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                          ? Colors.black.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.05),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _schoolPassoutYear.isEmpty ? years.first : _schoolPassoutYear,
                  decoration: InputDecoration(
                    labelText: 'Passing Year',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  dropdownColor: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  items: years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(
                        year,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _schoolPassoutYear = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ).animate().fadeIn().slideX(delay: 200.ms),

        SizedBox(height: 32),

        // College Education
        Text(
          'College Education',
          style: TextStyle(
            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideX(delay: 300.ms),
        SizedBox(height: 16),

        _buildTextField(
          label: 'College Name',
          validator: (value) => value?.isEmpty ?? true ? 'Please enter college name' : null,
          onSaved: (value) => _collegeName = value!,
        ).animate().fadeIn().slideX(delay: 400.ms),

        SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isDarkMode 
                        ? Color(0xFF4C4DDC).withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                          ? Colors.black.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.05),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
          value: _degree,
                  decoration: InputDecoration(
                    labelText: 'Degree',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  dropdownColor: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  items: ['B.Tech', 'M.Tech', 'BCA', 'MCA', 'B.Sc', 'M.Sc'].map((String value) {
            return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _degree = value!;
            });
          },
        ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isDarkMode 
                        ? Color(0xFF4C4DDC).withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                          ? Colors.black.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.05),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _collegeGraduatingYear.isEmpty ? years.first : _collegeGraduatingYear,
                  decoration: InputDecoration(
                    labelText: 'Graduating Year',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  dropdownColor: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
                  items: years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(
                        year,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                    _collegeGraduatingYear = value!;
                    });
                  },
                ),
              ),
            ),
      ],
        ).animate().fadeIn().slideX(delay: 500.ms),
      ],
    ).animate().fadeIn().scale();
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
            experiences: _experiences.map((e) {
              return '${e.companyName} | ${e.startDate.toString().split(' ')[0]} - ${e.isPresent ? 'Present' : e.endDate?.toString().split(' ')[0] ?? 'N/A'}\n'
                     '● ${e.description}\n'
                     '● Skills: ${e.skills.join(', ')}\n';
            }).join('\n'),
            projects: _projects.map((p) {
              return '${p.projectName} | ${p.startDate.toString().split(' ')[0]} - ${p.isPresent ? 'Present' : p.endDate?.toString().split(' ')[0] ?? 'N/A'}\n'
                     '● ${p.description}\n'
                     '● Technologies: ${p.technologies.join(', ')}\n'
                     '● GitHub Link: ${p.githubLink}\n';
            }).join('\n'),
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

          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: true,
                floating: false,
                pinned: false,
                expandedHeight: 200,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkMode 
                                ? [Color(0xFF4C4DDC), Color(0xFF1A1A2E)]
                                : [Colors.blue[400]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
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
                                            Icons.description_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'RESUME',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
            IconButton(
                                      icon: Icon(
                                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                        color: Colors.white,
                                      ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
                                SizedBox(height: 20),
                                Text(
                                  'Resume\nGenerator',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
            child: Padding(
                  padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildSectionCard(
                      title: 'Personal Details',
                      children: [
                        _buildTextField(
                          label: 'Full Name',
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                          onSaved: (value) => _name = value!,
                            ).animate().fadeIn().slideX(),
                        SizedBox(height: 16),
                        _buildTextField(
                          label: 'Email',
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
                          onSaved: (value) => _email = value!,
                            ).animate().fadeIn().slideX(delay: 100.ms),
                        SizedBox(height: 16),
                        _buildTextField(
                          label: 'Phone',
                          onSaved: (value) => _phone = value!,
                            ).animate().fadeIn().slideX(delay: 200.ms),
                        SizedBox(height: 16),
                        _buildTextField(
                          label: 'About Me',
                          maxLines: 3,
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter something about yourself' : null,
                          onSaved: (value) => _aboutMe = value!,
                            ).animate().fadeIn().slideX(delay: 300.ms),
                      ],
                        ).animate().fadeIn().scale(),

                        SizedBox(height: 16),

                        _buildEducationSection(),

                        SizedBox(height: 16),

                    _buildSectionCard(
                      title: 'Skills',
                      children: [
                            _buildSkillInput(),
                          ],
                        ).animate().fadeIn().slideX(delay: 500.ms),

                        SizedBox(height: 16),

                    _buildSectionCard(
                      title: 'Experience',
                      children: [
                _buildExperienceForm(),
                      ],
                        ).animate().fadeIn().slideX(delay: 600.ms),

                        SizedBox(height: 16),

                    _buildSectionCard(
                      title: 'Projects',
                      children: [
                _buildProjectForm(),
                      ],
                        ).animate().fadeIn().slideX(delay: 700.ms),

                        SizedBox(height: 16),

                    Center(
                      child: ElevatedButton.icon(
                  onPressed: _generateResume,
                              icon: Icon(Icons.description, color: Colors.white),
                              label: Text(
                                'Generate Resume',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                        ),
                                elevation: 8,
                                shadowColor: isDarkMode 
                                    ? Color(0xFF4C4DDC).withOpacity(0.5)
                                    : Colors.blue.withOpacity(0.5),
                      ),
                    ),
                          ),

                        SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
            ],
        ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
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
        ],
      ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Color(0xFF4C4DDC).withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForSection(title),
                  color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
              ),
              ),
            ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
      ),
    );
  }

  IconData _getIconForSection(String section) {
    switch (section) {
      case 'Personal Details':
        return Icons.person_outline;
      case 'Education':
        return Icons.school_outlined;
      case 'Skills':
        return Icons.psychology_outlined;
      case 'Experience':
        return Icons.work_outline;
      case 'Projects':
        return Icons.code_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.blue.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextFormField(
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 16,
          height: 1.5,
        ),
        maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
          labelStyle: TextStyle(
            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white60 : Colors.black45,
          ),
          errorStyle: TextStyle(
            color: Colors.red[300]!,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      validator: validator,
      onSaved: onSaved,
      ),
    );
  }

  Widget _buildSkillInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF2A2A42) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDarkMode 
                  ? Color(0xFF4C4DDC).withOpacity(0.2)
                  : Colors.blue.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                    ? Colors.black.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.05),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: TextField(
            controller: _skillController,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Add a skill',
              labelStyle: TextStyle(
                color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              hintText: 'e.g., Flutter, React, Python',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white38 : Colors.black38,
                fontSize: 14,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add_circle_outlined,
                  color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                  size: 28,
                ),
                onPressed: _addSkill,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            onSubmitted: (_) => _addSkill(),
          ),
        ),
        SizedBox(height: 20),
        if (_skills.isNotEmpty) ...[
          Text(
            'Your Skills',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skills.map((skill) => Container(
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Color(0xFF4C4DDC).withOpacity(0.15)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDarkMode 
                      ? Color(0xFF4C4DDC)
                      : Colors.blue,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode 
                        ? Colors.black.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Chip(
                label: Text(
                  skill,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.transparent,
                deleteIcon: Icon(
                  Icons.cancel_rounded,
                  size: 20,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                onDeleted: () {
                  setState(() {
                    _skills.remove(skill);
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              ),
            )).toList(),
          ),
        ],
      ],
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

    // Load the font
    final font = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(font);

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
                          font: ttf,
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(emailController.text, style: pw.TextStyle(font: ttf)),
                          pw.Text(' | ', style: pw.TextStyle(font: ttf)),
                          pw.Text(phoneController.text, style: pw.TextStyle(font: ttf)),
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
                    font: ttf,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(aboutMeController.text, style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 16),

                // Education
                pw.Text(
                  'EDUCATION',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text('${widget.collegeName} - ${widget.degree}', style: pw.TextStyle(font: ttf)),
                pw.Text('${widget.collegeType} | Graduating Year: ${widget.collegeGraduatingYear}', style: pw.TextStyle(font: ttf)),
                pw.Text('${widget.schoolName} - ${widget.schoolClass}', style: pw.TextStyle(font: ttf)),
                pw.Text('Passout Year: ${widget.schoolPassoutYear}', style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 16),

                // Skills
                pw.Text(
                  'SKILLS',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(skillsController.text, style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 16),

                // Experience
                pw.Text(
                  'EXPERIENCE',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(experiencesController.text, style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 16),

                // Projects
                pw.Text(
                  'PROJECTS',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(projectsController.text, style: pw.TextStyle(font: ttf)),
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

// Add this class at the end of the file
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