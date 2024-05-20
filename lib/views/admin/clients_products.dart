import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/helpers/erroring.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../../utils/shared.dart';

class ClientsProducts extends StatefulWidget {
  const ClientsProducts({super.key, required this.clientID});
  final String clientID;
  @override
  State<ClientsProducts> createState() => _ClientsProductsState();
}

class _ClientsProductsState extends State<ClientsProducts> {
  final Map<String, Map<String, dynamic>> _data = <String, Map<String, dynamic>>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
                const SizedBox(width: 10),
                Text("Products Baught", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection("sells").where("clientID", isEqualTo: widget.clientID).get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => SelledProductModel.fromJson(e.data())).toList().forEach(
                      (SelledProductModel element) {
                        if (!_data.containsKey(element.productReference)) {
                          _data[element.productReference] = <String, dynamic>{
                            "product_quantity": 1,
                            "product_price": element.newPrice,
                            "product_name": element.productName,
                            "product_category": element.productCategory,
                            "product_reference": element.productReference,
                            "product_date": formatDate(element.date, const <String>[dd, " / ", MM, " / ", yyyy, " - ", HH, " : ", n]).toUpperCase(),
                          };
                        } else {
                          _data[element.productReference]!["product_quantity"] += 1;
                        }
                      },
                    );

                    List<Map<String, dynamic>> data = _data.values.toList()..sort((dynamic a, dynamic b) => a["product_date"].milliseconds >= b["product_date"].milliseconds ? 1 : -1);

                    return data.isEmpty
                        ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                        : ListView.separated(
                            itemBuilder: (BuildContext context, int index) => Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                                        child: Text("Date", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(data[index]["product_date"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                                        child: Text("Nom Produit", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(data[index]["product_name"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                                        child: Text("Categorie", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(data[index]["product_category"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                                        child: Text("Quantité", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(data[index]["product_quantity"].toString(), style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                                        child: Text("Total", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text((data[index]["product_price"] * data[index]["product_quantity"]).toStringAsFixed(2), style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                            itemCount: data.length,
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
