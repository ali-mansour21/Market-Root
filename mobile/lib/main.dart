import 'package:flutter/material.dart';
import 'package:mobile/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Root',
      routes: {'/': (context) => SplashScreen()},
      debugShowCheckedModeBanner: false,
    );
  }
}
