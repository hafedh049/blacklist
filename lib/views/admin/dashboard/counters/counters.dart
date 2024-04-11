import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:blacklist/views/admin/dashboard/counters/day_counter.dart';
import 'package:blacklist/views/admin/dashboard/counters/month_counter.dart';
import 'package:blacklist/views/admin/dashboard/counters/year_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../utils/shared.dart';

class Counters extends StatefulWidget {
  const Counters({super.key, required this.storeID});
  final String storeID;
  @override
  State<Counters> createState() => _CountersState();
}

class _CountersState extends State<Counters> {
  final Map<String, Map<String, dynamic>> _history = <String, Map<String, dynamic>>{
    "days": <String, dynamic>{},
    "months": <String, dynamic>{},
    "years": <String, dynamic>{},
  };
  final Map<String, Map<String, dynamic>> _sells = <String, Map<String, dynamic>>{
    "day": <String, dynamic>{
      "icon": FontAwesome.wallet_solid,
      "title": "VENTE PAR JOUR",
      "amount": 0.00,
    },
    "month": <String, dynamic>{
      "icon": FontAwesome.circle_dollar_to_slot_solid,
      "title": "VENTE PAR MOIS",
      "amount": 0.00,
    },
    "year": <String, dynamic>{
      "icon": FontAwesome.google_wallet_brand,
      "title": "VENTE PAR ANNEE",
      "amount": 0.00,
    },
  };

  int _totalselledProducts = 0;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("sells").where("storeID", isEqualTo: widget.storeID).get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        final List<Map<String, dynamic>> data = value.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) {
            return <String, dynamic>{
              "timestamp": e.get("timestamp"),
              "price": e.get("newPrice") - e.get("realPrice"),
            };
          },
        ).toList();

        _totalselledProducts = data.length;

        for (final Map<String, dynamic> item in data) {
          final String day = formatDate(item["timestamp"].toDate(), const <String>[dd, "/", mm, "/", yyyy]);
          final String month = formatDate(item["timestamp"].toDate(), const <String>[mm, "/", yyyy]);
          final String year = formatDate(item["timestamp"].toDate(), const <String>[yyyy]);

          if (_history["days"]!.containsKey(day)) {
            _history["days"]![day] += item["price"];
          } else {
            _history["days"]![day] = item["price"];
          }

          if (_history["months"]!.containsKey(month)) {
            _history["months"]![month] += item["price"];
          } else {
            _history["months"]![month] = item["price"];
          }

          if (_history["years"]!.containsKey(year)) {
            _history["years"]![year] += item["price"];
          } else {
            _history["years"]![year] = item["price"];
          }
          final DateTime date = item["timestamp"].toDate();
          final DateTime now = DateTime.now();
          if (date.day == now.day && date.month == now.month && date.year == now.year) {
            _sells["day"]!["amount"] = _sells["day"]!["amount"]! + item["price"];
          }
          if (date.month == now.month && date.year == now.year) {
            _sells["month"]!["amount"] = _sells["month"]!["amount"]! + item["price"];
          }
          if (date.year == now.year) {
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
                      ? DayCounter(data: _history["days"]!)
                      : item["title"].contains("VENTE PAR MOIS")
                          ? MonthCounter(data: _history["months"]!)
                          : YearCounter(data: _history["years"]!),
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
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(bottom: 24),
          color: darkColor,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Icon(FontAwesome.money_check_dollar_solid, size: 60, color: greyColor.withOpacity(.05)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(FontAwesome.money_check_dollar_solid, size: 35, color: purpleColor),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Nombre totale du produits vendus", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: greyColor)),
                      const SizedBox(height: 5),
                      AnimatedFlipCounter(
                        value: _totalselledProducts,
                        textStyle: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor),
                        duration: 1.seconds,
                        thousandSeparator: " ",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
