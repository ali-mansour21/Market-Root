import 'package:flutter/material.dart';
import 'package:mobile/screens/vendor_detail_screen.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/data_service.dart';
import 'package:mobile/providers/data_provider.dart';
import 'package:mobile/utilities/configure.dart';

class CategoryVendorsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryVendorsScreen({super.key, required this.categoryName});

  @override
  _CategoryVendorsScreenState createState() => _CategoryVendorsScreenState();
}

class _CategoryVendorsScreenState extends State<CategoryVendorsScreen> {
  int _selectedIndex = 1;

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _onItemSelected(
                0); // Set the index to 0 (home) when back is pressed
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.categoryName),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final category = dataProvider.categories.firstWhere(
            (category) => category.title == widget.categoryName,
            orElse: () => Category(
              title: widget.categoryName,
              vendors: [],
              categoryId: 0,
              imageName: '',
              active: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${category.vendors.length} shops',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: category.vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = category.vendors[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 13.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VendorDetailsScreen(
                                  vendor: vendor,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '$IMAGE_BASE_URL${vendor.logo}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(vendor.name),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
