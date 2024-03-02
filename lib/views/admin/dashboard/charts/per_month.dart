import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../../utils/shared.dart';

class PerMonth extends StatefulWidget {
  const PerMonth({super.key});

  @override
  State<PerMonth> createState() => _PerMonthState();
}

class _PerMonthState extends State<PerMonth> {
  final Map<int, int> _months = {
    1: 31, // Janvier
    2: 28, // Février
    3: 31, // Mars
    4: 30, // Avril
    5: 31, // Mai
    6: 30, // Juin
    7: 31, // Juillet
    8: 31, // Août
    9: 30, // Septembre
    10: 31, // Octobre
    11: 30, // Novembre
    12: 31, // Décembre
  };
  late final Map<int, double> _mappedData;

  @override
  void initState() {
    super.initState();
    _mappedData = <int, double>{for (int index = 1; index <= _months[DateTime.now().month]!; index += 1) index: 10};
  }

  Future<bool> _load() async {
    final List<Map<String, dynamic>> data = (await FirebaseFirestore.instance
            .collection("sells")
            .where(
              "timestamp",
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month),
            )
            .get())
        .docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) => <String, dynamic>{
            "quantity": e.get("quantity"),
            "price": e.get("price"),
            "timestamp": e.get("timestamp"),
          },
        )
        .toList();
    for (int index in _mappedData.keys) {
      for (final Map<String, dynamic> entry in data) {
        if (index == (entry["timestamp"].toDate() as DateTime).day) {
          _mappedData[index] = _mappedData[index]! + entry["quantity"] * entry["price"];
        }
      }
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
      child: FutureBuilder<bool>(
        future: _load(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return SfSparkBarChart(data: _mappedData.values.toList());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return Errored(error: snapshot.toString());
        },
      ),
    );
  }
}
