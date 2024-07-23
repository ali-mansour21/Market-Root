import 'package:flutter/material.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedIndex = 3;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Orders'),
          bottom: const TabBar(
            indicatorColor: Colors.teal,
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'Pending orders'),
              Tab(text: 'Past orders'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EmptyStateWidget(
              imagePath: 'assets/pending_order.png',
              message: 'Looks like you have no pending orders.',
            ),
            EmptyStateWidget(
              imagePath: 'assets/past_order.png',
              message: 'Looks like you have no past orders.',
            ),
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String imagePath;
  final String message;

  const EmptyStateWidget({
    super.key,
    required this.imagePath,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
