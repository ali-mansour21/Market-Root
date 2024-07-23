import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/data_service.dart'; // Ensure this import is correct
import 'package:mobile/providers/data_provider.dart'; // Ensure this import is correct
import 'package:mobile/utilities/configure.dart'; // Ensure this import is correct

class CategoryVendorsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryVendorsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(categoryName),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final category = dataProvider.categories.firstWhere(
            (category) => category.title == categoryName,
            orElse: () => Category(
              title: categoryName,
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
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: category.vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = category.vendors[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 16.0), // Add bottom margin
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300, // Set border color
                              width: 1.0, // Set border width
                            ),
                          ),
                        ),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
