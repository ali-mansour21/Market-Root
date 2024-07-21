import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/utilities/configure.dart';

class DataService {
  final String _baseUrl = API_BASE_URL;

  Future<List<Category>> fetchData() async {
    final response = await http.get(Uri.parse('$_baseUrl/home'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      print(data);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Category {
  int categoryId;
  String title;
  String imageName;
  String active;
  DateTime createdAt;
  DateTime updatedAt;
  List<Vendor> vendors;

  Category({
    required this.categoryId,
    required this.title,
    required this.imageName,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.vendors,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      title: json['title'],
      imageName: json['image_name'],
      active: json['active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      vendors:
          (json['vendors'] as List).map((i) => Vendor.fromJson(i)).toList(),
    );
  }
}

class Vendor {
  int vendorId;
  int userId;
  int categoryId;
  String status;
  String name;
  String logo;
  DateTime createdAt;
  DateTime updatedAt;
  List<Product> products;

  Vendor({
    required this.vendorId,
    required this.userId,
    required this.categoryId,
    required this.status,
    required this.name,
    required this.logo,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
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
      products:
          (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
    );
  }
}

class Product {
  int productId;
  int vendorId;
  String name;
  String productImage;
  String price;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.productId,
    required this.vendorId,
    required this.name,
    required this.productImage,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      vendorId: json['vendor_id'],
      name: json['name'],
      productImage: json['product_image'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
