import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/shared.dart';

class PerYear extends StatefulWidget {
  const PerYear({super.key, required this.storeID});
  final String storeID;
  @override
  State<PerYear> createState() => _PerYearState();
}

class _PerYearState extends State<PerYear> {
  int touchedGroupIndex = -1;

  final Map<int, String> _months = <int, String>{1: "Jan", 2: "Fév", 3: "Mar", 4: "Avr", 5: "Mai", 6: "Jui", 7: "Juil", 8: "Aoû", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Déc"};
  final Map<int, double> _mappedData = <int, double>{for (int index = 1; index <= 12; index += 1) index: 0.0};
  Future<bool> _load() async {
    List<SelledProductModel> data = (await FirebaseFirestore.instance.collection("sells").where("timestamp", isGreaterThanOrEqualTo: DateTime(DateTime.now().year)).get())
        .docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) => SelledProductModel.fromJson(e.data()),
        )
        .toList();
    data = data.where((SelledProductModel element) => element.storeID == widget.storeID).toList();

    for (int index in _mappedData.keys) {
      for (final SelledProductModel entry in data) {
        if (index == entry.timestamp.month) {
          _mappedData[index] = _mappedData[index]! + entry.newPrice - entry.realPrice;
        }
      }
    }
    return true;
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(fontWeight: FontWeight.bold, fontSize: 16);

    String text = "";

    if (value % 200 == 0) {
      text = value.toStringAsFixed(0);
    } else {
      return Container();
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: Text(text, style: style));
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(fontWeight: FontWeight.bold, fontSize: 16);

    Widget text;

    text = value.toInt() % 2 == 0 ? Text(_months[value.toInt()]!, style: style) : Container();

    return SideTitleWidget(axisSide: meta.axisSide, space: 0, child: text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 600,
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
                      return LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (double value) => FlLine(color: whiteColor.withOpacity(.1), strokeWidth: .1),
                            getDrawingVerticalLine: (double value) => FlLine(color: whiteColor.withOpacity(.1), strokeWidth: .1),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: _bottomTitleWidgets)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: _leftTitleWidgets)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: <LineChartBarData>[
                            LineChartBarData(
                              spots: _mappedData.entries.map((MapEntry<int, double> e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                              isCurved: false,
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
