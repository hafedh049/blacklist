import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsHistory extends StatefulWidget {
  const ProductsHistory({super.key});

  @override
  State<ProductsHistory> createState() => _ProductsHistoryState();
}

class _ProductsHistoryState extends State<ProductsHistory> {
  final List<Map<String, dynamic>> _products = <Map<String, dynamic>>[
    for (int index = 0; index < 10; index += 1)
      <String, dynamic>{
        "product": "Product ${index + 1}",
        "total_buys": Random().nextInt(100),
        "sum": (Random().nextInt(1000) * Random().nextDouble()).toStringAsFixed(2),
        "date": DateTime(2024, Random().nextInt(12) + 1, Random().nextInt(31) + 1),
      },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  for (final Map<String, dynamic> product in _products)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text(formatDate(product["date"], const <String>[d, "-", M, "-", yyyy]).toUpperCase(), style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 10),
                          Text(product["product"], style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          Text(product["total_buys"].toString(), style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text("${product["sum"]} DT", style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
