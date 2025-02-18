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
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Create a temporary widget with black text for PDF
      final pdfGraph = RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Colors.white,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _spots,
                  isCurved: true,
                  color: Color(0xFF4C4DDC),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Color(0xFF4C4DDC),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Color(0xFF4C4DDC).withOpacity(0.1),
                  ),
                ),
              ],
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 2,
                ),
              ),
              minX: _xMin,
              maxX: _xMax,
              minY: _yMin,
              maxY: _yMax,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );

      // Render the PDF graph
      final RenderRepaintBoundary boundary = 
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Create PDF document
      final pdf = pw.Document();

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
                                            Icons.show_chart,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'PLOTTER',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
          IconButton(
            icon: Icon(
                                            _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                            color: Colors.white,
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
                                          icon: Icon(
                                            Icons.save_alt,
                                            color: Colors.white,
                                          ),
            onPressed: _capturePng,
          ),
        ],
      ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Graph\nPlotter',
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
                              'Enter Points',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                      TextField(
                        controller: _pointController,
                        decoration: InputDecoration(
                          labelText: 'Enter Points (x,y) separated by ";"',
                                labelStyle: TextStyle(
                                  color: _isDarkMode ? Colors.white70 : Colors.blueAccent,
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
                              onChanged: (value) => _updateGraph(),
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
                              'Graph',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            AspectRatio(
                              aspectRatio: 1,
                              child: RepaintBoundary(
                                key: _globalKey,
                              child: LineChart(
                                LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: _isDarkMode 
                                              ? Colors.white.withOpacity(0.2)
                                              : Colors.grey[300]!,
                                          strokeWidth: 1,
                                        );
                                      },
                                      getDrawingVerticalLine: (value) {
                                        return FlLine(
                                          color: _isDarkMode 
                                              ? Colors.white.withOpacity(0.2)
                                              : Colors.grey[300]!,
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                          reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                            value.toStringAsFixed(1),
                                            style: TextStyle(
                                                  color: _isDarkMode 
                                                      ? Colors.white 
                                                      : Colors.black87,
                                              fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                          reservedSize: 45,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toStringAsFixed(1),
                                            style: TextStyle(
                                                color: _isDarkMode 
                                                    ? Colors.white 
                                                    : Colors.black87,
                                              fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _spots,
                                      isCurved: true,
                                        color: Color(0xFF4C4DDC),
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter: (spot, percent, barData, index) {
                                            return FlDotCirclePainter(
                                              radius: 6,
                                              color: Color(0xFF4C4DDC),
                                              strokeWidth: 2,
                                              strokeColor: _isDarkMode 
                                                  ? Colors.white 
                                                  : Colors.white,
                                            );
                                          },
                                        ),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Color(0xFF4C4DDC).withOpacity(0.1),
                                        ),
                                    ),
                                  ],
                                  borderData: FlBorderData(
                                    show: true,
                                      border: Border.all(
                                        color: _isDarkMode 
                                            ? Colors.white.withOpacity(0.5)
                                            : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                  ),
                                  minX: _xMin,
                                  maxX: _xMax,
                                  minY: _yMin,
                                  maxY: _yMax,
                                    backgroundColor: _isDarkMode 
                                        ? Color(0xFF252542)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(delay: 200.ms),
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
