import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/screens/category_vendor_screen.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:mobile/providers/data_provider.dart';
import 'package:mobile/widgets/category_item_large.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  int _selectedIndex = 1;
  final GlobalKey<CustomNavigationBarState> _navBarKey =
      GlobalKey<CustomNavigationBarState>();

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/help');
        break;
      case 3:
        Navigator.pushNamed(context, '/orders');
        break;
      case 4:
        Navigator.pushNamed(context, '/account');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<DataProvider>(context).categories;
    final focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _navBarKey.currentState?.updateIndex(0);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
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
                  runSpacing: 20.0,
                  children: [
                    ...categories.skip(1).map((category) => CategoryItemLarge(
                          title: category.title,
                          image: 'assets/categories/${category.title}.jpg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryVendorsScreen(
                                  categoryName: category.title,
                                ),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        key: _navBarKey,
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
