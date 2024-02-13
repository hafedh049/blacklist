import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  final List<_PieData> pieData = List<_PieData>.generate(30, (int index) => _PieData((index + 1).toString(), Random().nextInt(4000) * Random().nextDouble()));
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: darkColor),
      child: SfCircularChart(
        title: ChartTitle(text: 'Sales by sales person'),
        legend: Legend(isVisible: true),
        series: <PieSeries<_PieData, String>>[
          PieSeries<_PieData, String>(explode: true, explodeIndex: 0, dataSource: pieData, xValueMapper: (_PieData data, _) => data.xData, yValueMapper: (_PieData data, _) => data.yData, dataLabelMapper: (_PieData data, _) => data.text, dataLabelSettings: DataLabelSettings(isVisible: true)),
        ],
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  String? text;
}
