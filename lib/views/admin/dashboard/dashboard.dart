import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/dashboard/charts/per_week.dart';
import 'package:blacklist/views/admin/dashboard/counters/counters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'charts/per_month.dart';
import 'charts/per_year.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.storeID});
  final String storeID;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final List<Map<String, dynamic>> _buttons;
  @override
  void initState() {
    _buttons = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "Par Semaine",
        "target": PerWeek(storeID: widget.storeID),
      },
      <String, dynamic>{
        "title": "Par Mois",
        "target": PerMonth(storeID: widget.storeID),
      },
      <String, dynamic>{
        "title": "Par Année",
        "target": PerYear(storeID: widget.storeID),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
            const SizedBox(height: 30),
            Counters(storeID: widget.storeID),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  for (final Map<String, dynamic> button in _buttons)
                    AnimatedButton(
                      width: 150,
                      height: 40,
                      text: button["title"],
                      selectedTextColor: darkColor,
                      animatedOn: AnimatedOn.onHover,
                      animationDuration: 500.ms,
                      isReverse: true,
                      selectedBackgroundColor: greenColor,
                      backgroundColor: purpleColor,
                      transitionType: TransitionType.TOP_TO_BOTTOM,
                      textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                      onPress: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => button["target"])),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
