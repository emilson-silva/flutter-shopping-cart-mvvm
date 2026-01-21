class CartApi {
  Future<void> removeItem(int productId) async {
    await Future.delayed(const Duration(seconds: 1));
    if (productId == 1) {
      throw Exception('Failed to remove item');
    }
  }
}
