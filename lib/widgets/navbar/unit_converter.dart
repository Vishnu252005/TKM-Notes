import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme_provider.dart'; // Import the ThemeProvider
import 'dart:ui'; // Add this import for ImageFilter

class UnitConverter extends StatefulWidget {
  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  String _fromUnit = 'Centimeters (cm)';
  String _toUnit = 'Meters (m)';
  double _inputValue = 0.0;
  String _result = '';
  String _difficulty = 'Easy';
  String _searchQuery = '';
  final TextEditingController _inputController = TextEditingController();

  final Map<String, Function(double)> _easyConversionFunctions = {
    'Centimeters (cm)': (value) => value / 100, // cm to m
    'Meters (m)': (value) => value * 100, // m to cm
    'Kilograms (kg)': (value) => value * 2.20462, // kg to lbs
    'Pounds (lbs)': (value) => value / 2.20462, // lbs to kg
    'Celsius (°C)': (value) => (value * 9 / 5) + 32, // C to F
    'Fahrenheit (°F)': (value) => (value - 32) * 5 / 9, // F to C
  };

  final Map<String, Function(double)> _advancedConversionFunctions = {
    // Length
    'Millimeters (mm)': (value) => value / 1000, // mm to m
    'Centimeters (cm)': (value) => value / 100, // cm to m
    'Meters (m)': (value) => value, // m to m
    'Kilometers (km)': (value) => value * 1000, // km to m
    'Inches (in)': (value) => value * 0.0254, // in to m
    'Feet (ft)': (value) => value * 0.3048, // ft to m
    'Yards (yd)': (value) => value * 0.9144, // yd to m
    'Miles (mi)': (value) => value * 1609.34, // mi to m

    // Area
    'Square Millimeters (mm²)': (value) => value / 1e6, // mm² to m²
    'Square Centimeters (cm²)': (value) => value / 10000, // cm² to m²
    'Square Meters (m²)': (value) => value, // m² to m²
    'Hectares (ha)': (value) => value * 10000, // ha to m²
    'Acres (ac)': (value) => value * 4046.86, // acres to m²
    'Square Kilometers (km²)': (value) => value * 1e6, // km² to m²

    // Volume
    'Milliliters (mL)': (value) => value / 1000, // mL to L
    'Centiliters (cL)': (value) => value / 100, // cL to L
    'Deciliters (dL)': (value) => value / 10, // dL to L
    'Liters (L)': (value) => value, // L to L
    'Cubic Meters (m³)': (value) => value * 1000, // m³ to L
    'Gallons (gal)': (value) => value * 3.78541, // gal to L
    'Quarts (qt)': (value) => value * 0.946353, // qt to L
    'Pints (pt)': (value) => value * 0.473176, // pt to L
    'Fluid Ounces (fl oz)': (value) => value * 0.0295735, // fl oz to L

    // Weight
    'Milligrams (mg)': (value) => value / 1000, // mg to g
    'Grams (g)': (value) => value / 1000, // g to kg
    'Kilograms (kg)': (value) => value, // kg to kg
    'Metric Tons (t)': (value) => value * 1000, // t to kg
    'Ounces (oz)': (value) => value * 0.0283495, // oz to kg
    'Pounds (lbs)': (value) => value / 2.20462, // lbs to kg
    'Stones (st)': (value) => value * 6.35029, // st to kg

    // Temperature
    'Celsius (°C)': (value) => value, // C to C
    'Fahrenheit (°F)': (value) => (value - 32) * 5 / 9, // F to C
    'Kelvin (K)': (value) => value - 273.15, // K to C

    // Speed
    'Meters per Second (m/s)': (value) => value, // m/s to m/s
    'Kilometers per Hour (km/h)': (value) => value / 3.6, // km/h to m/s
    'Miles per Hour (mph)': (value) => value * 0.44704, // mph to m/s

    // Pressure
    'Pascals (Pa)': (value) => value, // Pa to Pa
    'Bar (bar)': (value) => value * 100000, // bar to Pa
    'Atmospheres (atm)': (value) => value * 101325, // atm to Pa
    'Millimeters of Mercury (mmHg)': (value) => value * 133.322, // mmHg to Pa

    // Energy
    'Joules (J)': (value) => value, // J to J
    'Kilojoules (kJ)': (value) => value * 1000, // kJ to J
    'Calories (cal)': (value) => value * 4.184, // cal to J
    'Kilocalories (kcal)': (value) => value * 4184, // kcal to J

    // Power
    'Watts (W)': (value) => value, // W to W
    'Kilowatts (kW)': (value) => value * 1000, // kW to W
    'Horsepower (hp)': (value) => value * 745.7, // hp to W

    // Electric Charge
    'Coulombs (C)': (value) => value, // C to C
    'Microcoulombs (µC)': (value) => value * 1e6, // µC to C

    // Electric Resistance
    'Ohms (Ω)': (value) => value, // Ω to Ω
    'Microohms (µΩ)': (value) => value * 1e6, // µΩ to Ω
    'Milliohms (mΩ)': (value) => value * 1000, // mΩ to Ω
    'Kiloohms (kΩ)': (value) => value / 1000, // kΩ to Ω
    'Megaohms (MΩ)': (value) => value / 1e6, // MΩ to Ω

    // Magnetic Flux Density
    'Teslas (T)': (value) => value, // T to T
  };

