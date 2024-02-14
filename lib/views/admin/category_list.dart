import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
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
      "background_image": "assets/images/bg.jpg",
      "category_name": "Category ${index + 1}",
      "total_products": Random().nextInt(4000),
      "total_articles": Random().nextInt(20),
    },
  );
  final List<bool> _checksList = List<bool>.generate(20, (int index) => false);
  bool _deleteState = false;
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
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return _deleteState
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AnimatedButton(
                                  width: 80,
                                  height: 30,
                                  text: 'SELECT ALL',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: purpleColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {},
                                ),
                                const SizedBox(width: 20),
                                AnimatedButton(
                                  width: 80,
                                  height: 30,
                                  text: 'CANCEL',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: purpleColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {},
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AnimatedButton(
                                  width: 80,
                                  height: 30,
                                  text: 'ADD',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: greenColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {},
                                ),
                                const SizedBox(width: 20),
                                AnimatedButton(
                                  width: 80,
                                  height: 30,
                                  text: 'DELETE',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: redColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {},
                                ),
                              ],
                            );
                    },
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
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProductsTable()));
                        },
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: darkColor,
                            image: DecorationImage(image: AssetImage(item["background_image"]), fit: BoxFit.cover),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Category", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["category_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("Total Articles", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["total_articles"].toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("Total Products", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["total_products"].toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
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
