import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class NumberConverter extends StatefulWidget {
  @override
  _NumberConverterState createState() => _NumberConverterState();
}

class _NumberConverterState extends State<NumberConverter> {
  final TextEditingController _inputController = TextEditingController();
  String _decimalValue = '';
  String _binaryValue = '';
  String _octalValue = '';
  String _hexValue = '';
  String _selectedSystem = 'Decimal';
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadConversionState();
    _inputController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    _convertNumber(_inputController.text);
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _loadConversionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _inputController.text = prefs.getString('inputValue') ?? '';
      _selectedSystem = prefs.getString('selectedSystem') ?? 'Decimal';
      _convertNumber(_inputController.text);
    });
  }

  Future<void> _saveConversionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('inputValue', _inputController.text);
    await prefs.setString('selectedSystem', _selectedSystem);
  }

  void _convertNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _decimalValue = _binaryValue = _octalValue = _hexValue = '';
        _saveConversionState();
        return;
      }

      try {
        double number;
        switch (_selectedSystem) {
          case 'Decimal':
            number = double.parse(value);
            break;
          case 'Binary':
            number = _binaryToDecimal(value);
            break;
          case 'Octal':
            number = _octalToDecimal(value);
            break;
          case 'Hexadecimal':
            number = _hexToDecimal(value);
            break;
          default:
            throw FormatException('Invalid number system');
        }

        _decimalValue = _formatDecimal(number);
        _binaryValue = _decimalToBinary(number);
        _octalValue = _decimalToOctal(number);
        _hexValue = _decimalToHex(number);
        _saveConversionState();
      } catch (e) {
        _decimalValue = _binaryValue = _octalValue = _hexValue = 'Invalid Input';
      }
    });
  }

  double _binaryToDecimal(String binary) {
    List<String> parts = binary.split('.');
    int integerPart = int.parse(parts[0], radix: 2);
    double fractionalPart = 0;
    if (parts.length > 1) {
      for (int i = 0; i < parts[1].length; i++) {
        fractionalPart += int.parse(parts[1][i]) * pow(2, -(i + 1));
      }
    }
    return integerPart + fractionalPart;
  }

  double _octalToDecimal(String octal) {
    List<String> parts = octal.split('.');
    int integerPart = int.parse(parts[0], radix: 8);
    double fractionalPart = 0;
    if (parts.length > 1) {
      for (int i = 0; i < parts[1].length; i++) {
        fractionalPart += int.parse(parts[1][i]) * pow(8, -(i + 1));
      }
    }
    return integerPart + fractionalPart;
  }

  double _hexToDecimal(String hex) {
    List<String> parts = hex.split('.');
    int integerPart = int.parse(parts[0], radix: 16);
    double fractionalPart = 0;
    if (parts.length > 1) {
      for (int i = 0; i < parts[1].length; i++) {
        fractionalPart += int.parse(parts[1][i], radix: 16) * pow(16, -(i + 1));
      }
    }
    return integerPart + fractionalPart;
  }

  String _formatDecimal(double number) {
    return number.toString();
  }

  String _decimalToBinary(double decimal) {
    int integerPart = decimal.floor();
    double fractionalPart = decimal - integerPart;

    String binaryInteger = integerPart.toRadixString(2);
    String binaryFraction = '';
    while (fractionalPart > 0 && binaryFraction.length < 10) {
      fractionalPart *= 2;
      int bit = fractionalPart.floor();
      binaryFraction += bit.toString();
      fractionalPart -= bit;
    }
    return binaryFraction.isEmpty ? binaryInteger : '$binaryInteger.$binaryFraction';
  }

  String _decimalToOctal(double decimal) {
    int integerPart = decimal.floor();
    double fractionalPart = decimal - integerPart;

    String octalInteger = integerPart.toRadixString(8);
    String octalFraction = '';
    while (fractionalPart > 0 && octalFraction.length < 10) {
      fractionalPart *= 8;
      int digit = fractionalPart.floor();
      octalFraction += digit.toString();
      fractionalPart -= digit;
    }
    return octalFraction.isEmpty ? octalInteger : '$octalInteger.$octalFraction';
  }

  String _decimalToHex(double decimal) {
    int integerPart = decimal.floor();
    double fractionalPart = decimal - integerPart;

    String hexInteger = integerPart.toRadixString(16).toUpperCase();
    String hexFraction = '';
    while (fractionalPart > 0 && hexFraction.length < 10) {
      fractionalPart *= 16;
      int digit = fractionalPart.floor();
      hexFraction += digit.toRadixString(16).toUpperCase();
      fractionalPart -= digit;
    }
    return hexFraction.isEmpty ? hexInteger : '$hexInteger.$hexFraction';
  }

  List<TextInputFormatter> _getInputFormatters() {
    switch (_selectedSystem) {
      case 'Binary':
        return [FilteringTextInputFormatter.allow(RegExp(r'[01.]'))];
      case 'Octal':
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-7.]'))];
      case 'Hexadecimal':
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f.]'))];
      case 'Decimal':
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
      default:
        return [FilteringTextInputFormatter.allow(RegExp(r'.'))];
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
                                            Icons.numbers,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'CONVERTER',
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
                                      onPressed: () {
                                        setState(() {
                                          _isDarkMode = !_isDarkMode;
                                          _saveThemePreference();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Number\nSystem',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Number System',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                              ),
                              child: DropdownButton<String>(
                                value: _selectedSystem,
                                isExpanded: true,
                                dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                                items: ['Decimal', 'Binary', 'Octal', 'Hexadecimal']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSystem = newValue!;
                                    _inputController.clear();
                                    _convertNumber(_inputController.text);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(),

                      SizedBox(height: 16),

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter Value',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            TextField(
                              controller: _inputController,
                              decoration: InputDecoration(
                                labelText: 'Enter $_selectedSystem Number',
                                labelStyle: TextStyle(
                                  color: _isDarkMode ? Colors.white70 : Colors.blue[600],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: _isDarkMode ? Colors.black12 : Colors.grey[100],
                              ),
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                              inputFormatters: _getInputFormatters(),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(delay: 200.ms),

                      SizedBox(height: 16),

                      if (_decimalValue.isNotEmpty)
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Results',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16),
                              ResultCard(
                                title: 'Decimal',
                                value: _decimalValue,
                                isDarkMode: _isDarkMode,
                              ).animate().fadeIn().slideX(delay: 300.ms),
                              Divider(height: 24, color: _isDarkMode ? Colors.white12 : Colors.black12),
                              ResultCard(
                                title: 'Binary',
                                value: _binaryValue,
                                isDarkMode: _isDarkMode,
                              ).animate().fadeIn().slideX(delay: 400.ms),
                              Divider(height: 24, color: _isDarkMode ? Colors.white12 : Colors.black12),
                              ResultCard(
                                title: 'Octal',
                                value: _octalValue,
                                isDarkMode: _isDarkMode,
                              ).animate().fadeIn().slideX(delay: 500.ms),
                              Divider(height: 24, color: _isDarkMode ? Colors.white12 : Colors.black12),
                              ResultCard(
                                title: 'Hexadecimal',
                                value: _hexValue,
                                isDarkMode: _isDarkMode,
                              ).animate().fadeIn().slideX(delay: 600.ms),
                            ],
                          ),
                        ).animate().fadeIn().scale(),
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
}

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isDarkMode;

  ResultCard({required this.title, required this.value, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
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
              _getIconForSystem(title),
              color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                    color: isDarkMode 
                        ? Color(0xFF4C4DDC)
                        : Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              color: isDarkMode ? Colors.white54 : Colors.black45,
              size: 20,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForSystem(String system) {
    switch (system) {
      case 'Decimal':
        return Icons.looks_one_outlined;
      case 'Binary':
        return Icons.code_outlined;
      case 'Octal':
        return Icons.looks_3_outlined;
      case 'Hexadecimal':
        return Icons.tag_outlined;
      default:
        return Icons.numbers;
    }
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
