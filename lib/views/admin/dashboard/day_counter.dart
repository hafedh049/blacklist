import 'package:flutter/material.dart';

class DayCounter extends StatefulWidget {
  const DayCounter({super.key});

  @override
  State<DayCounter> createState() => _DayCounterState();
}

class _DayCounterState extends State<DayCounter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[],
      ),
    );
  }
}
