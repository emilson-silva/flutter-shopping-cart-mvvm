import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/products_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'views/catalog_screen.dart';
import 'views/cart_screen.dart';
import 'views/order_finished_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const CatalogScreen(),
        '/cart': (context) => const CartScreen(),
        '/order-finished': (context) => const OrderFinishedScreen(),
      },
    );
  }
}
