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
    const url = '$API_BASE_URL/order';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _ordersData = OrdersData.fromJson(responseData['data']);
        notifyListeners();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      throw error;
    }
  }
}
