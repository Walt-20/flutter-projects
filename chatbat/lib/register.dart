import 'package:chatbat/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  void _register() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, 
          password: _passwordController.text,
      );
      if (newUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfully Register"))
        );
        /*
        TODO add navigator 
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => chatScreen()
          ),
        );
        
         */
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have an account')
        )
      );
      /*
      TODO add navigator
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()
        )
      );
      
       */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF2E86C1).withOpacity(0.65),
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
                      const SizedBox(
                      height: 16.0,
                      ),
                      const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 24.0, 
                            fontWeight: FontWeight.bold,
                        ),
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
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFA61717).withOpacity(0.65),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                          child: const Text('Register!'),
                      )
                    ]
                  ),
              )
            ]
          ),
        ),
    );
  }
}
