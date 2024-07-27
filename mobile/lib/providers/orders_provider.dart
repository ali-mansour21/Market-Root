import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/order_model.dart';
import 'package:mobile/utilities/configure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersProvider with ChangeNotifier {
  OrdersData? _ordersData;

  OrdersData? get ordersData => _ordersData;

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      _ordersData =
          OrdersData(pendingOrders: [], confirmedOrCanceledOrders: []);
      notifyListeners();
      return;
    }
    const url = '$API_BASE_URL/order';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _ordersData = OrdersData.fromJson(responseData['data']);
        notifyListeners();
      } else {
        print('Failed to load orders: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print('Error fetching orders: $error');
      throw error;
    }
  }
}

class OrdersData {
  final List<Order> pendingOrders;
  final List<Order> confirmedOrCanceledOrders;

  OrdersData({
    required this.pendingOrders,
    required this.confirmedOrCanceledOrders,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    var pendingOrdersJson = json['pending_orders'] as List<dynamic>;
    List<Order> pendingOrdersList = pendingOrdersJson
        .map((i) => Order.fromJson(i as Map<String, dynamic>))
        .toList();

    var confirmedOrCanceledOrdersJson =
        json['confirmed_or_canceled_orders'] as List<dynamic>;
    List<Order> confirmedOrCanceledOrdersList = confirmedOrCanceledOrdersJson
        .map((i) => Order.fromJson(i as Map<String, dynamic>))
        .toList();

    return OrdersData(
      pendingOrders: pendingOrdersList,
      confirmedOrCanceledOrders: confirmedOrCanceledOrdersList,
    );
  }
}
