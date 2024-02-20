import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartRecepie extends StatefulWidget {
  const CartRecepie({super.key});

  @override
  State<CartRecepie> createState() => _CartRecepieState();
}

class _CartRecepieState extends State<CartRecepie> {
  late final List<Map<String, dynamic>> _items;

  @override
  void initState() {
    _items = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "Cart",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Container())),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (final Map<String, dynamic> item in _items)
                  AnimatedContainer(
                    duration: 300.ms,
                    padding: const EdgeInsets.all(24),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
