import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Home.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        CategoryItem(
                          title: 'Handmade',
                          image: 'assets/categories/Handmade.jpg',
                        ),
                        CategoryItem(
                          title: 'Flowers',
                          image: 'assets/categories/Flowers.jpg',
                        ),
                        CategoryItem(
                          title: 'Personal Care',
                          image: 'assets/categories/Personal_Care.jpg',
                        ),
                        CategoryItem(
                          title: 'Bakery',
                          image: 'assets/categories/Bakery.jpg',
                        ),
                        CategoryItem(
                          title: 'Sweets',
                          image: 'assets/categories/Sweets.jpg',
                        ),
                        CategoryItem(
                          title: 'Kitchens',
                          image: 'assets/categories/Kitchens.jpg',
                        ),
                        CategoryItem(
                          title: 'Gifts',
                          image: 'assets/categories/Gifts.jpg',
                        ),
                        CategoryItem(
                          title: 'View All',
                          image: 'assets/categories/View_All.jpg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Market Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Now in Market Root!',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        // Uncomment and use these when market items are available
                        // MarketItem(image: 'assets/market_items/market_item1.png'),
                        // MarketItem(image: 'assets/market_items/market_item2.png'),
                        // MarketItem(image: 'assets/market_items/market_item3.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isCircular;

  const CategoryItem({
    super.key,
    required this.title,
    required this.image,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class MarketItem extends StatelessWidget {
  final String image;

  const MarketItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
