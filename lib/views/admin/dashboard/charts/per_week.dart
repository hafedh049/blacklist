import 'dart:math';

import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../../utils/shared.dart';

class PerWeek extends StatefulWidget {
  const PerWeek({super.key});

  @override
  State<PerWeek> createState() => _PerWeekState();
}

class _PerWeekState extends State<PerWeek> {
  Future<List<double>> _load() async {
  final Query<Map<String, dynamic>>  FirebaseFirestore.instance.collection("sells").where(
          "timestamp",
          isGreaterThanOrEqualTo: DateTime.now().subtract(DateTime.now().weekday.days),
        );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: darkColor),
      child: FutureBuilder<List<double>>(
        future: _load(),
        builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.hasData) {
            SfSparkBarChart(data: List<double>.generate(10, (index) => Random().nextInt(4000) * Random().nextDouble()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return Errored(error: snapshot.toString());
        },
      ),
    );
  }
}
