import 'dart:math';

import 'package:blacklist/utils/shared.dart';
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
        (int index) => "${index + 1} ο ${["Vape", "Meat", "Fish", "Steak", "Salami", "Cheese"][Random().nextInt(6)]} / ${["Wrata", "Djej", "Présédent", "Bagri", "Dinde"][Random().nextInt(5)]} ο (${Random().nextInt(50)}) ➤ [${Random().nextInt(1000) * Random().nextDouble()}] DT",
      ),
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) => Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[],
                ),
              ),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
              itemCount: _recepies.length,
            ),
          ),
        ],
      ),
    );
  }
}
