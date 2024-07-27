import 'package:flutter/foundation.dart';

class Vendor {
  final int vendorId;
  final int userId;
  final int categoryId;
  final String status;
  final String name;
  final String logo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vendor({
    required this.vendorId,
    required this.userId,
    required this.categoryId,
    required this.status,
    required this.name,
    required this.logo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      status: json['Status'],
      name: json['name'],
      logo: json['logo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class OrderItem {
  final int orderItemId;
  final int orderId;
  final int productId;
  final int quantity;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['order_item_id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Order {
  final int orderId;
  final int userId;
  final int vendorId;
  final String totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> orderItems;
  final Vendor vendor;

  Order({
    required this.orderId,
    required this.userId,
    required this.vendorId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
    required this.vendor,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderItemsJson = json['order_items'] as List;
    List<OrderItem> orderItemsList =
        orderItemsJson.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      orderId: json['order_id'],
      userId: json['user_id'],
      vendorId: json['vendor_id'],
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderItems: orderItemsList,
      vendor: Vendor.fromJson(json['vendor']),
    );
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
    var pendingOrdersJson = json['pending_orders'] as List;
    List<Order> pendingOrdersList =
        pendingOrdersJson.map((i) => Order.fromJson(i)).toList();

    var confirmedOrCanceledOrdersJson =
        json['confirmed_or_canceled_orders'] as List;
    List<Order> confirmedOrCanceledOrdersList =
        confirmedOrCanceledOrdersJson.map((i) => Order.fromJson(i)).toList();

    return OrdersData(
      pendingOrders: pendingOrdersList,
      confirmedOrCanceledOrders: confirmedOrCanceledOrdersList,
    );
  }
}
