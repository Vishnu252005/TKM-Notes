import 'package:flutter/material.dart';
import '../calcu.dart'; // Adjust the path as necessary
import '../conv.dart'; // Adjust the path as necessary
import '../graph.dart'; // Adjust the path as necessary
import 'resistance_calculator.dart'; // Import the new resistance calculator
import 'unit_converter.dart'; // Import the unit converter
import 'project_idea.dart'; // Import the ProjectIdeaScreen
import 'resume_generator.dart'; // Import the ResumeGenerator
import 'resume/screen/on_boarding/on_boarding_page.dart';

class ToolsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tools'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tools Screen'),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResistanceCalculator()), // Navigate to Resistance Calculator
                );
              },
              child: Text('Resistance Calculator'),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScientificCalculator()),
                );
              },
              child: Text('Calculator'),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnitConverter()), // Navigate to Unit Converter
                );
              },
              child: Text('Unit Converter'),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NumberConverter()),
                );
              },
              child: Text('Number System Converter'),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraphPlotter()),
                );
              },
              child: Text('Graph Plotter'),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectIdeaScreen()), // Navigate to ProjectIdeaScreen
                );
              },
              child: Text('Project Ideas'),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResumeGenerator()), // Navigate to ResumeGenerator
                );
              },
              child: Text('Resume Generator'),
            ),
          ],
        ),
      ),
    );
  }
} 