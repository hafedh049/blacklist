import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _mappedData = <int, double>{for (int index = 1; index <= _months[DateTime.now().month]!; index += 1) index: 0.0};
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

  Widget _leftTitles(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 14);
    String text = "";
    if (value % 50 == 0) {
      text = value.toStringAsFixed(0);
    } else {
      return Container();
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 0, child: Text(text, style: style));
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    showToast(value.toString(), redColor);
    final Widget text = Text(_months.keys.elementAt(value.toInt() - 1).toString(), style: GoogleFonts.itim(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 14));

    return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: text);
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
            return _mappedData.values.every((double element) => element == 0.0)
                ? Center(child: Text("NOT YET.", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: whiteColor)))
                : StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return BarChart(
                        BarChartData(
                          maxY: 100,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: _bottomTitles, reservedSize: 42)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1, getTitlesWidget: _leftTitles)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: _mappedData.entries
                              .map(
                                (MapEntry<int, double> e) => BarChartGroupData(
                                  x: e.key,
                                  barRods: <BarChartRodData>[BarChartRodData(toY: e.value)],
                                ),
                              )
                              .toList(),
                          gridData: const FlGridData(show: false),
                        ),
                      );
                    },
                  );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return Errored(error: snapshot.toString());
        },
      ),
    );
  }
}
