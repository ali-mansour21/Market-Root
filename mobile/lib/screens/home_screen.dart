import 'package:flutter/material.dart';
import 'package:mobile/providers/data_provider.dart';
import 'package:mobile/screens/all_categories_screen.dart';
import 'package:mobile/screens/category_vendor_screen.dart';
import 'package:mobile/services/data_service.dart';
import 'package:mobile/utilities/configure.dart';
import 'package:mobile/widgets/category_item.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkWelcomeDialog();
  }

  Future<void> _checkWelcomeDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isWelcomeDialogShown = prefs.getBool('isWelcomeDialogShown');
    if (isWelcomeDialogShown == null || !isWelcomeDialogShown) {
      _showWelcomeDialog();
      prefs.setBool('isWelcomeDialogShown', true);
    }
  }

  void _showWelcomeDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Welcome to MarketRootapp!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.delivery_dining),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Delivery',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E24)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Select our Pick Up & Get Items at your home. Service and experience the advantage of never waiting for business owner recall.',
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.card_giftcard),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Save money and earn rewards',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E24)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The more you order the more money you save by unlocking exclusive lifetime discounts and rewards from all your favourite coffee brands.',
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Customise your order',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E24)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose your desired shop, browse the menu and customize your order exactly the way you want it.',
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              backgroundColor: Colors.teal),
                          child: const Text(
                            'Got It!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Sign up now',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<DataProvider>(context).categories;

    final vendors = categories
        .skip(1)
        .expand((category) => category.vendors)
        .take(3)
        .toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 28),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ...categories.skip(1).map((category) => CategoryItem(
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
                        CategoryItem(
                          title: 'View All',
                          image: 'assets/categories/View_All.jpg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllCategoriesScreen(),
                              ),
                            );
                          },
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
                          child: const Text(
                            'View All',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: vendors
                          .map((vendor) => MarketItem(vendor: vendor))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onNavItemSelected,
      ),
    );
  }
}

class MarketItem extends StatelessWidget {
  final Vendor vendor;

  const MarketItem({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('$IMAGE_BASE_URL${vendor.logo}'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
