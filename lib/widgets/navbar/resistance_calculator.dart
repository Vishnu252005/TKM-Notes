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
  String _color4 = 'Green';
  String _color5 = 'Blue';
  String _tolerance = 'Gold';
  String _result = '';
  bool _isDarkMode = false;
  String _numberOfBands = '4'; // Default to 4 bands

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

  final List<String> numberOfBandsOptions = ['2', '4', '5', '6'];

  @override
  void initState() {
    super.initState();
    _setDefaultColors(); // Set default colors based on the initial number of bands
  }

  void _setDefaultColors() {
    if (_numberOfBands == '2') {
      _color1 = 'Brown';
      _color2 = 'Black';
      _color3 = 'Red'; // Default multiplier
      _color4 = 'Green'; // Not used for 2 bands
      _color5 = 'Blue'; // Not used for 2 bands
    } else if (_numberOfBands == '4') {
      _color1 = 'Brown';
      _color2 = 'Black';
      _color3 = 'Red';
      _color4 = 'Green'; // Default third band
      _color5 = 'Blue'; // Not used for 4 bands
    } else if (_numberOfBands == '5') {
      _color1 = 'Brown';
      _color2 = 'Black';
      _color3 = 'Red';
      _color4 = 'Green';
      _color5 = 'Blue'; // Default fifth band
    } else if (_numberOfBands == '6') {
      _color1 = 'Brown';
      _color2 = 'Black';
      _color3 = 'Red';
      _color4 = 'Green';
      _color5 = 'Blue'; // Default sixth band
    }
  }

  void _calculateResistance() {
    int band1 = colors.indexOf(_color1);
    int band2 = colors.indexOf(_color2);
    int multiplier = pow(10, colors.indexOf(_color3)).toInt();
    int resistance = 0; // Initialize resistance to 0

    if (_numberOfBands == '2') {
      resistance = (band1 * 10 + band2) * multiplier;
    } else if (_numberOfBands == '4' || _numberOfBands == '5' || _numberOfBands == '6') {
      int band3 = colors.indexOf(_color4);
      resistance = ((band1 * 100) + (band2 * 10) + band3) * multiplier;
    }

    String formattedResistance = _formatResistance(resistance);
    String toleranceValue = _getToleranceValue();

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

  String _getToleranceValue() {
    switch (_tolerance) {
      case 'Brown': return '1%';
      case 'Red': return '2%';
      case 'Green': return '0.5%';
      case 'Blue': return '0.25%';
      case 'Violet': return '0.1%';
      case 'Gray': return '0.05%';
      case 'Gold': return '5%';
      case 'Silver': return '10%';
      default: return 'Unknown';
    }
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
                  if (_result.isNotEmpty) ...[
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
                    SizedBox(height: 24),
                  ],
                  _buildColorDropdown('Number of Bands', _numberOfBands, (newValue) {
                    setState(() {
                      _numberOfBands = newValue!;
                      _setDefaultColors(); // Reset colors based on new number of bands
                      _calculateResistance(); // Recalculate on change
                    });
                  }, isTolerance: false, options: numberOfBandsOptions),
                  if (_numberOfBands == '2') ...[
                    _buildColorDropdown('First Band', _color1, (newValue) {
                      setState(() {
                        _color1 = newValue!;
                        _calculateResistance();
                      });
                    }),
                    _buildColorDropdown('Second Band', _color2, (newValue) {
                      setState(() {
                        _color2 = newValue!;
                        _calculateResistance();
                      });
                    }),
                  ] else if (_numberOfBands == '4' || _numberOfBands == '5' || _numberOfBands == '6') ...[
                    _buildColorDropdown('First Band', _color1, (newValue) {
                      setState(() {
                        _color1 = newValue!;
                        _calculateResistance();
                      });
                    }),
                    _buildColorDropdown('Second Band', _color2, (newValue) {
                      setState(() {
                        _color2 = newValue!;
                        _calculateResistance();
                      });
                    }),
                    _buildColorDropdown('Multiplier', _color3, (newValue) {
                      setState(() {
                        _color3 = newValue!;
                        _calculateResistance();
                      });
                    }),
                    if (_numberOfBands == '5' || _numberOfBands == '6') ...[
                      _buildColorDropdown('Third Band', _color4, (newValue) {
                        setState(() {
                          _color4 = newValue!;
                          _calculateResistance();
                        });
                      }),
                    ],
                    if (_numberOfBands == '6') ...[
                      _buildColorDropdown('Fourth Band', _color5, (newValue) {
                        setState(() {
                          _color5 = newValue!;
                          _calculateResistance();
                        });
                      }),
                    ],
                  ],
                  _buildColorDropdown('Tolerance', _tolerance, (newValue) {
                    setState(() {
                      _tolerance = newValue!;
                      _calculateResistance();
                    });
                  }, isTolerance: true),
                  SizedBox(height: 20),
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
          if (_numberOfBands == '4' || _numberOfBands == '5' || _numberOfBands == '6') 
            Container(width: 15, color: colorMap[_color3]),
          if (_numberOfBands == '5' || _numberOfBands == '6') 
            Container(width: 15, color: colorMap[_color4]),
          if (_numberOfBands == '6') 
            Container(width: 15, color: colorMap[_color5]),
          Container(width: 15, color: colorMap[_tolerance]),
          Container(width: 40, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildColorDropdown(String label, String currentValue, ValueChanged<String?> onChanged, {bool isTolerance = false, List<String>? options}) {
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
                items: (options ?? (isTolerance ? tolerances : colors)).map((String value) {
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
