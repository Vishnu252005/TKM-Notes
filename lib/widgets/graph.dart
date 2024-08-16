import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GraphPlotter extends StatefulWidget {
  @override
  _GraphPlotterState createState() => _GraphPlotterState();
}

class _GraphPlotterState extends State<GraphPlotter> {
  final GlobalKey _globalKey = GlobalKey();
  List<List<FlSpot>> _spots = List.generate(1, (_) => []);
  final List<TextEditingController> _controllers = [];
  List<Color> _lineColors = [Colors.blue];
  List<String> _graphTitles = ['Graph 1'];
  int _numberOfGraphs = 1;
  int _numberOfPoints = 3;
  double _xMin = 0;
  double _xMax = 10;
  double _yMin = 0;
  double _yMax = 10;
  bool _isXYGraph = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < _numberOfPoints; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _updateGraph() {
    setState(() {
      _spots = List.generate(_numberOfGraphs, (index) {
        return _controllers
            .where((controller) => controller.text.isNotEmpty)
            .map((controller) {
              final values = controller.text.split(',').map(double.tryParse).toList();
              if (_isXYGraph) {
                if (values.length == 2) {
                  return FlSpot(values[0] ?? 0, values[1] ?? 0);
                }
              } else {
                if (values.length == 2) {
                  return FlSpot(values[0] ?? 0, values[1] ?? 0);
                }
              }
              return null;
            })
            .whereType<FlSpot>()
            .toList();
      });

      // Adjust axis ranges based on points
      List<double> allXValues = _spots.expand((spotList) => spotList.map((spot) => spot.x)).toList();
      List<double> allYValues = _spots.expand((spotList) => spotList.map((spot) => spot.y)).toList();
      if (allXValues.isNotEmpty) {
        _xMin = allXValues.reduce((a, b) => a < b ? a : b);
        _xMax = allXValues.reduce((a, b) => a > b ? a : b);
      }
      if (allYValues.isNotEmpty) {
        _yMin = allYValues.reduce((a, b) => a < b ? a : b);
        _yMax = allYValues.reduce((a, b) => a > b ? a : b);
      }
    });
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
        SnackBar(content: Text('Image saved to $imagePath')),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Plotter'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: _capturePng,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Graph Type Selector
                Text(
                  'Select Graph Type:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isXYGraph = true;
                            _updateGraph();
                          });
                        },
                        child: Text('XY Graph'),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isXYGraph = false;
                            _updateGraph();
                          });
                        },
                        child: Text('Time-based Graph'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive height

                // Graph Plot
                Expanded(
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: screenWidth * 0.1, // Responsive size
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    value.toStringAsFixed(1),
                                    style: TextStyle(color: Colors.blue, fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: screenWidth * 0.1, // Responsive size
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    value.toStringAsFixed(1),
                                    style: TextStyle(color: Colors.blue, fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        lineBarsData: List.generate(_numberOfGraphs, (index) {
                          return LineChartBarData(
                            spots: _spots[index],
                            isCurved: true,
                            color: _lineColors[index],
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            aboveBarData: BarAreaData(
                              show: true,
                              color: _lineColors[index].withOpacity(0.2),
                            ),
                          );
                        }),
                        borderData: FlBorderData(show: true),
                        minX: _xMin,
                        maxX: _xMax,
                        minY: _yMin,
                        maxY: _yMax,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive height

                // Dynamic Input Fields
                Text(
                  'Enter Points (x,y):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive height
                Expanded(
                  child: ListView.builder(
                    itemCount: _numberOfPoints,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Point ${index + 1} (x,y)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: (value) => _updateGraph(),
                              ),
                            ),
                            SizedBox(width: 8),
                            if (index == _numberOfPoints - 1) // Show "Add Point" button only for the last point
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _numberOfPoints += 1;
                                    _controllers.add(TextEditingController());
                                  });
                                },
                                child: Icon(Icons.add),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive height

                // Color Selection
                Text(
                  'Select Graph Colors:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive height
                Row(
                  children: List.generate(_numberOfGraphs, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final selectedColor = await showDialog(
                            context: context,
                            builder: (context) {
                              return ColorPickerDialog(
                                initialColor: _lineColors[index],
                              );
                            },
                          );
                          if (selectedColor != null) {
                            setState(() {
                              _lineColors[index] = selectedColor;
                              _updateGraph();
                            });
                          }
                        },
                        child: Container(
                          height: 30,
                          color: _lineColors[index],
                          margin: EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenWidth * 0.02), // Responsive height

                // Update Graph Button
                ElevatedButton(
                  onPressed: _updateGraph,
                  child: Text('Update Graph'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  ColorPickerDialog({required this.initialColor});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _selectedColor,
          onColorChanged: (color) {
            setState(() {
              _selectedColor = color;
            });
          },
          showLabel: false,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(_selectedColor),
        ),
      ],
    );
  }
}
