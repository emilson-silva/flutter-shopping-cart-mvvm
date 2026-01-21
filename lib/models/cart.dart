import 'cart_item.dart';
import 'product.dart';

class Cart {
  final List<CartItem> items = [];

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get total => subtotal; // sem frete por enquanto

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  void addProduct(Product product) {
    if (items.length >= 10 &&
        !items.any((item) => item.product.id == product.id)) {
      throw Exception('Cannot add more than 10 different products');
    }
    final existingItem = items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );
    if (!items.contains(existingItem)) {
      items.add(existingItem);
    } else {
      existingItem.quantity++;
    }
  }

  void removeProduct(int productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    CartItem? item;
    try {
      item = items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      item = null;
    }
    if (item != null) {
      item.quantity = quantity;
    }
  }

  void clear() {
    items.clear();
  }
}
