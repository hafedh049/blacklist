import 'package:blacklist/models/category_model.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/add_category.dart';
import 'package:blacklist/views/admin/products_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<CategoryModel> _categories = <CategoryModel>[];
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
                  Text("CATEGORIES LIST", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
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
                                  text: _categories.map((CategoryModel e) => e.categoryState).toList().every((bool element) => element == true) ? "UNSELECT ALL" : 'SELECT ALL',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: greenColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () {
                                    if (!_categories.map((CategoryModel e) => e.categoryState).toList().every((bool element) => element == true)) {
                                      for (CategoryModel item in _categories) {
                                        item.categoryState = true;
                                      }
                                    } else {
                                      for (CategoryModel item in _categories) {
                                        item.categoryState = false;
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
                                    for (CategoryModel item in _categories) {
                                      item.categoryState = false;
                                    }
                                    setState(() => _deleteState = false);
                                  },
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AddCategory(categories: _categories, setS: setState),
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
                    for (CategoryModel item in _categories)
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
                                      Text(item.categoryName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Text("Total Articles", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                      const SizedBox(width: 10),
                                      Text(item.categoryArticlesCount.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Text("Total Products", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                      const SizedBox(width: 10),
                                      Text(item.categoryProductsCount.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
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
                                      IconButton(
                                        onPressed: () {
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
                                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                                          );
                                        },
                                        icon: const Icon(FontAwesome.gift_solid, size: 15, color: greenColor),
                                      ),
                                      if (_deleteState) ...<Widget>[
                                        const SizedBox(width: 10),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Icon(FontAwesome.circle_xmark_solid, size: 15, color: redColor),
                                            const SizedBox(width: 10),
                                            StatefulBuilder(
                                              builder: (BuildContext context, void Function(void Function()) _) {
                                                return Checkbox(
                                                  activeColor: purpleColor,
                                                  value: item.categoryState,
                                                  onChanged: (bool? value) => _(() => item.categoryState = value!),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
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
