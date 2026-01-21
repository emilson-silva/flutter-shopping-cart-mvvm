import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/products_api.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsApi _api = ProductsApi();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _api.fetchProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
