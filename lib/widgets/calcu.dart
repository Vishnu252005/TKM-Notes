import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class ScientificCalculator extends StatefulWidget {
  @override
  _ScientificCalculatorState createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  final TextEditingController _controller = TextEditingController();
  bool _isDarkMode = true;
  String _expression = '';
  String _result = '';
  bool _isRadianMode = true;
  bool _isInverseMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _controller.addListener(_updateExpression);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateExpression);
    _controller.dispose();
    super.dispose();
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

  void _updateExpression() {
    setState(() {
      _expression = _controller.text;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _saveThemePreference();
    });
  }

  void _toggleAngleMode() {
    setState(() {
      _isRadianMode = !_isRadianMode;
    });
  }

  void _toggleInverseMode() {
    setState(() {
      _isInverseMode = !_isInverseMode;
    });
  }

  void _clearExpression() {
    setState(() {
      _expression = '';
      _result = '';
      _controller.clear();
    });
  }

  void _deleteLastCharacter() {
    if (_expression.isNotEmpty) {
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
        _controller.text = _expression;
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _expression.length));
      });
    }
  }

  void _appendToExpression(String text) {
    setState(() {
      _expression += text;
      _controller.text = _expression;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _expression.length));
    });
  }

  void _calculate() {
    try {
      final result = _evaluateExpression(_expression);
      setState(() {
        _result = _expression + ' =';
        _expression = result.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
        _controller.text = _expression;
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
        _expression = '';
        _controller.text = _result;
      });
    }
  }

  double _evaluateExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('π', '${math.pi}').replaceAll('e', '${math.e}');
    List<String> tokens = _tokenize(expression);
    List<String> postfix = _infixToPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  List<String> _tokenize(String expression) {
    RegExp regex = RegExp(r'(\d*\.?\d+)|([-+*/^()])|([a-zA-Z]+)');
    return regex.allMatches(expression).map((m) => m.group(0)!).toList();
  }

  List<String> _infixToPostfix(List<String> infix) {
    List<String> output = [];
    List<String> operatorStack = [];
    Map<String, int> precedence = {
      '+': 1, '-': 1, '*': 2, '/': 2, '^': 3,
      'sin': 4, 'cos': 4, 'tan': 4, 'log': 4, 'ln': 4, 'sqrt': 4,
      'asin': 4, 'acos': 4, 'atan': 4,
    };

    for (String token in infix) {
      if (double.tryParse(token) != null) {
        output.add(token);
      } else if (token == '(') {
        operatorStack.add(token);
      } else if (token == ')') {
        while (operatorStack.isNotEmpty && operatorStack.last != '(') {
          output.add(operatorStack.removeLast());
        }
        if (operatorStack.isNotEmpty && operatorStack.last == '(') {
          operatorStack.removeLast();
        }
      } else if (precedence.containsKey(token)) {
        while (operatorStack.isNotEmpty &&
            precedence.containsKey(operatorStack.last) &&
            precedence[operatorStack.last]! >= precedence[token]!) {
          output.add(operatorStack.removeLast());
        }
        operatorStack.add(token);
      }
    }

    while (operatorStack.isNotEmpty) {
      output.add(operatorStack.removeLast());
    }

    return output;
  }

  double _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];

    for (String token in postfix) {
      if (double.tryParse(token) != null) {
        stack.add(double.parse(token));
      } else {
        switch (token) {
          case '+':
            double b = stack.removeLast();
            double a = stack.removeLast();
            stack.add(a + b);
            break;
          case '-':
            double b = stack.removeLast();
            double a = stack.removeLast();
            stack.add(a - b);
            break;
          case '*':
            double b = stack.removeLast();
            double a = stack.removeLast();
            stack.add(a * b);
            break;
          case '/':
            double b = stack.removeLast();
            double a = stack.removeLast();
            stack.add(a / b);
            break;
          case '^':
            double b = stack.removeLast();
            double a = stack.removeLast();
            stack.add(math.pow(a, b).toDouble());
            break;
          case 'sin':
            double a = stack.removeLast();
            stack.add(_isRadianMode ? math.sin(a) : math.sin(a * math.pi / 180));
            break;
          case 'cos':
            double a = stack.removeLast();
            stack.add(_isRadianMode ? math.cos(a) : math.cos(a * math.pi / 180));
            break;
          case 'tan':
            double a = stack.removeLast();
            stack.add(_isRadianMode ? math.tan(a) : math.tan(a * math.pi / 180));
            break;
          case 'asin':
            double a = stack.removeLast();
            double result = math.asin(a);
            stack.add(_isRadianMode ? result : result * 180 / math.pi);
            break;
          case 'acos':
            double a = stack.removeLast();
            double result = math.acos(a);
            stack.add(_isRadianMode ? result : result * 180 / math.pi);
            break;
          case 'atan':
            double a = stack.removeLast();
            double result = math.atan(a);
            stack.add(_isRadianMode ? result : result * 180 / math.pi);
            break;
          case 'log':
            double a = stack.removeLast();
            stack.add(math.log(a) / math.ln10);
            break;
          case 'ln':
            double a = stack.removeLast();
            stack.add(math.log(a));
            break;
          case 'sqrt':
            double a = stack.removeLast();
            stack.add(math.sqrt(a));
            break;
          case 'x!':
            double a = stack.removeLast();
            stack.add(_factorial(a));
            break;
          case '1/x':
            double a = stack.removeLast();
            stack.add(1 / a);
            break;
        }
      }
    }

    return stack.first;
  }

  double _factorial(double n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.black : Colors.blue,
        title: Text('Calculator', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 32,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 24,
                        color: _isDarkMode ? Colors.grey : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: (constraints.maxWidth / constraints.maxHeight) * 2,
                      children: _buildButtons(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      _buildButton('2nd', isFunction: true, onPressed: _toggleInverseMode),
      _buildButton('sin', isFunction: true, onPressed: () => _appendToExpression(_isInverseMode ? 'asin(' : 'sin(')),
      _buildButton('cos', isFunction: true, onPressed: () => _appendToExpression(_isInverseMode ? 'acos(' : 'cos(')),
      _buildButton('tan', isFunction: true, onPressed: () => _appendToExpression(_isInverseMode ? 'atan(' : 'tan(')),
      _buildButton('√', isFunction: true, onPressed: () => _appendToExpression('sqrt(')),
      _buildButton('ln', isFunction: true, onPressed: () => _appendToExpression('ln(')),
      _buildButton('log', isFunction: true, onPressed: () => _appendToExpression('log(')),
      _buildButton('x!', isFunction: true, onPressed: () => _appendToExpression('x!')),
      _buildButton('π', onPressed: () => _appendToExpression('π')),
      _buildButton('e', onPressed: () => _appendToExpression('e')),
      _buildButton('^', onPressed: () => _appendToExpression('^')),
      _buildButton('1/x', isFunction: true, onPressed: () => _appendToExpression('1/')),
      _buildButton('7', onPressed: () => _appendToExpression('7')),
      _buildButton('8', onPressed: () => _appendToExpression('8')),
      _buildButton('9', onPressed: () => _appendToExpression('9')),
      _buildButton('÷', isOperator: true, onPressed: () => _appendToExpression('÷')),
      _buildButton('4', onPressed: () => _appendToExpression('4')),
      _buildButton('5', onPressed: () => _appendToExpression('5')),
      _buildButton('6', onPressed: () => _appendToExpression('6')),
      _buildButton('×', isOperator: true, onPressed: () => _appendToExpression('×')),
      _buildButton('1', onPressed: () => _appendToExpression('1')),
      _buildButton('2', onPressed: () => _appendToExpression('2')),
      _buildButton('3', onPressed: () => _appendToExpression('3')),
      _buildButton('-', isOperator: true, onPressed: () => _appendToExpression('-')),
      _buildButton('.', onPressed: () => _appendToExpression('.')),
      _buildButton('0', onPressed: () => _appendToExpression('0')),
      _buildButton('⌫', onPressed: _deleteLastCharacter),
      _buildButton('+', isOperator: true, onPressed: () => _appendToExpression('+')),
      _buildButton('AC', isOperator: true, onPressed: _clearExpression),
      _buildButton('rad', isFunction: true, onPressed: _toggleAngleMode),
      _buildButton('=', isOperator: true, onPressed: _calculate),
    ];
  }

  Widget _buildButton(String text, {bool isOperator = false, bool isFunction = false, VoidCallback? onPressed}) {
    Color buttonColor = _isDarkMode ? Colors.grey[900]! : Colors.grey[200]!;
    Color textColor = _isDarkMode ? Colors.white : Colors.black;

    if (isOperator) {
      buttonColor = Colors.blue;
      textColor = Colors.white;
    } else if (isFunction) {
      buttonColor = _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScientificCalculator(),
  ));
}
