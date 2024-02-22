import 'package:flutter/material.dart';

class ClientsProducts extends StatefulWidget {
  const ClientsProducts({super.key});

  @override
  State<ClientsProducts> createState() => _ClientsProductsState();
}

class _ClientsProductsState extends State<ClientsProducts> {
  final List<Map<String, dynamic>> _products_per_client = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{},
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[],
        ),
      ),
    );
  }
}
