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
  final List<_PieData> pieData = List<_PieData>.generate(5, (int index) => _PieData(const <String>["Heap", "Queue", "Stack", "Linked List", "Tree"][Random().nextInt(5)], Random().nextInt(4000) * Random().nextDouble()));
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: darkColor),
      child: SfCircularChart(
        title: const ChartTitle(text: 'TOP SALES BY MONTH'),
        legend: const Legend(isVisible: true),
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
