import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

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
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF1A1A2E) : Colors.blue[50],
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(
                color: _isDarkMode 
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
                            colors: _isDarkMode 
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
                                            Icons.calculate_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'CALCULATOR',
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
                                        _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Resistance\nCalculator',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildResistorVisualization(),
                      SizedBox(height: 24),
                      if (_result.isNotEmpty) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isDarkMode 
                                  ? Color(0xFF4C4DDC).withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _isDarkMode 
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.blue.withOpacity(0.1),
                                offset: Offset(4, 4),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
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
                                  color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                      _buildColorDropdown('Number of Bands', _numberOfBands, (newValue) {
                        setState(() {
                          _numberOfBands = newValue!;
                          _setDefaultColors();
                          _calculateResistance();
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _isDarkMode ? Color(0xFF252542) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isDarkMode 
                    ? Color(0xFF4C4DDC).withOpacity(0.2)
                    : Colors.blue.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: _isDarkMode 
                      ? Colors.black.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.1),
                  offset: Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
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
              title: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                ),
                child: DropdownButton<String>(
                  value: currentValue,
                  onChanged: onChanged,
                  items: (options ?? (isTolerance ? tolerances : colors)).map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  isExpanded: true,
                  underline: SizedBox(),
                  dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
