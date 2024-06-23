import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onGetStarted;

  const OnboardingWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 200,
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onGetStarted,
          child: Text('Get Started'),
        ),
      ],
    );
  }
}
