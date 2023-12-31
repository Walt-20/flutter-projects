import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'customstack.dart';

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
      backgroundColor: Colors.blue[200],
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
                          reversePolishNotation();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue,
                      textColor: Colors.white,
                    );
                  } else {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          // check if an operator preceeds another, so if - preceeds +
                          // then we change the plus symbol to a minus and drop the negative number
                          userEquation += buttons[index];
                        });
                        debugPrint(userEquation);
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.blue
                          : Colors.blue[50],
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.blue,
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

  bool isDigit(String s) {
    return double.tryParse(s) != null;
  }

  int precedence(String x) {
    if (x == '+' || x == '-') {
      return 1;
    } else if (x == 'x' || x == '/') {
      return 2;
    } else {
      return 0;
    }
  }

  // Shunting Yard algorthim to solve equations
  void reversePolishNotation() {
    if (userEquation.isEmpty) {
      debugPrint("is empty");
    }

    // Stack
    final CustomStack<String> stack = CustomStack<String>();
    String output = "";
    String numberBuffer = "";
    bool lastTokenWasOperator =
        true; // Initialize as true to handle leading negative numbers

    for (var i = 0; i < userEquation.length; i++) {
      String token = userEquation[i];

      // Check if the token is a digit, decimal point, or negative sign
      if (isDigit(token) ||
          token == '.' ||
          (token == '-' && lastTokenWasOperator)) {
        numberBuffer += token;
        lastTokenWasOperator = false;
      } else {
        // If a number has been collected in numberBuffer, add it to the output
        if (numberBuffer.isNotEmpty) {
          output += numberBuffer + " ";
          numberBuffer = "";
        }
        lastTokenWasOperator = true;

        if (token == '(') {
          stack.push(token);
        } else if (token == ')') {
          while (!stack.isEmpty && stack.peek() != '(') {
            output += stack.pop() + " ";
          }
          stack.pop(); // Pop the '('
        } else {
          while (!stack.isEmpty &&
              precedence(token) <= precedence(stack.peek().toString()) &&
              isOperator(token)) {
            output += stack.pop() + " ";
          }
          debugPrint("else statement $output");
          debugPrint("token is $token");
          stack.push(token);
        }
      }
    }

    // If there's any remaining number in the buffer, add it to the output
    if (numberBuffer.isNotEmpty) {
      output += numberBuffer + " ";
    }

    while (!stack.isEmpty) {
      output += stack.pop() + " ";
    }

    // Now, you can evaluate the RPN expression in 'output' to get the final result.
    userAnswer = evaluateRPN(output).toString();
    debugPrint("userAnswer is $userAnswer");
    if (userAnswer == 'NaN') {
      userAnswer = "Cannot divide by 0";
    }
  }

  double evaluateRPN(String rpnExpression) {
    debugPrint("the rpnExpression is $rpnExpression");
    final CustomStack<double> stack = CustomStack<double>();
    final List<String> tokens = rpnExpression.split(' ');

    for (var i = 0; i < tokens.length; i++) {
      String token = tokens[i];
      debugPrint("evaluateRPN $token");
      if (!isOperator(token)) {
        // Check if the token starts with a minus sign and is not just "-" itself
        if (token.startsWith('-') && token.length > 1) {
          double negativeNum = double.parse(token.substring(1));
          negativeNum = -negativeNum;
          debugPrint("the negative number is $negativeNum");
          stack.push(negativeNum ?? 0.0);
        } else {
          stack.push(double.tryParse(token) ?? 0.0);
        }
      } else {
        final double operand2 = stack.pop();
        debugPrint("operand2 is $operand2");
        final double operand1 = stack.pop();
        debugPrint("operand1 is $operand1");
        double result = 0.0;

        switch (token) {
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
            if (operand2 != 0) {
              result = operand1 / operand2;
            } else {
              return double.nan; // Handle division by zero error
            }
            break;
          case '%':
            result = operand1 % operand2;
            break;
          default:
            break;
        }
        debugPrint("What is the result? $result");
        stack.push(result);
        debugPrint("What is on the stack? ${stack.peek()}");
      }
    }
    debugPrint("popping the result is ${stack.pop()}");
    return stack.pop();
  }
}
