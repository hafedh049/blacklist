import 'package:blacklist/models/product_model.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../../utils/shared.dart';

class StockAlerts extends StatefulWidget {
  const StockAlerts({super.key, required this.storeID});
  final String storeID;
  @override
  State<StockAlerts> createState() => _StockAlertsState();
}

class _StockAlertsState extends State<StockAlerts> {
  List<ProductModel> _alerts = <ProductModel>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
                const SizedBox(width: 10),
                Text("Stock Alerts", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection("products").where("storeID", isEqualTo: widget.storeID).get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    _alerts = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).where((ProductModel element) => element.productQuantity <= element.stockAlert).toList();
                    return _alerts.isEmpty
                        ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                        : ListView.separated(
                            itemBuilder: (BuildContext context, int index) => Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
                              width: 250,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                runSpacing: 20,
                                spacing: 20,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                            child: Text("NOM PRODUIT", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(_alerts[index].productName.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                            child: Text("NOM CATEGORIE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(_alerts[index].productCategory.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                            child: Text("STOCK ALERT", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(_alerts[index].stockAlert.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                            child: Text("QUANTITE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(_alerts[index].productQuantity.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                            itemCount: _alerts.length,
                          );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  } else {
                    return Errored(error: snapshot.error.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
