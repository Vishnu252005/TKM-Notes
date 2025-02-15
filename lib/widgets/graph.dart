import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      try {
        _spots = _pointController.text
            .split(';')
            .where((point) => point.trim().isNotEmpty) // Filter empty entries
            .map((point) {
              final values = point.split(',');
              if (values.length != 2) return null;
              final x = double.tryParse(values[0].trim());
              final y = double.tryParse(values[1].trim());
              if (x == null || y == null) return null;
              return FlSpot(x, y);
            })
            .where((spot) => spot != null)
            .cast<FlSpot>()
            .toList();

        _adjustAxisRanges();
      } catch (e) {
        print('Error updating graph: $e');
        // Set default values if parsing fails
        _spots = [];
        _xMin = 0;
        _xMax = 10;
        _yMin = 0;
        _yMax = 10;
      }
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
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Capture the graph as an image
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Create PDF document
      final pdf = pw.Document();

      // Use default built-in fonts instead of custom fonts
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Graph Plot',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Image(pw.MemoryImage(pngBytes), height: 400),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Points: ${_pointController.text}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    'X Range: $_xMin to $_xMax, Y Range: $_yMin to $_yMax',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (kIsWeb) {
        final bytes = await pdf.save();
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download = 'graph_plot.pdf';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Graph PDF downloaded successfully')),
        );
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/graph_plot.pdf');
        await file.writeAsBytes(await pdf.save());

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Graph PDF Generated'),
              content: Text('What would you like to do with the PDF?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await OpenFile.open(file.path);
                    Navigator.pop(context);
                  },
                  child: Text('Open'),
                ),
                TextButton(
                  onPressed: () async {
                    await Share.shareXFiles([XFile(file.path)], text: 'Graph Plot');
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
      // Make sure to close loading dialog if there's an error
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: ${e.toString()}')),
      );
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
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.blueAccent),
        ),
        backgroundColor: _isDarkMode ? Colors.black87 : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.blueAccent),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: _isDarkMode ? Colors.white : Colors.blueAccent,
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.save_alt, color: _isDarkMode ? Colors.white : Colors.blueAccent),
            onPressed: _capturePng,
          ),
        ],
      ),
      backgroundColor: _isDarkMode ? Color(0xFF1A1A1A) : Colors.blue[50],
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
                    color: _isDarkMode ? Colors.white : Colors.blueAccent,
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
                  color: _isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isDarkMode ? Colors.black54 : Colors.blue.withOpacity(0.1),
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
                          labelStyle: TextStyle(color: _isDarkMode ? Colors.white : Colors.blueAccent),
                          border: OutlineInputBorder(),
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
                                              color: _isDarkMode ? Colors.white : Colors.blueAccent,
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
                                              color: _isDarkMode ? Colors.white : Colors.blueAccent,
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
                                    border: Border.all(color: Colors.blueAccent, width: 2),
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
