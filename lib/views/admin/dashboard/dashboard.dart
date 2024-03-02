import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/dashboard/charts/per_week.dart';
import 'package:blacklist/views/admin/dashboard/counters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'charts/per_month.dart';
import 'charts/per_year.dart';

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
    return const Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Counters(),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  PerWeek(),
                  PerMonth(),
                  PerYear(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
