import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/utilities/configure.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({super.key});

  @override
  _AccountCreationScreenState createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted || !_privacyAccepted) return;

    final response = await http.post(Uri.parse('$API_BASE_URL/user'), body: {
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'phone_number': _phoneNumberController.text,
      'city': _cityController.text,
      'street': _streetController.text,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['authorization']['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create account.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Create an account',
            style: TextStyle(color: Colors.black)),
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
              const Text(
                  'We just need a few details from you to set up your account.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _phoneNumberController,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _streetController,
                cursorColor: Colors.teal,
                decoration: const InputDecoration(
                  labelText: 'Street',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    focusColor: Colors.teal,
                    activeColor: Colors.teal,
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        // Open terms and conditions
                      },
                      child: const Text(
                        'I have read and agree to the Terms and Conditions',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    focusColor: Colors.teal,
                    activeColor: Colors.teal,
                    value: _privacyAccepted,
                    onChanged: (value) {
                      setState(() {
                        _privacyAccepted = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open privacy policy
                    },
                    child: const Text(
                      'I have read and agree to the Privacy policy',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _termsAccepted && _privacyAccepted
                      ? _createAccount
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _termsAccepted && _privacyAccepted
                        ? Colors.teal
                        : Colors.grey,
                  ),
                  child: const Text(
                    'Create Account',
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
