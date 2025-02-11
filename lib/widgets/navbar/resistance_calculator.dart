import 'package:flutter/material.dart';
import 'dart:math';

class ResistanceCalculator extends StatefulWidget {
  @override
  _ResistanceCalculatorState createState() => _ResistanceCalculatorState();
}

class _ResistanceCalculatorState extends State<ResistanceCalculator> {
  String _color1 = 'Brown';
  String _color2 = 'Black';
  String _color3 = 'Red';
  String _tolerance = 'Gold';
  String _result = '';
  bool _isDarkMode = false;

  final Map<String, Color> colorMap = {
    'Black': Colors.black,
    'Brown': Colors.brown,
    'Red': Colors.red,
    'Orange': Colors.orange,
    'Yellow': Colors.yellow,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Violet': Colors.purple,
    'Gray': Colors.grey,
    'White': Colors.white,
    'Gold': Colors.amber,
    'Silver': Colors.grey.shade400,
  };

  final List<String> colors = [
    'Black', 'Brown', 'Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Violet', 'Gray', 'White'
  ];

  final List<String> tolerances = [
    'Brown', 'Red', 'Green', 'Blue', 'Violet', 'Gray', 'Gold', 'Silver'
  ];

  void _calculateResistance() {
    int band1 = colors.indexOf(_color1);
    int band2 = colors.indexOf(_color2);
    int band3 = colors.indexOf(_color3);
    int multiplier = pow(10, band3).toInt();

    int resistance = ((band1 * 10) + band2) * multiplier;
    String formattedResistance = _formatResistance(resistance);

    String toleranceValue;
    switch (_tolerance) {
      case 'Brown': toleranceValue = '1%'; break;
      case 'Red': toleranceValue = '2%'; break;
      case 'Green': toleranceValue = '0.5%'; break;
      case 'Blue': toleranceValue = '0.25%'; break;
      case 'Violet': toleranceValue = '0.1%'; break;
      case 'Gray': toleranceValue = '0.05%'; break;
      case 'Gold': toleranceValue = '5%'; break;
      case 'Silver': toleranceValue = '10%'; break;
      default: toleranceValue = 'Unknown';
    }

    setState(() {
      _result = '$formattedResistance Ω ± $toleranceValue';
    });
  }

  String _formatResistance(int resistance) {
    if (resistance >= 1000000) {
      return '${(resistance / 1000000).toStringAsFixed(2)}M';
    } else if (resistance >= 1000) {
      return '${(resistance / 1000).toStringAsFixed(2)}k';
    }
    return resistance.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Resistance Calculator'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isDarkMode 
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.blue[50]!, Colors.white],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildResistorVisualization(),
                  SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Color Band Selection',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildColorDropdown('First Band', _color1, (newValue) {
                            setState(() => _color1 = newValue!);
                          }),
                          _buildColorDropdown('Second Band', _color2, (newValue) {
                            setState(() => _color2 = newValue!);
                          }),
                          _buildColorDropdown('Multiplier', _color3, (newValue) {
                            setState(() => _color3 = newValue!);
                          }),
                          _buildColorDropdown('Tolerance', _tolerance, (newValue) {
                            setState(() => _tolerance = newValue!);
                          }, isTolerance: true),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateResistance,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Calculate',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  if (_result.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Result',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _result,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.blue[300] : Colors.blue[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResistorVisualization() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.brown[300],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 40, color: Colors.grey[400]),
          Container(width: 15, color: colorMap[_color1]),
          Container(width: 15, color: colorMap[_color2]),
          Container(width: 15, color: colorMap[_color3]),
          Container(width: 15, color: colorMap[_tolerance]),
          Container(width: 40, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildColorDropdown(String label, String currentValue, ValueChanged<String?> onChanged, {bool isTolerance = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isDarkMode ? Colors.white24 : Colors.black12,
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorMap[currentValue],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isDarkMode ? Colors.white30 : Colors.black26,
                  ),
                ),
              ),
              title: DropdownButton<String>(
                value: currentValue,
                onChanged: onChanged,
                items: (isTolerance ? tolerances : colors).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true,
                underline: SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
