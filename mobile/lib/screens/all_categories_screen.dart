import 'package:flutter/material.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/data_provider.dart';
import 'package:mobile/widgets/category_item_large.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<DataProvider>(context).categories;
    final focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(color: Colors.teal),
            ),
            child: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: 'Search for a store or an item',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => focusNode.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 20.0, // Add space between rows
                  children: [
                    ...categories.skip(1).map((category) => CategoryItemLarge(
                          title: category.title,
                          image: 'assets/categories/${category.title}.jpg',
                          onTap: () {
                            // Implement navigation to the vendors screen if needed
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
