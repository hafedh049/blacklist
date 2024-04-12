import 'package:blacklist/models/category_model.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/add_category.dart';
import 'package:blacklist/views/admin/products_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../../utils/helpers/errored.dart';
import '../../utils/helpers/loading.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.storeID});
  final String storeID;
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final GlobalKey<State> _categoriesKey = GlobalKey<State>();
  List<CategoryModel> _categories = <CategoryModel>[];
  final Map<String, DocumentReference> _categoryRefs = <String, DocumentReference>{};
  bool _deleteState = false;

  Future<bool> _load() async {
    await FirebaseFirestore.instance.collection("categories").where("storeID", isEqualTo: widget.storeID).get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        _categories = value.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) {
            _categoryRefs[e.get("categoryID")] = e.reference;
            return CategoryModel.fromJson(e.data());
          },
        ).toList();
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
                    const SizedBox(width: 10),
                    Text("LISTE DU CATEGORIES", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
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
                                width: 200,
                                height: 30,
                                text: _categories.map((CategoryModel e) => e.categoryState).toList().every((bool element) => element == true) ? "DESELECTIONNER TOUS" : 'SELECTIONNER TOUS',
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
                                  _categoriesKey.currentState!.setState(() {});
                                  _(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                              AnimatedButton(
                                width: 100,
                                height: 30,
                                text: 'CONFIRMER',
                                selectedTextColor: whiteColor,
                                animatedOn: AnimatedOn.onHover,
                                animationDuration: 500.ms,
                                isReverse: true,
                                selectedBackgroundColor: darkColor,
                                backgroundColor: redColor,
                                transitionType: TransitionType.TOP_TO_BOTTOM,
                                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                onPress: () async {
                                  int counter = 0;
                                  for (final CategoryModel item in _categories) {
                                    if (item.categoryState) {
                                      final String cID = item.categoryID;
                                      _categories.remove(item);
                                      _categoriesKey.currentState!.setState(() {});
                                      await _categoryRefs[cID]!.delete();
                                      _categoryRefs.remove(cID);
                                      QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").where("categoryID", isEqualTo: cID).get();
                                      for (final doc in query.docs) {
                                        await doc.reference.delete();
                                        counter += 1;
                                      }
                                      query = await FirebaseFirestore.instance.collection("sells").where("categoryID", isEqualTo: cID).get();
                                      for (final doc in query.docs) {
                                        await doc.reference.delete();
                                      }
                                    }
                                  }
                                  final QuerySnapshot<Map<String, dynamic>> storeQuery = await FirebaseFirestore.instance.collection("stores").where("storeID", isEqualTo: widget.storeID).get();
                                  storeQuery.docs.first.reference.update(<String, dynamic>{"storeTotalProducts": storeQuery.docs.first.get("storeTotalProducts") - counter});

                                  _categoriesKey.currentState!.setState(() => _deleteState = false);
                                  _(() {});
                                  // ignore: use_build_context_synchronously
                                  showToast(context, "Operation completed", greenColor);
                                },
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AddCategory(categories: _categories, setS: setState, storeID: widget.storeID),
                              const SizedBox(height: 20),
                              AnimatedButton(
                                width: 100,
                                height: 30,
                                text: 'SUPPRIMER',
                                selectedTextColor: whiteColor,
                                animatedOn: AnimatedOn.onHover,
                                animationDuration: 500.ms,
                                isReverse: true,
                                selectedBackgroundColor: darkColor,
                                backgroundColor: redColor,
                                transitionType: TransitionType.TOP_TO_BOTTOM,
                                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                onPress: () {
                                  _categoriesKey.currentState!.setState(() => _deleteState = true);
                                  _(() {});
                                },
                              ),
                            ],
                          );
                  },
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: Center(
                child: FutureBuilder<bool>(
                  future: _load(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return StatefulBuilder(
                          key: _categoriesKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return _categories.isEmpty
                                ? LottieBuilder.asset("assets/lotties/empty.json")
                                : SingleChildScrollView(
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
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductTable(storeID: widget.storeID, categoryName: item.categoryName, categoryID: item.categoryID))),
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
                                                          Text("Categorie", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                          const SizedBox(width: 10),
                                                          Text(item.categoryName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        children: <Widget>[
                                                          Text("Totale D'articles", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                          const SizedBox(width: 10),
                                                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                            stream: FirebaseFirestore.instance.collection("products").where("categoryID", isEqualTo: item.categoryID).snapshots(),
                                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                                              if (snapshot.hasData) {
                                                                int categoryArticlesCount = 0;
                                                                final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs
                                                                    .where(
                                                                      (QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("storeID") == widget.storeID,
                                                                    )
                                                                    .toList();
                                                                categoryArticlesCount = data.length;
                                                                return Text(categoryArticlesCount.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor));
                                                              } else {
                                                                return Text("Attend", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor));
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        children: <Widget>[
                                                          Text("Totale produits", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                          const SizedBox(width: 10),
                                                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                            stream: FirebaseFirestore.instance.collection("products").where("categoryID", isEqualTo: item.categoryID).snapshots(),
                                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                                              if (snapshot.hasData) {
                                                                int categoryProductsCount = 0;
                                                                final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs
                                                                    .where(
                                                                      (QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("storeID") == widget.storeID,
                                                                    )
                                                                    .toList();
                                                                for (final QueryDocumentSnapshot<Map<String, dynamic>> element in data) {
                                                                  categoryProductsCount += element.get("productQuantity") as int;
                                                                }
                                                                return Text(categoryProductsCount.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor));
                                                              } else {
                                                                return Text("Attend", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor));
                                                              }
                                                            },
                                                          ),
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
                                                                      Text("Cadeau", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
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
                                                                                hintText: "Seille cadeau",
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
                                                                            width: 100,
                                                                            height: 30,
                                                                            text: 'CONFIRMER',
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
                                                                            width: 100,
                                                                            height: 30,
                                                                            text: 'ANNULER',
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
                                  );
                          });
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    }
                    return Errored(error: snapshot.error.toString());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
