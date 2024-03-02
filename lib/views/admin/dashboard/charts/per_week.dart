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
  final Map<int, double> _mappedData = <int, double>{for (int index = 1; index <= 7; index += 1) index: 0.0};
  Future<bool> _load() async {
    final QuerySnapshot<Map<String, dynamic>> data = (await FirebaseFirestore.instance
            .collection("sells")
            .where(
              "timestamp",
              isGreaterThanOrEqualTo: DateTime.now().subtract(DateTime.now().weekday.days),
            )
            .get())
        .docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) => null);
    for (int index in _mappedData.keys) {
      /*for( data.){

      }*/
    }
    return true;
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
