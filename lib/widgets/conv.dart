import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
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
      backgroundColor: _isDarkMode ? Color(0xFF1E1E2E) : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Color(0xFF1E1E2E) : Colors.white,
        elevation: 0,
        title: Text(
          'Number System Converter',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: _isDarkMode ? Colors.white : Colors.black,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Number System',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: _selectedSystem,
                  isExpanded: true,
                  dropdownColor: _isDarkMode ? Color(0xFF2E2E42) : Colors.white,
                  items: <String>['Decimal', 'Binary', 'Octal', 'Hexadecimal']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSystem = newValue!;
                      _inputController.clear(); // Clear input when changing system
                      _convertNumber(_inputController.text);
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    labelText: 'Enter $_selectedSystem Number',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: _isDarkMode ? Colors.white70 : Colors.blue[600],
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  inputFormatters: _getInputFormatters(),
                ),
                SizedBox(height: 20),
                Text(
                  'Conversion Results',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: ResultCard(title: 'Decimal', value: _decimalValue, isDarkMode: _isDarkMode),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: ResultCard(title: 'Binary', value: _binaryValue, isDarkMode: _isDarkMode),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: ResultCard(title: 'Octal', value: _octalValue, isDarkMode: _isDarkMode),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: ResultCard(title: 'Hexadecimal', value: _hexValue, isDarkMode: _isDarkMode),
                ),
              ],
            ),
          ),
        ),
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
        color: isDarkMode ? Color(0xFF2E2E42) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode) BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
