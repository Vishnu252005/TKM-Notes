import 'package:flutter/material.dart';

class SGPAConverterPage extends StatefulWidget {
  @override
  _SGPAConverterPageState createState() => _SGPAConverterPageState();
}

class _SGPAConverterPageState extends State<SGPAConverterPage> {
  double sgpa = 0.0;
  double percentage = 0.0;
  double cgpa = 0.0;

  void calculateValues(double inputSGPA) {
    setState(() {
      sgpa = inputSGPA;
      percentage = (sgpa - 0.75) * 10; // Assuming a formula to convert SGPA to percentage
      cgpa = (sgpa * 8) / 10; // Assuming a formula to convert SGPA to CGPA
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 13, 148),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 13, 148),
        title: Text('SGPA Converter', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter SGPA',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Enter SGPA',
                hintStyle: TextStyle(color: Colors.white70),
                fillColor: Colors.grey[900],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    sgpa = 0.0;
                    percentage = 0.0;
                    cgpa = 0.0;
                  });
                } else {
                  double inputSGPA = double.parse(value);
                  calculateValues(inputSGPA);
                }
              },
            ),
            SizedBox(height: 24),
            Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            _buildResultCard('Percentage', '${percentage.toStringAsFixed(2)}%'),
            SizedBox(height: 8),
            _buildResultCard('CGPA', cgpa.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SGPAConverterPage(),
  ));
}
