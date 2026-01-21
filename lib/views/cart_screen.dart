import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: cartVm.cart.isEmpty
          ? const Center(child: Text('Carrinho vazio'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartVm.cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cartVm.cart.items[index];
                      return CartItemWidget(item: item);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Subtotal: \$${cartVm.cart.subtotal.toStringAsFixed(2)}',
                      ),
                      Text('Total: \$${cartVm.cart.total.toStringAsFixed(2)}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: cartVm.isCheckingOut
                            ? null
                            : () async {
                                final success = await cartVm.checkout();
                                if (success) {
                                  Navigator.pushNamed(
                                    context,
                                    '/order-finished',
                                  );
                                }
                              },
                        child: cartVm.isCheckingOut
                            ? const CircularProgressIndicator()
                            : const Text('Finalizar Pedido'),
                      ),
                      if (cartVm.checkoutError != null)
                        Text(
                          'Erro: ${cartVm.checkoutError}',
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(item.product.image, width: 50, height: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${item.product.price.toStringAsFixed(2)}'),
                  Text('Subtotal: \$${item.subtotal.toStringAsFixed(2)}'),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () =>
                      cartVm.updateQuantity(item.product.id, item.quantity - 1),
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      cartVm.updateQuantity(item.product.id, item.quantity + 1),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => cartVm.removeProduct(item.product.id),
            ),
          ],
        ),
      ),
    );
  }
}
