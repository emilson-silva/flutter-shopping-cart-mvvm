import '../models/cart.dart';

class CheckoutApi {
  Future<void> checkout(Cart cart) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulação de sucesso
  }
}
