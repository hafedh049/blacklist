import 'package:blacklist/views/admin/dashboard.dart';
import 'package:blacklist/views/admin/products.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ProductsTable(),
    );
  }
}
