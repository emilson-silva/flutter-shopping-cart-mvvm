import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/products_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';

import '../widgets/product_item.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsViewModel>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsVm = context.watch<ProductsViewModel>();
    final cartVm = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cartVm.cart.totalQuantity > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartVm.cart.totalQuantity}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: productsVm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsVm.error != null
          ? Center(child: Text('Erro: ${productsVm.error}'))
          : ListView.builder(
              itemCount: productsVm.products.length,
              itemBuilder: (context, index) {
                final product = productsVm.products[index];
                return ProductItem(product: product);
              },
            ),
    );
  }
}
