import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/dashboard/charts/per_week.dart';
import 'package:blacklist/views/admin/dashboard/counters.dart';
import 'package:flutter/material.dart';

import 'charts/per_month.dart';
import 'charts/per_year.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
