import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/cart_api.dart';
import '../services/checkout_api.dart';

class CartViewModel extends ChangeNotifier {
  final Cart _cart = Cart();
  final CartApi _cartApi = CartApi();
  final CheckoutApi _checkoutApi = CheckoutApi();

  List<CartItem> _lastOrder = [];

  Cart get cart => _cart;
  List<CartItem> get lastOrder => _lastOrder;

  bool _isRemoving = false;
  bool _isCheckingOut = false;
  String? _removeError;
  String? _checkoutError;

  bool get isRemoving => _isRemoving;
  bool get isCheckingOut => _isCheckingOut;
  String? get removeError => _removeError;
  String? get checkoutError => _checkoutError;

  void addProduct(Product product) {
    _cart.addProduct(product);
    notifyListeners();
  }

  Future<void> removeProduct(int productId) async {
    _isRemoving = true;
    _removeError = null;
    notifyListeners();

    try {
      await _cartApi.removeItem(productId);
      _cart.removeProduct(productId);
    } catch (e) {
      _removeError = e.toString();
    } finally {
      _isRemoving = false;
      notifyListeners();
    }
  }

  void updateQuantity(int productId, int quantity) {
    try {
      _cart.updateQuantity(productId, quantity);
      notifyListeners();
    } catch (e) {
      // Handle error, e.g., log or show message
    }
  }

  Future<bool> checkout() async {
    _isCheckingOut = true;
    _checkoutError = null;
    notifyListeners();

    try {
      await _checkoutApi.checkout(_cart);
      _lastOrder = List.from(_cart.items);
      _cart.clear();
      _isCheckingOut = false;
      notifyListeners();
      return true;
    } catch (e) {
      _checkoutError = e.toString();
      _isCheckingOut = false;
      notifyListeners();
      return false;
    }
  }

  void clearErrors() {
    _removeError = null;
    _checkoutError = null;
    notifyListeners();
  }
}
