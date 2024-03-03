import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MonthCounter extends StatefulWidget {
  const MonthCounter({super.key});

  @override
  State<MonthCounter> createState() => _MonthCounterState();
}

class _MonthCounterState extends State<MonthCounter> {
  List<SelledProductModel> _data = <SelledProductModel>[];
  Future<bool> _load() async {
    await FirebaseFirestore.instance.collection("sells").where("timestamp", isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month)).get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        _data = value.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => SelledProductModel.fromJson(e.data())).toList();
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              formatDate(DateTime.now(), const <String>[mm, '/', yyyy]),
              style: GoogleFonts.itim(fontSize: 25, fontWeight: FontWeight.w500, color: purpleColor),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<bool>(
                future: _load(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return _data.isEmpty
                      ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                      : ListView.separated(
                          itemBuilder: (BuildContext context, int index) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(_data[index].productName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                                const SizedBox(height: 20),
                                Text(_data[index].productCategory, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                                const SizedBox(height: 20),
                                Text(_data[index].newPrice.toStringAsFixed(2), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                                const SizedBox(height: 20),
                                Text("1", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                              ],
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                          itemCount: _data.length,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
