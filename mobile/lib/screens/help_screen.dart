import 'package:flutter/material.dart';
import 'package:mobile/screens/buy_something_screen.dart';
import 'package:mobile/screens/consult_screen.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int currentIndex = 2;

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
        padding: const EdgeInsets.only(top: 40),
        child: ListView(
          children: [
            ListTile(
              leading:
                  Image.asset('assets/shopping.png', width: 80, height: 90),
              title: const Text('Buy something',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: const Text(
                "Didn't find what you were looking for at our stores? Our help can buy whatever you need from your store of choice.",
                maxLines: 4,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BuySomethingScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading:
                  Image.asset('assets/AI_ChatBot.png', width: 80, height: 90),
              title: const Text('Consult AI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  "Ask AI for some ideas, ask for what you need, the image"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConsultAIScreen()),
                );
              },
            ),
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
