import 'package:flutter/material.dart';
import 'package:mobile/services/data_service.dart';

class DataProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<void> fetchData() async {
    setLoading(true);
    try {
      final dataService = DataService();
      final categories = await dataService.fetchData();
      setCategories(categories);
    } catch (e) {
      // Handle error
    }
    setLoading(false);
  }
}
