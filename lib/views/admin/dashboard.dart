import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
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
      "amount": 12.00,
    },
    <String, dynamic>{
      "icon": FontAwesome.circle_dollar_to_slot_solid,
      "title": "SALES PER MONTH",
      "amount": 312.00,
    },
    <String, dynamic>{
      "icon": FontAwesome.google_wallet_brand,
      "title": "SALES PER YEAR",
      "amount": 5312.00,
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
                  color: darkColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(item["icon"], size: 35, color: purpleColor),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(item["title"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(item["amount"], style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
