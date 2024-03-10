import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsHistory extends StatefulWidget {
  const ProductsHistory({super.key, required this.products});
  final List<SelledProductModel> products;
  @override
  State<ProductsHistory> createState() => _ProductsHistoryState();
}

class _ProductsHistoryState extends State<ProductsHistory> {
  final List<Map<String, dynamic>> _products = <Map<String, dynamic>>[];

  Future<bool> _load() async {
    for (final SelledProductModel product in widget.products) {
      if (!_products.map((Map<String, dynamic> e) => e["product"]).contains(product.productName)) {
        _products.add(
          <String, dynamic>{
            "product": product.productName,
            "total_buys": widget.products.where((SelledProductModel element) => element.productName == product.productName).length,
            "sum": widget.products.where((SelledProductModel element) => element.productName == product.productName).length * product.newPrice,
            "date": product.date,
          },
        );
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<bool>(
          future: _load(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
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
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Loading());
            } else {
              return Center(child: Errored(error: snapshot.error.toString()));
            }
          },
        ),
      ),
    );
  }
}
