import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<Map<String, dynamic>> _categories = List<Map<String, dynamic>>.generate(
    20,
    (int index) => <String, dynamic>{
      "background_image": "assets/images/bg.png",
      "category": "Category ${index + 1}",
      "total_products": Random().nextInt(4000),
      "total_articles": Random().nextInt(20),
    },
  );
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
                  Text("CATEGORIES LIST", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: "CATEGORIES", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                        TextSpan(text: " / Category List", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                      ],
                    ),
                  ),
                ],
              ),
              Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 20,
                  spacing: 20,
                  children: <Widget>[
                    for (final Map<String, dynamic> item in _categories)
                      InkWell(
                        splashColor: transparentColor,
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CategoryList()));
                        },
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Category", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["store_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("Vendor", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["vendor_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("Vendor", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["vendor_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
