import 'package:blacklist/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:uuid/v8.dart';

import '../../utils/callbacks.dart';
import '../../utils/shared.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key, required this.categories, required this.setS});
  final List<CategoryModel> categories;
  final void Function(void Function()) setS;
  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _categoryName = TextEditingController();

  @override
  void dispose() {
    _categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
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
                        autofocus: true,
                        controller: _categoryName,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: "Choose a category name",
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                          suffixIcon: _categoryName.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
                      onPress: () async {
                        if (_categoryName.text.trim().isNotEmpty) {
                          final Map<String, dynamic> categoryItem = <String, dynamic>{
                            'categoryID': const UuidV8().generate(),
                            'categoryName': _categoryName.text.trim(),
                            'categoryArticlesCount': 0,
                            'categoryProductsCount': 0,
                            'categoryState': false,
                          };

                          await FirebaseFirestore.instance.collection("categories").add(categoryItem);

                          showToast("New category has been added", greenColor);
                          widget.categories.add(CategoryModel.fromJson(categoryItem));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          widget.setS(() {});
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
        );
      },
    );
  }
}
