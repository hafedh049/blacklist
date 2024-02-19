import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/dashboard/charts/bar_chart.dart';
import 'package:blacklist/views/admin/dashboard/charts/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> _gains = <Map<String, dynamic>>[
    <String, dynamic>{
      "icon": FontAwesome.wallet_solid,
      "title": "SALES PER DAY",
      "amount": 0.0,
    },
    <String, dynamic>{
      "icon": FontAwesome.circle_dollar_to_slot_solid,
      "title": "SALES PER MONTH",
      "amount": 0.0,
    },
    <String, dynamic>{
      "icon": FontAwesome.google_wallet_brand,
      "title": "SALES PER YEAR",
      "amount": 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              for (Map<String, dynamic> item in _gains)
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 24),
                  color: darkColor,
                  child: InkWell(
                    focusColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    hoverColor: transparentColor,
                    onTap: () {
                      setState(() {
                        item["amount"] = Random().nextInt(4000) * Random().nextDouble();
                      });
                    },
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
                                AnimatedFlipCounter(value: item["amount"], wholeDigits: 1, fractionDigits: 2, suffix: " DT", textStyle: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor), duration: 1.seconds, decimalSeparator: ",", thousandSeparator: " "),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  PieChart(),
                  BarChart(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
