import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
          const SizedBox(height: 16),
          // Category Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                CategoryItem(
                    title: 'Handmade', image: 'assets/categories/Handmade.png'),
                CategoryItem(
                    title: 'Flowers', image: 'assets/categories/Flowers.png'),
                CategoryItem(
                    title: 'Personal Care',
                    image: 'assets/categories/Personal_Care.png'),
                CategoryItem(
                    title: 'Bakery', image: 'assets/categories/Bakery.png'),
                CategoryItem(
                    title: 'Sweets', image: 'assets/categories/Sweets.png'),
                CategoryItem(
                    title: 'Kitchens', image: 'assets/categories/Kitchens.png'),
                CategoryItem(title: 'Gifts', image: 'assets/Gifts.png'),
                CategoryItem(
                    title: 'View All', image: 'assets/categories/View_All.png'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Market Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Now in Market Root!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                MarketItem(image: 'assets/market_item1.png'),
                MarketItem(image: 'assets/market_item2.png'),
                MarketItem(image: 'assets/market_item3.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;

  const CategoryItem({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center),
      ],
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
