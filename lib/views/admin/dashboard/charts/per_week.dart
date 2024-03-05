import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/selled_product.dart';
import '../../../../utils/shared.dart';

class PerWeek extends StatefulWidget {
  const PerWeek({super.key, required this.storeID});
  final String storeID;
  @override
  State<PerWeek> createState() => _PerWeekState();
}

class _PerWeekState extends State<PerWeek> {
  final Map<int, double> _mappedData = <int, double>{for (int index = 1; index <= 7; index += 1) index: 0.0};

  int touchedGroupIndex = -1;

  Future<bool> _load() async {
    List<SelledProductModel> data = (await FirebaseFirestore.instance.collection("sells").where("timestamp", isGreaterThanOrEqualTo: DateTime.now().subtract(DateTime.now().weekday.days)).get())
        .docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) => SelledProductModel.fromJson(e.data()),
        )
        .toList();
    data = data.where((SelledProductModel element) => element.storeID == widget.storeID).toList();
    for (int index in _mappedData.keys) {
      for (final SelledProductModel entry in data) {
        if (index == entry.timestamp.weekday) {
          _mappedData[index] = _mappedData[index]! + entry.newPrice - entry.realPrice;
        }
      }
    }
    return true;
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final TextStyle style = GoogleFonts.itim(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 14);
    String text = "";
    if (value % 10 == 0) {
      text = value.toStringAsFixed(0);
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
                ? Center(child: Text("NOT YET.", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: whiteColor)))
                : StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return BarChart(
                        BarChartData(
                          maxY: 30,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: _bottomTitles, reservedSize: 42)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1, getTitlesWidget: leftTitles)),
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
