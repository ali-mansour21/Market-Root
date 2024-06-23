import 'package:flutter/material.dart';
import 'package:mobile/widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/onboarding/boarding_1.png",
      "title": "Market Root",
      "description":
          "Transform your shopping experience with the convenience of doorstep delivery from your favorite local shops!"
    },
    {
      "image": "assets/onboarding/boarding_2.png",
      "title": "Market Root",
      "description":
          "Design unique, personalized items with ease. Add your own images or text, and see your creations come to life instantly!"
    },
    {
      "image": "assets/onboarding/boarding_3.png",
      "title": "Market Root",
      "description":
          "Shop securely with Cash on Delivery. Pay for your order when it arrives—no upfront payments needed. Simple and hassle-free!"
    },
    {
      "image": "assets/onboarding/boarding_4.png",
      "title": "Market Root",
      "description":
          "Whatever the occasion, we’ve got you covered. From celebrations to everyday moments, find everything you need with us."
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onGetStarted() {
    if (_currentPage == _onboardingData.length - 1) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: ),
      // );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingWidget(
                  imagePath: data['image']!,
                  title: data['title']!,
                  description: data['description']!,
                  onGetStarted: _onGetStarted,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => buildDot(index, context),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.teal : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
