import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/views/admin/dashboard/counters/day_counter.dart';
import 'package:blacklist/views/admin/dashboard/counters/month_counter.dart';
import 'package:blacklist/views/admin/dashboard/counters/year_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../utils/shared.dart';

class Counters extends StatefulWidget {
  const Counters({super.key});

  @override
  State<Counters> createState() => _CountersState();
}

class _CountersState extends State<Counters> {
  final Map<String, Map<String, dynamic>> _sells = <String, Map<String, dynamic>>{
    "day": <String, dynamic>{
      "icon": FontAwesome.wallet_solid,
      "title": "VENTE PAR JOUR",
      "amount": 0.00,
      "sells": <SelledProductModel>[],
    },
    "month": <String, dynamic>{
      "icon": FontAwesome.circle_dollar_to_slot_solid,
      "title": "VENTE PAR MOIS",
      "amount": 0.00,
      "sells": <SelledProductModel>[],
    },
    "year": <String, dynamic>{
      "icon": FontAwesome.google_wallet_brand,
      "title": "VENTE PAR ANNEE",
      "amount": 0.00,
      "sells": <SelledProductModel>[],
    },
  };

  @override
  void initState() {
    FirebaseFirestore.instance.collection("sells").get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        final List<Map<String, dynamic>> data = value.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) {
            if ((e.get("timestamp").toDate() as DateTime).day == DateTime.now().day) {
              _sells["day"]!["sells"].add(SelledProductModel.fromJson(e.data()));
            }
            if ((e.get("timestamp").toDate() as DateTime).month == DateTime.now().month) {
              _sells["month"]!["sells"].add(SelledProductModel.fromJson(e.data()));
            }
            if ((e.get("timestamp").toDate() as DateTime).year == DateTime.now().year) {
              _sells["year"]!["sells"].add(SelledProductModel.fromJson(e.data()));
            }
            return <String, dynamic>{
              "timestamp": e.get("timestamp"),
              "price": e.get("newPrice") - e.get("realPrice"),
            };
          },
        ).toList();
        for (final Map<String, dynamic> item in data) {
          if ((item["timestamp"].toDate() as DateTime).day == DateTime.now().day) {
            _sells["day"]!["amount"] = _sells["day"]!["amount"]! + item["price"];
          }
          if ((item["timestamp"].toDate() as DateTime).month == DateTime.now().month) {
            _sells["month"]!["amount"] = _sells["month"]!["amount"]! + item["price"];
          }
          if ((item["timestamp"].toDate() as DateTime).year == DateTime.now().year) {
            _sells["year"]!["amount"] = _sells["year"]!["amount"]! + item["price"];
          }
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final Map<String, dynamic> item in _sells.values)
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 24),
            color: darkColor,
            child: InkWell(
              focusColor: transparentColor,
              splashColor: transparentColor,
              highlightColor: transparentColor,
              hoverColor: transparentColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => item["title"].contains("VENTE PAR JOUR")
                      ? DayCounter(data: item["sells"])
                      : item["title"].contains("VENTE PAR MOIS")
                          ? MonthCounter(data: item["sells"])
                          : YearCounter(data: item["sells"]),
                ),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Icon(item["icon"], size: 60, color: greyColor.withOpacity(.05)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(item["icon"], size: 35, color: purpleColor),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(item["title"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: greyColor)),
                          const SizedBox(height: 5),
                          AnimatedFlipCounter(
                            value: item["amount"],
                            wholeDigits: 1,
                            fractionDigits: 2,
                            suffix: " DT",
                            textStyle: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor),
                            duration: 1.seconds,
                            decimalSeparator: ",",
                            thousandSeparator: " ",
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
