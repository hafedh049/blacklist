import 'package:flutter/material.dart';

class Recepie extends StatefulWidget {
  const Recepie({super.key});

  @override
  State<Recepie> createState() => _RecepieState();
}

class _RecepieState extends State<Recepie> {
  final List<Map<String, dynamic>> _recepies = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{},
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
