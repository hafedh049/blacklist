import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
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
      "ammount": 12.00,
    },
    <String, dynamic>{
      "icon": FontAwesome.circle_dollar_to_slot_solid,
      "title": "SALES PER MONTH",
      "ammount": 312.00,
    },
    <String, dynamic>{
      "icon": FontAwesome.google_wallet_brand,
      "title": "SALES PER YEAR",
      "ammount": 5312.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        children: <Widget>[],
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
