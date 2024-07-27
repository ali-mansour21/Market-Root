import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/services/data_service.dart';
import 'package:mobile/utilities/configure.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';

class VendorDetailsScreen extends StatefulWidget {
  final Vendor vendor;

  const VendorDetailsScreen({super.key, required this.vendor});

  @override
  _VendorDetailsScreenState createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VendorDetailsScreen> {
  int _selectedIndex = 1;
  bool _isExpanded = false;
  Map<Product, int> _selectedProducts = {};

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

  void _showOrderDetails(Product product) {
    setState(() {
      if (_selectedProducts.containsKey(product)) {
        _selectedProducts[product] = _selectedProducts[product]! + 1;
      } else {
        _selectedProducts[product] = 1;
      }
      _isExpanded = true;
    });
  }

  void _removeProduct(Product product) {
    setState(() {
      _selectedProducts.remove(product);
      if (_selectedProducts.isEmpty) {
        _isExpanded = false;
      }
    });
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    _selectedProducts.forEach((product, quantity) {
      total += double.parse(product.price) * quantity;
    });
    total += 5; // Adding delivery commission
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('$IMAGE_BASE_URL${widget.vendor.logo}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.vendor.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Promotional Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildProductList(widget.vendor.products),
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _isExpanded
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height,
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  setState(() {
                    _isExpanded = true;
                  });
                } else if (details.primaryVelocity! > 0) {
                  setState(() {
                    _isExpanded = false;
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ..._selectedProducts.keys
                                .map((product) => _buildOrderItem(product)),
                            const SizedBox(height: 20),
                            _buildTotalPrice(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text(
                          "Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => _showOrderDetails(product),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            shadowColor: Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        '$IMAGE_BASE_URL${product.productImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '$IMAGE_BASE_URL${product.productImage}',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_selectedProducts[product]! > 1) {
                      _selectedProducts[product] =
                          _selectedProducts[product]! - 1;
                    } else {
                      _removeProduct(product);
                    }
                  });
                },
              ),
              Text(_selectedProducts[product].toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _selectedProducts[product] =
                        _selectedProducts[product]! + 1;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeProduct(product),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Delivery Fee:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\$5.00',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
