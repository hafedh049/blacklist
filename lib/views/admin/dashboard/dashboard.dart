import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/dashboard/charts/per_week.dart';
import 'package:blacklist/views/admin/dashboard/counters/counters.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import 'charts/per_month.dart';
import 'charts/per_year.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.storeID});
  final String storeID;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
              const SizedBox(height: 30),
              const Counters(),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  PerWeek(storeID: widget.storeID),
                  PerMonth(storeID: widget.storeID),
                  PerYear(storeID: widget.storeID),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
