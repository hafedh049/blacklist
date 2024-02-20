import 'dart:math';

import 'package:flutter/material.dart';

class Recepie extends StatefulWidget {
  const Recepie({super.key});

  @override
  State<Recepie> createState() => _RecepieState();
}

class _RecepieState extends State<Recepie> {
  final List<Map<String, dynamic>> _recepies = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{
      "username": <String>["User ${index + 1}", "Anonymous"][Random().nextInt(2)],
      "birth_date": DateTime.fromMillisecondsSinceEpoch(Random().nextInt(4000) * Random().nextInt(4000)),
      "cin": List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join(),
      "products": List<String>.generate(
        20,
        (int index) => "${index + 1} ο ${["Vape", "Meat", "Fish", "Steak", "Salami", "Cheese"][Random().nextInt(6)]} / Product ο (Quantity) ➤ [Price] DT",
      ),
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
