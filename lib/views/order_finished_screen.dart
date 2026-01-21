import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';

class OrderFinishedScreen extends StatelessWidget {
  const OrderFinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido Finalizado')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartVm.lastOrder.length,
              itemBuilder: (context, index) {
                final item = cartVm.lastOrder[index];
                return ListTile(
                  leading: Image.network(
                    item.product.image,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(item.product.title),
                  subtitle: Text(
                    'Quantidade: ${item.quantity}, Subtotal: \$${item.subtotal.toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Subtotal: \$${cartVm.lastOrder.fold(0.0, (sum, item) => sum + item.subtotal).toStringAsFixed(2)}',
                ),
                const Text('Frete: \$10.00'),
                Text(
                  'Total: \$${(cartVm.lastOrder.fold(0.0, (sum, item) => sum + item.subtotal) + 10).toStringAsFixed(2)}',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    cartVm.clearErrors();
                    // Limpar carrinho novamente se necessário
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  },
                  child: const Text('Novo Pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
