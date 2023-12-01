import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'register.dart';
// import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful"))
      );

      /*
      handle successful login TODO

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => chatScreen()
        ),
      );

       */
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login Failed. Wrong Email or Password.')
          )
      );
    }
  }

  Color blendColors(Color color1, Color color2) {
    int redPart = ((color1.red + color2.red)/2).round();
    int greenPart = ((color1.green + color2.green)/2).round();
    int bluePart = ((color1.blue + color2.blue)/2).round();
    return Color.fromARGB(redPart, greenPart, bluePart, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blendColors(
          const Color(0xFFFFFFFF),
          const Color(0xFFA61717).withOpacity(0.65),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/baticon.png'),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Enter Email'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Enter Password'),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFA61717).withOpacity(0.65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                    child: const Text('Login!'),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            /*
                            handle registering TODO

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen())
                            );

                             */
                          },
                          child: const Text("Register here!")
                      ),
                      TextButton(
                          onPressed: () {
                           print("Reset Password...");
                          },
                          child: const Text("Forgot Password?")
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}