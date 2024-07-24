import 'package:flutter/material.dart';
import 'package:mobile/providers/data_provider.dart';
import 'package:mobile/screens/all_categories_screen.dart';
import 'package:mobile/screens/help_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/order_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DataProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Root',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const AllCategoriesScreen(),
        '/order': (context) => const OrdersScreen(),
        '/help': (context) => const HelpScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
