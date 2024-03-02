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

  final Map<int, String> _months = {1: "Jan", 2: "Fév", 3: "Mar", 4: "Avr", 5: "Mai", 6: "Jui", 7: "Juil", 8: "Aoû", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Déc"};
  final Map<int, double> _mappedData = <int, double>{for (int index = 1; index <= 12; index += 1) index: 0.0};
  Future<bool> _load() async {
    final List<Map<String, dynamic>> data = (await FirebaseFirestore.instance.collection("sells").where("timestamp", isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month - 1)).get())
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(fontWeight: FontWeight.bold, fontSize: 16);

    Widget text;

    text = Text(_months[value.toInt() - 1]!, style: style);

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(fontWeight: FontWeight.bold, fontSize: 16);

    String text = "";

    if (value % 200 == 0) {
      text = value.toStringAsFixed(0);
    } else {
      return Container();
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 0, child: Text(text, style: style));
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
            return !_mappedData.values.every((double element) => element == 0.0)
                ? Center(child: Text("NOT YET.", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: whiteColor)))
                : StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (double value) => FlLine(color: whiteColor.withOpacity(.3), strokeWidth: 1),
                            getDrawingVerticalLine: (double value) => FlLine(color: whiteColor.withOpacity(.3), strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: bottomTitleWidgets)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: leftTitleWidgets, reservedSize: 42)),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 1,
                          maxX: 12,
                          minY: 0,
                          maxY: 10,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 3),
                                FlSpot(2.6, 2),
                                FlSpot(4.9, 5),
                                FlSpot(6.8, 3.1),
                                FlSpot(8, 4),
                                FlSpot(9.5, 3),
                                FlSpot(11, 4),
                              ],
                              isCurved: true,
                              gradient: LinearGradient(colors: <Color>[whiteColor.withOpacity(.3), purpleColor.withOpacity(.6)]),
                              barWidth: 5,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: <Color>[whiteColor.withOpacity(.2), purpleColor.withOpacity(.2)])),
                            ),
                          ],
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
