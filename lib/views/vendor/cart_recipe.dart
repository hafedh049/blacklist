import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

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
        "selected": false,
      },
      <String, dynamic>{
        "title": "Recepie",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Container())),
        "selected": false,
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (final Map<String, dynamic> item in _items)
                    AnimatedLoadingBorder(
                      borderWidth: 4,
                      borderColor: purpleColor,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: item["selected"] ? purpleColor : darkColor,
                          border: Border.all(color: item["selected"] ? purpleColor : darkColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(item["title"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