  void _convert() {
    final conversionFunctions = _difficulty == 'Easy' ? _easyConversionFunctions : _advancedConversionFunctions;

    if (conversionFunctions.containsKey(_fromUnit) && conversionFunctions.containsKey(_toUnit)) {
      double convertedValue = conversionFunctions[_toUnit]!(conversionFunctions[_fromUnit]!(_inputValue));
      setState(() {
        _result = '$convertedValue $_toUnit';
      });
    }
  }

  void _showUnitSearchDialog(bool isFromUnit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchText = '';
        final isDark = Provider.of<ThemeProvider>(context).isDarkMode; // Get the current theme state
        
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                final units = (_difficulty == 'Easy' 
                    ? _easyConversionFunctions.keys 
                    : _advancedConversionFunctions.keys)
                    .where((unit) => 
                        unit.toLowerCase().contains(searchText.toLowerCase()))
                    .toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            isFromUnit ? 'Select From Unit' : 'Select To Unit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Units...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDark ? Colors.white70 : Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              units[index],
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            onTap: () {
                              if (isFromUnit) {
                                this.setState(() {
                                  _fromUnit = units[index];
                                });
                              } else {
                                this.setState(() {
                                  _toUnit = units[index];
                                });
                              }
                              Navigator.pop(context);
                            },
                            hoverColor: isDark ? Colors.grey[700] : Colors.grey[200],
                          ).animate().fadeIn().slideX();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ).animate().scale().fadeIn();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF1A1A2E) : Colors.blue[50],
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(
                color: isDark 
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
                            colors: isDark 
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
                                            Icons.swap_horiz,
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
                                        isDark ? Icons.light_mode : Icons.dark_mode,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Unit\nConverter',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCard(
                        'Difficulty Level',
                        DropdownButton<String>(
                          value: _difficulty,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          underline: Container(),
                          dropdownColor: isDark ? Color(0xFF252542) : Colors.white,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _difficulty = newValue!;
                              _fromUnit = 'Centimeters (cm)';
                              _toUnit = 'Meters (m)';
                              _result = '';
                            });
                          },
                          items: ['Easy', 'Advanced'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ).animate().fadeIn().slideY(),

                      SizedBox(height: 16),

                      _buildCard(
                        'Convert From',
                        _buildUnitSelector(true, isDark),
                      ).animate().fadeIn().slideY(delay: 200.ms),

                      SizedBox(height: 16),

                      _buildCard(
                        'Convert To',
                        _buildUnitSelector(false, isDark),
                      ).animate().fadeIn().slideY(delay: 400.ms),

                      SizedBox(height: 16),

                      _buildCard(
                        'Enter Value',
                        Column(
                          children: [
                            TextField(
                              controller: _inputController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                                prefixIcon: Icon(Icons.calculate),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _inputValue = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _convert,
                              icon: Icon(Icons.swap_horiz),
                              label: Text('Convert', style: TextStyle(fontSize: 18)),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: isDark ? Colors.blue[700] : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(delay: 600.ms),

                      SizedBox(height: 16),

                      if (_result.isNotEmpty)
                        _buildCard(
                          'Result',
                          Text(
                            _result,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.blue[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          color: isDark ? Colors.blue[900] : Colors.blue[50],
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

  Widget _buildCard(String title, Widget content, {Color? color}) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Container(
      decoration: BoxDecoration(
        color: color ?? (isDark ? Color(0xFF252542) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
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
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildUnitSelector(bool isFromUnit, bool isDark) {
    return InkWell(
      onTap: () => _showUnitSearchDialog(isFromUnit),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white30 : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isFromUnit ? _fromUnit : _toUnit),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
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

