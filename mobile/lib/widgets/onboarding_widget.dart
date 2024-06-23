import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int currentPage;
  final int totalPageCount;
  final VoidCallback onGetStarted;

  OnboardingWidget({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.totalPageCount,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 35,
              color: Color(0xFF00BFA5),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            imagePath,
            height: 300,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPageCount,
              (index) => buildDot(index, context),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onGetStarted,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF00BFA5)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.teal : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
