import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'shuntingyard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userEquation = "";
  var userAnswer = "";

  final List<String> buttons = [
    // ignore formatting
    'C', 'DEL', '%', '/',
    '9', '8', '7', 'x',
    '6', '5', '4', '-',
    '3', '2', '1', '+',
    '0', '.', 'ANS', '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: <Widget>[
          Expanded(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userEquation,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userAnswer,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userEquation = '';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (index == 1) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userEquation = userEquation.substring(
                              0, userEquation.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.green,
                      textColor: Colors.white,
                    );
                  } else if (index == buttons.length - 1) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          solveEquation();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                    );
                  } else {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userEquation += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.deepPurple
                          : Colors.deepPurple[50],
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.deepPurple,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    return ['+', '-', 'x', '/', '%'].contains(x);
  }

  // Shunting Yard algorthim to solve equations
  void solveEquation() {
    if (userEquation.isEmpty) {
      return;
    }

    final List<String> tokens = userEquation.split(RegExp(r'([\+\-\*\/\%])'));
    for (var element in tokens) {
      debugPrint(element);
    }
    final ShuntingYard<double> operandStack = ShuntingYard<double>();

    for (final token in tokens) {
      debugPrint(token);
      if (isOperator(token)) {
        String operator = token;
        final double operand2 = operandStack.pop() ?? 0.0;
        final double operand1 = operandStack.pop() ?? 0.0;
        double result = 0.0;

        switch (operator) {
          case '+':
            result = operand1 + operand2;
            break;
          case '-':
            result = operand1 - operand2;
            break;
          case 'x':
            result = operand1 * operand2;
            break;
          case '/':
            result = operand1 / operand2;
            break;
          case '%':
            result = operand1 % operand2;
            break;
          default:
            break;
        }

        operandStack.push(result);
      } else {
        operandStack.push(double.tryParse(token) ?? 0.0);
      }
    }

    final double finalResult = operandStack.pop() ?? 0.0;

    setState(() {
      userAnswer = finalResult.toString();
      debugPrint(userAnswer);
    });
  }
}
