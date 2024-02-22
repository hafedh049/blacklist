import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';

class ClientsProducts extends StatefulWidget {
  const ClientsProducts({super.key});

  @override
  State<ClientsProducts> createState() => _ClientsProductsState();
}

class _ClientsProductsState extends State<ClientsProducts> {
  final List<Map<String, dynamic>> _productsPerClient = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{
      "product_name": "Product ${index + 1}",
      "quantity": Random().nextInt(1000).toString(),
      "total_price": (Random().nextInt(1000) * Random().nextDouble()).toStringAsFixed(2),
      "category": "Category ${index + 1}",
      "date": formatDate(DateTime.now(), const <String>[dd, '/', M, '/', yyyy]).toString(),
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Products Baught", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Admin", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / Baught Products List", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text("Date", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_productsPerClient[index]["date"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text("Product Name", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_productsPerClient[index]["product_name"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text("Category", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_productsPerClient[index]["category"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text("Quantity", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_productsPerClient[index]["quantity"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                            child: Text("Total Price", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_productsPerClient[index]["total_price"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemCount: _productsPerClient.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
