import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();
    final matchingItems = cartVm.cart.items.where(
      (item) => item.product.id == product.id,
    );
    final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(product.image, width: 50, height: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${product.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
            if (cartItem == null)
              ElevatedButton(
                onPressed: () {
                  try {
                    cartVm.addProduct(product);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Limite Atingido'),
                          content: const Text(
                            'Não é possível adicionar mais de 10 produtos diferentes. Retornando ao catálogo.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Adicionar'),
              )
            else
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => cartVm.updateQuantity(
                      product.id,
                      cartItem.quantity - 1,
                    ),
                  ),
                  Text('${cartItem.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => cartVm.updateQuantity(
                      product.id,
                      cartItem.quantity + 1,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
