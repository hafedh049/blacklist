import 'package:blacklist/models/client_model.dart';
import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FirstDay extends StatefulWidget {
  const FirstDay({super.key, required this.storeID});
  final String storeID;
  @override
  State<FirstDay> createState() => _FirstDayState();
}

class _FirstDayState extends State<FirstDay> {
  Future<List<Map<String, dynamic>>> _load() async {
    List<Map<String, dynamic>> firstDayData = <Map<String, dynamic>>[];
    final QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("sells")
        .where(
          "timestamp",
          isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        )
        .orderBy("timestamp", descending: true)
        .get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> item in data.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get("storeID") == widget.storeID)) {
      final SelledProductModel product = SelledProductModel.fromJson(item.data());
      if (product.clientID == "ANONYMOUS") {
        firstDayData.add(
          <String, dynamic>{
            "clientName": "ANONYMOUS",
            "heure": formatDate(product.timestamp, const <String>[HH, ":", nn, " ", am]),
            "clientCIN": "ANONYMOUS",
            "productName": product.productName,
            "productCategory": product.productCategory,
            "productPrice": product.newPrice,
          },
        );
      } else {
        final QuerySnapshot<Map<String, dynamic>> clientQuery = await FirebaseFirestore.instance.collection("clients").where("clientCIN", isEqualTo: product.clientID).limit(1).get();
        final ClientModel client = ClientModel.fromJson(clientQuery.docs.first.data());
        firstDayData.add(
          <String, dynamic>{
            "clientName": client.clientName,
            "clientCIN": client.clientCIN,
            "heure": formatDate(product.timestamp, const <String>[HH, ":", nn, " ", am]),
            "productName": product.productName,
            "productCategory": product.productCategory,
            "productPrice": product.newPrice,
          },
        );
      }
    }

    return firstDayData;
  }

  double _sum() {
    double sum = 0;
    for (final Map<String, dynamic> item in _recepies) {
      sum += item["productPrice"];
    }
    return sum;
  }

  List<Map<String, dynamic>> _recepies = <Map<String, dynamic>>[];

  final GlobalKey<State> _totalKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _load(),
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  _recepies = snapshot.data!;
                  Future.delayed(100.ms, () => _totalKey.currentState!.setState(() {}));
                  return _recepies.isEmpty
                      ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                      : ListView.separated(
                          itemBuilder: (BuildContext context, int index) => Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: _recepies[index]["clientName"] == "ANONYMOUS" ? redColor : greenColor, borderRadius: BorderRadius.circular(5)),
                                      child: Text("Client", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_recepies[index]["clientName"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                      child: Text("HEURE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_recepies[index]["heure"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                      child: Text("CIN", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_recepies[index]["clientCIN"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                      child: Text("CATEGORIE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_recepies[index]["productCategory"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                      child: Text("NOM PRODUIT", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_recepies[index]["productName"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PRIX", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(_recepies[index]["productPrice"].toStringAsFixed(2), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                          itemCount: _recepies.length,
                        );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                } else {
                  return Errored(error: snapshot.error.toString());
                }
              },
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: redColor, borderRadius: BorderRadius.circular(5)),
              child: StatefulBuilder(
                key: _totalKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Text("RECETTE : ${_sum().toStringAsFixed(2)}", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
