import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/vendor_table.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class AfterQRScan extends StatefulWidget {
  const AfterQRScan({super.key});

  @override
  State<AfterQRScan> createState() => _AfterQRScanState();
}

class _AfterQRScanState extends State<AfterQRScan> {
  final List<Map<String, dynamic>> _categories = <Map<String, dynamic>>[
    for (int index = 0; index < 10; index += 1)
      <String, dynamic>{
        "category": "Category ${index + 1}",
        "total_buys": Random().nextInt(1000),
      },
  ];

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
              Row(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                        child: Text("Foulen Fouleni", style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                        child: Text("11643672", style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                        child: Text("23/60/2001", style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedButton(
                    width: 80,
                    height: 30,
                    text: 'CART',
                    selectedTextColor: whiteColor,
                    animatedOn: AnimatedOn.onHover,
                    animationDuration: 500.ms,
                    isReverse: true,
                    selectedBackgroundColor: darkColor,
                    backgroundColor: greenColor,
                    transitionType: TransitionType.TOP_TO_BOTTOM,
                    textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                    onPress: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const VendorTable())),
                  ),
                  const SizedBox(width: 20),
                  AnimatedButton(
                    width: 80,
                    height: 30,
                    text: 'GIFT',
                    selectedTextColor: whiteColor,
                    animatedOn: AnimatedOn.onHover,
                    animationDuration: 500.ms,
                    isReverse: true,
                    selectedBackgroundColor: darkColor,
                    backgroundColor: greenColor,
                    transitionType: TransitionType.TOP_TO_BOTTOM,
                    textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                    onPress: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const VendorTable())),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CommentTreeWidget<String, Map<String, dynamic>>(
                "Categories",
                _categories,
                avatarRoot: (BuildContext context, String _) => const PreferredSize(preferredSize: Size.fromRadius(15), child: Icon(FontAwesome.c_solid, size: 25, color: purpleColor)),
                contentRoot: (BuildContext context, String value) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                  child: Text(value, style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                ),
                avatarChild: (BuildContext context, Map<String, dynamic> value) => PreferredSize(
                  preferredSize: const Size.fromRadius(15),
                  child: CircleAvatar(
                    backgroundColor: purpleColor,
                    child: Text((_categories.indexOf(value) + 1).toString(), style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                  ),
                ),
                contentChild: (BuildContext context, Map<String, dynamic> value) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(value["category"], style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      Text(value["total_buys"].toString(), style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: value["total_buys"] != 1 && value["total_buys"] % 8 == 1 ? greenColor : redColor),
                        child: Text(value["total_buys"] != 1 && value["total_buys"] % 8 == 1 ? "GIFT" : "NO GIFT", style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                treeThemeData: const TreeThemeData(lineColor: purpleColor, lineWidth: 2),
              ),
              const SizedBox(height: 20),
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
