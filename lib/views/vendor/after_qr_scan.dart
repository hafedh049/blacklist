import 'package:blacklist/models/client_model.dart';
import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/products_history.dart';
import 'package:blacklist/views/vendor/vendor_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class AfterQRScan extends StatefulWidget {
  const AfterQRScan({super.key, required this.storeID, required this.client});
  final String storeID;
  final ClientModel client;
  @override
  State<AfterQRScan> createState() => _AfterQRScanState();
}

class _AfterQRScanState extends State<AfterQRScan> {
  List<SelledProductModel> _products = <SelledProductModel>[];
  final Map<String, int> _categories = <String, int>{};

  Future<Map<String, int>> _loadCategories() async {
    final QuerySnapshot<Map<String, dynamic>> querySnap = await FirebaseFirestore.instance.collection("sells").where("clientID", isEqualTo: widget.client.clientCIN).get();
    _products = querySnap.docs
        .where(
          (QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("storesID").contains(widget.storeID),
        )
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) => SelledProductModel.fromJson(e.data()),
        )
        .toList();
    for (final SelledProductModel product in _products) {
      if (_categories.containsKey(product.productCategory)) {
        _categories[product.productCategory] = _categories[product.productCategory]! + 1;
      } else {
        _categories[product.productCategory] = 0;
      }
    }
    return _categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<Map<String, int>>(
          future: _loadCategories(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.hasError) {
              return Errored(error: snapshot.error.toString());
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                            child: Text(widget.client.clientName, style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                            child: Text(widget.client.clientCIN, style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                            child: Text(formatDate(widget.client.clientBirthdate, const <String>[dd, "/", mm, "/", yyyy]), style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AnimatedButton(
                            width: 100,
                            height: 30,
                            text: 'CART 🛒',
                            selectedTextColor: whiteColor,
                            animatedOn: AnimatedOn.onHover,
                            animationDuration: 500.ms,
                            isReverse: true,
                            selectedBackgroundColor: darkColor,
                            backgroundColor: purpleColor,
                            transitionType: TransitionType.TOP_TO_BOTTOM,
                            textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                            onPress: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VendorTable(clientID: widget.client.clientCIN, storeID: widget.storeID))),
                          ),
                          const SizedBox(height: 10),
                          AnimatedButton(
                            width: 100,
                            height: 30,
                            text: 'GIFT 🎁',
                            selectedTextColor: whiteColor,
                            animatedOn: AnimatedOn.onHover,
                            animationDuration: 500.ms,
                            isReverse: true,
                            selectedBackgroundColor: darkColor,
                            backgroundColor: purpleColor,
                            transitionType: TransitionType.TOP_TO_BOTTOM,
                            textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                            onPress: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VendorTable(clientID: widget.client.clientCIN, storeID: widget.storeID, gift: true))),
                          ),
                          const SizedBox(height: 10),
                          AnimatedButton(
                            width: 100,
                            height: 30,
                            text: 'HISTORY 📚',
                            selectedTextColor: whiteColor,
                            animatedOn: AnimatedOn.onHover,
                            animationDuration: 500.ms,
                            isReverse: true,
                            selectedBackgroundColor: darkColor,
                            backgroundColor: purpleColor,
                            transitionType: TransitionType.TOP_TO_BOTTOM,
                            textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                            onPress: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductsHistory(products: _products))),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _categories.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                          child: Text("NO SELLS YET", style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                        )
                      : SingleChildScrollView(
                          child: CommentTreeWidget<String, MapEntry<String, int>>(
                            "Categories",
                            _categories.entries.toList(),
                            avatarRoot: (BuildContext context, String _) => const PreferredSize(preferredSize: Size.fromRadius(15), child: Icon(FontAwesome.c_solid, size: 25, color: purpleColor)),
                            contentRoot: (BuildContext context, String value) => Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                              child: Text(value, style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                            ),
                            avatarChild: (BuildContext context, MapEntry<String, int> value) => PreferredSize(
                              preferredSize: const Size.fromRadius(15),
                              child: CircleAvatar(
                                backgroundColor: purpleColor,
                                child: Text((_categories.keys.toList().indexOf(value.key)).toString(), style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                              ),
                            ),
                            contentChild: (BuildContext context, MapEntry<String, int> value) => Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(value.key, style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 10),
                                  Text(value.value.toString(), style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: value.value != 1 && value.value % 8 == 1 ? greenColor : redColor),
                                    child: Text(value.value != 1 && value.value % 8 == 1 ? "GIFT" : "NO GIFT", style: GoogleFonts.itim(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                            treeThemeData: const TreeThemeData(lineColor: purpleColor, lineWidth: 2),
                          ),
                        ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
