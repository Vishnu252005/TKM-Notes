import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class GraphPlotter extends StatefulWidget {
  @override
  _GraphPlotterState createState() => _GraphPlotterState();
}

class _GraphPlotterState extends State<GraphPlotter> {
  final GlobalKey _globalKey = GlobalKey();
  List<FlSpot> _spots = [];
  Color _lineColor = Colors.blue;
  TextEditingController _pointController = TextEditingController();
  double _xMin = 0;
  double _xMax = 10;
  double _yMin = 0;
  double _yMax = 10;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _saveThemePreference(_isDarkMode);
    });
  }

  void _updateGraph() {
    setState(() {
      _spots = _pointController.text
          .split(';')
          .map((point) {
            List<double> values = point
                .split(',')
                .map((v) => double.tryParse(v) ?? 0)
                .toList();
            return FlSpot(values[0], values[1]);
          })
          .toList();

      _adjustAxisRanges();
    });
  }

  void _adjustAxisRanges() {
    List<double> allXValues = _spots.map((spot) => spot.x).toList();
    List<double> allYValues = _spots.map((spot) => spot.y).toList();

    if (allXValues.isNotEmpty) {
      _xMin = allXValues.reduce((a, b) => a < b ? a : b);
      _xMax = allXValues.reduce((a, b) => a > b ? a : b);
    }
    if (allYValues.isNotEmpty) {
      _yMin = allYValues.reduce((a, b) => a < b ? a : b);
      _yMax = allYValues.reduce((a, b) => a > b ? a : b);
    }
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final directory = await getExternalStorageDirectory();
      final imagePath = File('${directory!.path}/graph.png');
      await imagePath.writeAsBytes(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to ${imagePath.path}')),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Graph Plotter',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.blue[800]),
        ),
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.blue[800]),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: _isDarkMode ? Colors.white : Colors.blue[800],
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.save_alt, color: _isDarkMode ? Colors.white : Colors.blue[800]),
            onPressed: _capturePng,
          ),
        ],
      ),
      backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(isPortrait ? 24.0 : 16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'X: ($_xMin - $_xMax), Y: ($_yMin - $_yMax)',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.black : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isDarkMode ? Colors.black12 : Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Input for XY Graph Points
                      TextField(
                        controller: _pointController,
                        decoration: InputDecoration(
                          labelText: 'Enter Points (x,y) separated by ";"',
                          border: OutlineInputBorder(),
                          hintText: 'E.g. 1,2;3,4;5,6',
                          hintStyle: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.black54),
                        ),
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                        onChanged: (value) => _updateGraph(),
                      ),
                      SizedBox(height: 16),

                      // Graph Plot
                      Expanded(
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: true),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toStringAsFixed(1),
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toStringAsFixed(1),
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _spots,
                                      isCurved: true,
                                      color: _lineColor,
                                      dotData: FlDotData(show: true),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: Colors.deepPurple, width: 2),
                                  ),
                                  minX: _xMin,
                                  maxX: _xMax,
                                  minY: _yMin,
                                  maxY: _yMax,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
