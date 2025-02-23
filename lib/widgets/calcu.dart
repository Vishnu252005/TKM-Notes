import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class ScientificCalculator extends StatefulWidget { 
  const ScientificCalculator({super.key}); 
  
  @override 
  State<ScientificCalculator> createState() => _ScientificCalculatorState(); 
} 
  
class _ScientificCalculatorState extends State<ScientificCalculator> { 
  double num1 = 0.0; 
  double num2 = 0.0; 
  var input = ''; 
  var output = ''; 
  var operation = ''; 
  //var hideinput=false; 
  var outputSize=32.0; 
  
  _onButtonClicked(value) { 
    if (value == "AC") { 
      input = ''; 
      output = ''; 
    } else if (value == "A") { 
      if (input.isNotEmpty) { 
        input = input.substring(0, input.length - 1); 
      } 
    } else if (value == "=") { 
      if (input.isNotEmpty) { 
        var userinput = input; 
        userinput = input.replaceAll("", ""); 
        Parser P = Parser(); 
        Expression expression = P.parse(userinput); 
        ContextModel cm = ContextModel(); 
        var finalvalue = expression.evaluate(EvaluationType.REAL, cm); 
        output = finalvalue.toString(); 
        if (output.endsWith(".0")) { 
          output = output.substring(0, output.length - 2); 
        } 
        // input=output; 
        // hideinput=true; 
        // outputSize=50; 
        
      } 
    } else { 
      input = input + value; 
    } 
    setState(() {}); 
  } 
  
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Column( 
        // ignore: prefer_const_literals_to_create_immutables 
        children: [ 
          Expanded( 
            child: Container( 
              height: 200, 
              width: double.infinity, 
              color: Colors.transparent, 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.end, 
                mainAxisAlignment: MainAxisAlignment.end, 
                // ignore: prefer_const_literals_to_create_immutables 
                children: [ 
                  Text( 
                    input, 
                    style: TextStyle(fontSize: 48, color: Colors.white), 
                  ), 
                  SizedBox( 
                    height: 10, 
                  ), 
                  Text( 
                    output, 
                    style: TextStyle( 
                    fontSize: 30, 
                      color: Colors.white.withOpacity(0.7), 
                    ), 
                  ), 
                  SizedBox( 
                    height: 20, 
                  ), 
                ], 
              ), 
            ), 
          ), 
          Row( 
            // ignore: prefer_const_literals_to_create_immutables 
            children: [ 
              button("AC", Colors.black, Colors.orangeAccent), 
              button("A", Colors.black, Colors.orangeAccent), 
              button("", Colors.transparent, Colors.white), 
              button("/", Colors.black, Colors.orangeAccent), 
            ], 
          ), 
          Row( 
            // ignore: prefer_const_literals_to_create_immutables 
            children: [ 
              button("7", Colors.black, Colors.white), 
              button("8", Colors.black, Colors.white), 
              button("9", Colors.black, Colors.white), 
              button("*", Colors.black, Colors.orangeAccent), 
            ], 
          ), 
          Row( 
            // ignore: prefer_const_literals_to_create_immutables 
            children: [ 
              button("4", Colors.black, Colors.white), 
              button("5", Colors.black, Colors.white), 
              button("6", Colors.black, Colors.white), 
              button("-", Colors.black, Colors.orangeAccent), 
            ], 
          ), 
          Row( 
            // ignore: prefer_const_literals_to_create_immutables 
            children: [ 
              button("1", Colors.black, Colors.white), 
              button("2", Colors.black, Colors.white), 
              button("3", Colors.black, Colors.white), 
              button("+", Colors.black, Colors.orangeAccent), 
            ], 
          ), 
          Row( 
            // ignore: prefer_const_literals_to_create_immutables 
            children: [ 
              button("%", Colors.black, Colors.orangeAccent), 
              button("0", Colors.black, Colors.white), 
              button(".", Colors.black, Colors.white), 
              button("=", Colors.orangeAccent, Colors.white), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
  
  button(text, color, tcolor) { 
    return Expanded( 
      child: Container( 
        padding: EdgeInsets.all(10), 
        child: ElevatedButton( 
          style: ElevatedButton.styleFrom( 
            padding: EdgeInsets.all(10), 
            shape: RoundedRectangleBorder( 
              borderRadius: BorderRadius.circular(5), 
            ), 
            backgroundColor: color, 
          ), 
          onPressed: () => _onButtonClicked(text), 
          child: Text( 
            text, 
            style: TextStyle( 
                fontSize: 15, fontWeight: FontWeight.bold, color: tcolor), 
          ), 
        ), 
      ), 
    ); 
  } 
} 