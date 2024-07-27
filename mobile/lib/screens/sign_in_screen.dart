import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/utilities/configure.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse('$API_BASE_URL/login-user'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['authorisation']['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in successfully!')),
      );

      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Sign In', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
