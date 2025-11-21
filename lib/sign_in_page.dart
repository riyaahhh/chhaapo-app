import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> loginWithUsernameAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 235, 253),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 246, 235, 253),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.adf_scanner_outlined, color: Colors.black),
            const SizedBox(width: 8),
            const Text('Chhapo',style: TextStyle(color: Color.fromARGB(255, 119, 63, 251),fontWeight: FontWeight.bold,fontSize: 20,
            ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          const Text('Chhapo', textAlign: TextAlign.center, style: TextStyle(color: Color.fromARGB(255, 119, 63, 251),fontWeight: FontWeight.bold,fontSize: 20,
            ),
            ),
            Text('Welcome back! Sign in to your account', textAlign: TextAlign.center, style: TextStyle(color: Colors.black,fontSize: 16,
            ),
            ),
          Card(
            margin: const EdgeInsets.all(40.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height:  10),
                  const Text('Email Address',
                  textAlign: TextAlign.left,
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Name',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_outline),
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Password',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await loginWithUsernameAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Don\'t have an account? Sign Up',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ],
              ),
            )
          
          ),
          const SizedBox(height: 20),
          const Text( 'By continuing, you agree to our Terms of Service',)
        ],
      ),
    );
  }
}
