import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/screens/vendor_detail_screen.dart';
import 'package:mobile/services/data_service.dart';
import 'package:mobile/utilities/configure.dart';
import 'package:provider/provider.dart';
import 'package:mobile/screens/category_vendor_screen.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:mobile/providers/data_provider.dart';
import 'package:mobile/widgets/category_item_large.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  int _selectedIndex = 1;
  final GlobalKey<CustomNavigationBarState> _navBarKey =
      GlobalKey<CustomNavigationBarState>();
  final TextEditingController _searchController = TextEditingController();
  Future<List<dynamic>>? _searchResults;

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
        Navigator.pushNamed(context, '/order');
        break;
      case 4:
        Navigator.pushNamed(context, '/account');
        break;
      default:
        break;
    }
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _searchResults = _performSearch(_searchController.text);
      });
    } else {
      setState(() {
        _searchResults = null;
      });
    }
  }

  Future<List<dynamic>> _performSearch(String query) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/home/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse[
          'data']; // Assuming 'data' key holds the list of vendors
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<DataProvider>(context).categories;
    final focusNode = FocusNode();

    return Scaffold(
      backgroundColor: Colors.white,
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
              controller: _searchController,
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
          child: _searchResults == null
              ? _buildCategoriesList(categories)
              : FutureBuilder<List<dynamic>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildNoResults();
                    } else {
                      return _buildSearchResults(snapshot.data!);
                    }
                  },
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

  Widget _buildCategoriesList(List<Category> categories) {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorDetailsScreen(
                        vendor: Vendor.fromJson(result),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            NetworkImage('$IMAGE_BASE_URL/${result['logo']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorDetailsScreen(
                        vendor: Vendor.fromJson(result),
                      ),
                    ),
                  );
                },
                child: Text(
                  result['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (index != results.length - 1) const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildNoResults() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oh no!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "We couldn't find anything for your search.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching another key word.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
