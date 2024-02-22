import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/products_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/callbacks.dart';

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
      "state": false,
      "gift_state": false,
    },
  );
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
              const SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("CATEGORIES LIST", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                      const SizedBox(height: 10),
                      AnimatedButton(
                        width: 150,
                        height: 30,
                        text: _categories.map((Map<String, dynamic> e) => e["gift_state"]).toList().every((dynamic element) => element == true) ? "UNSELECT ALL" : 'SELECT ALL',
                        selectedTextColor: whiteColor,
                        animatedOn: AnimatedOn.onHover,
                        animationDuration: 500.ms,
                        isReverse: true,
                        selectedBackgroundColor: darkColor,
                        backgroundColor: purpleColor,
                        transitionType: TransitionType.TOP_TO_BOTTOM,
                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        onPress: () {
                          if (!_categories.map((Map<String, dynamic> e) => e["gift_state"]).toList().every((dynamic element) => element == true)) {
                            for (Map<String, dynamic> item in _categories) {
                              item["gift_state"] = true;
                            }
                          } else {
                            for (Map<String, dynamic> item in _categories) {
                              item["gift_state"] = false;
                            }
                          }
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                      AnimatedButton(
                        width: 80,
                        height: 30,
                        text: 'APPLY',
                        selectedTextColor: whiteColor,
                        animatedOn: AnimatedOn.onHover,
                        animationDuration: 500.ms,
                        isReverse: true,
                        selectedBackgroundColor: darkColor,
                        backgroundColor: purpleColor,
                        transitionType: TransitionType.TOP_TO_BOTTOM,
                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        onPress: () {
                          final TextEditingController giftVault = TextEditingController();
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Gift Vault", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(height: 10),
                                  Container(
                                    color: darkColor,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) _) {
                                        return TextField(
                                          autofocus: true,
                                          onChanged: (String value) {
                                            if (value.trim().length <= 1) {
                                              _(() {});
                                            }
                                          },
                                          controller: giftVault,
                                          onSubmitted: (String value) {
                                            Navigator.pop(context);
                                          },
                                          style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(20),
                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                            border: InputBorder.none,
                                            hintText: "Enter the gift vault",
                                            hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                            suffixIcon: giftVault.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                          ),
                                          cursorColor: purpleColor,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: <Widget>[
                                      const Spacer(),
                                      AnimatedButton(
                                        width: 80,
                                        height: 30,
                                        text: 'CONFIRM',
                                        selectedTextColor: whiteColor,
                                        animatedOn: AnimatedOn.onHover,
                                        animationDuration: 500.ms,
                                        isReverse: true,
                                        selectedBackgroundColor: darkColor,
                                        backgroundColor: greenColor,
                                        transitionType: TransitionType.TOP_TO_BOTTOM,
                                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
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
                                        backgroundColor: greyColor,
                                        transitionType: TransitionType.TOP_TO_BOTTOM,
                                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                        onPress: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).then(
                            (void value) {
                              giftVault.dispose();
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
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
                        onPress: () {
                          for (Map<String, dynamic> item in _categories) {
                            item["gift_state"] = false;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return _deleteState
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AnimatedButton(
                                  width: 150,
                                  height: 30,
                                  text: _categories.map((Map<String, dynamic> e) => e["state"]).toList().every((dynamic element) => element == true) ? "UNSELECT ALL" : 'SELECT ALL',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: greenColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {
                                    if (!_categories.map((Map<String, dynamic> e) => e["state"]).toList().every((dynamic element) => element == true)) {
                                      for (Map<String, dynamic> item in _categories) {
                                        item["state"] = true;
                                      }
                                    } else {
                                      for (Map<String, dynamic> item in _categories) {
                                        item["state"] = false;
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(height: 20),
                                AnimatedButton(
                                  width: 80,
                                  height: 30,
                                  text: 'CANCEL',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: redColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {
                                    for (Map<String, dynamic> item in _categories) {
                                      item["state"] = false;
                                    }
                                    setState(() => _deleteState = false);
                                  },
                                ),
                              ],
                            )
                          : Column(
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
                                  onPress: () {
                                    final TextEditingController categoryName = TextEditingController();
                                    final FocusNode categoryNode = FocusNode();
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) => Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text("Category Name", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                            const SizedBox(height: 10),
                                            Container(
                                              color: darkColor,
                                              child: StatefulBuilder(
                                                builder: (BuildContext context, void Function(void Function()) _) {
                                                  return TextField(
                                                    onChanged: (String value) {
                                                      if (value.trim().length <= 1) {
                                                        _(() {});
                                                      }
                                                    },
                                                    controller: categoryName,
                                                    style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.all(20),
                                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                                      border: InputBorder.none,
                                                      hintText: "Choose a category name",
                                                      hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                                      suffixIcon: categoryName.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                                    ),
                                                    cursorColor: purpleColor,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: <Widget>[
                                                const Spacer(),
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
                                                  onPress: () {
                                                    if (categoryName.text.trim().isNotEmpty) {
                                                      showToast("New category has been added", greenColor);
                                                      _categories.add(
                                                        <String, dynamic>{
                                                          "background_image": "assets/images/bg.jpg",
                                                          "category_name": categoryName.text.trim(),
                                                          "total_products": 0,
                                                          "total_articles": 0,
                                                          "state": false,
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    } else {
                                                      showToast("Please enter a category name", redColor);
                                                    }
                                                  },
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
                                                  backgroundColor: greyColor,
                                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                                  onPress: () => Navigator.pop(context),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).then(
                                      (void value) {
                                        categoryName.dispose();
                                        categoryNode.dispose();
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
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
                                  onPress: () => setState(() => _deleteState = true),
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
                    for (Map<String, dynamic> item in _categories)
                      InkWell(
                        splashColor: transparentColor,
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProductTable()));
                        },
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Column(
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
                              GestureDetector(
                                onTap: () => true,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: scaffoldColor, borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Icon(FontAwesome.gift_solid, size: 15, color: greenColor),
                                          const SizedBox(width: 10),
                                          StatefulBuilder(
                                            builder: (BuildContext context, void Function(void Function()) _) {
                                              return Checkbox(
                                                activeColor: purpleColor,
                                                value: item["gift_state"],
                                                onChanged: (bool? value) => _(() => item["gift_state"] = value),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      if (_deleteState)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Icon(FontAwesome.circle_xmark_solid, size: 15, color: redColor),
                                            const SizedBox(width: 10),
                                            StatefulBuilder(
                                              builder: (BuildContext context, void Function(void Function()) _) {
                                                return Checkbox(
                                                  activeColor: purpleColor,
                                                  value: item["state"],
                                                  onChanged: (bool? value) => _(() => item["state"] = value),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
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
