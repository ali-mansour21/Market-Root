import 'package:flutter/material.dart';
import 'package:mobile/screens/account_creation_screen.dart';
import 'package:mobile/screens/sign_in_screen.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 4;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  void _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setState(() {
      _token = null;
    });
  }

  void onItemSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/profile.png',
                    width: 130,
                    height: 130,
                  ),
                  const SizedBox(height: 20),
                  if (_token == null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 155,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 155,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AccountCreationScreen(),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              title: const Text('Manage alerts'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Language'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Contact'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Terms and Conditions'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
            const Divider(),
            if (_token != null) ...[
              ListTile(
                title: const Text('Sign out'),
                trailing: const Icon(Icons.logout, size: 14),
                onTap: _signOut,
              ),
              const Divider(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: currentIndex,
        onItemSelected: onItemSelected,
      ),
    );
  }
}
