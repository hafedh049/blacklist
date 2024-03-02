import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/shared.dart';

class PerYear extends StatefulWidget {
  const PerYear({super.key});

  @override
  State<PerYear> createState() => _PerYearState();
}

class _PerYearState extends State<PerYear> {
  int touchedGroupIndex = -1;

  final Map<int, String> _months = {
    1: "Jan",
    2: "Fév",
    3: "Mar",
    4: "Avr",
    5: "Mai",
    6: "Jui",
    7: "Juil",
    8: "Aoû",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Déc",
  };
  final Map<int, double> _mappedData = <int, double>{for (int index = 1; index <= 12; index += 1) index: 0.0};
  Future<bool> _load() async {
    final List<Map<String, dynamic>> data = (await FirebaseFirestore.instance
            .collection("sells")
            .where(
              "timestamp",
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month - 1),
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
        if (index == (entry["timestamp"].toDate() as DateTime).month) {
          _mappedData[index] = _mappedData[index]! + entry["quantity"] * entry["price"];
        }
      }
    }
    return true;
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 14);
    String text = "";
    if (value >= 1000) {
      text = '1K';
    } else {
      return Container();
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 0, child: Text(text, style: style));
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final List<String> titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(titles[value.toInt() - 1], style: GoogleFonts.itim(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 14));

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
                ? Center(
                    child: Text(
                      "NOT YET.",
                      style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: whiteColor),
                    ),
                  )
                : StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(tooltipBgColor: whiteColor, getTooltipItem: (BarChartGroupData a, int b, BarChartRodData c, int d) => null),
                            touchCallback: (FlTouchEvent event, response) {
                              if (response == null || response.spot == null) {
                                _(() {
                                  touchedGroupIndex = -1;
                                });
                                return;
                              }

                              touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                              _(() {
                                if (!event.isInterestedForInteractions) {
                                  touchedGroupIndex = -1;
                                  return;
                                }
                                // showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  /*     var sum = 0.0;
                                for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                                  sum += rod.toY;
                                }
                                final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
                                  barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                    return rod.copyWith(toY: avg, color: widget.avgColor);
                                  }).toList(),
                                );*/
                                }
                              });
                            },
                          ),
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
