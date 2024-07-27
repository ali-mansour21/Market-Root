import 'package:flutter/material.dart';
import 'package:mobile/providers/orders_provider.dart';
import 'package:mobile/services/order_model.dart';
import 'package:mobile/utilities/configure.dart';
import 'package:mobile/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => OrdersProvider()..fetchOrders(),
      child: DefaultTabController(
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
          body: Consumer<OrdersProvider>(
            builder: (context, ordersProvider, child) {
              if (ordersProvider.ordersData == null) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.teal,
                ));
              }
              return TabBarView(
                children: [
                  PendingOrdersTab(
                      orders: ordersProvider.ordersData!.pendingOrders),
                  PastOrdersTab(
                      orders:
                          ordersProvider.ordersData!.confirmedOrCanceledOrders),
                ],
              );
            },
          ),
          bottomNavigationBar: CustomNavigationBar(
            currentIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
        ),
      ),
    );
  }
}

class PendingOrdersTab extends StatelessWidget {
  final List<Order> orders;

  const PendingOrdersTab({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyStateWidget(
        imagePath: 'assets/pending_order.png',
        message: 'Looks like you have no pending orders.',
      );
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: Container(
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(
                            '$IMAGE_BASE_URL/${order.vendor.logo}'),
                        fit: BoxFit.fill)),
              ),
              title: Text(order.vendor.name),
              subtitle: Text(
                  'Order placed: ${order.createdAt}\nOrder number: ${order.orderId}'),
            ),
          ),
        );
      },
    );
  }
}

class PastOrdersTab extends StatelessWidget {
  final List<Order> orders;

  PastOrdersTab({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyStateWidget(
        imagePath: 'assets/past_order.png',
        message: 'Looks like you have no past orders.',
      );
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: Image.network(order.vendor.logo, width: 50, height: 50),
              title: Text(order.vendor.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Order placed: ${order.createdAt}\nOrder number: ${order.orderId}'),
                  if (order.status == 'delivered')
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < 4 ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 16,
                        );
                      }),
                    )
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  // Implement reorder functionality
                },
                child:
                    const Text('Reorder', style: TextStyle(color: Colors.teal)),
              ),
            ),
          ),
        );
      },
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
