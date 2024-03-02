import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DayCounter extends StatefulWidget {
  const DayCounter({super.key});

  @override
  State<DayCounter> createState() => _DayCounterState();
}

class _DayCounterState extends State<DayCounter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              formatDate(
                DateTime.now(),
              ),
              style: GoogleFonts.itim(fontSize: 25, fontWeight: FontWeight.w500, color: purpleColor)),
        ],
      ),
    );
  }
}
