import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/recepies/first_day.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class Recepies extends StatefulWidget {
  const Recepies({super.key});

  @override
  State<Recepies> createState() => _RecepiesState();
}

class _RecepiesState extends State<Recepies> {
  final List<Map<String, dynamic>> _recepies = <Map<String, dynamic>>[
    <String, dynamic>{
      "date": formatDate(DateTime.now().add(1.days), <String>[yyyy, " ", M, " ", dd]).toUpperCase(),
      "screen": FirstDay(date: formatDate(DateTime.now().add(1.days), <String>[yyyy, " ", M, " ", dd]).toUpperCase()),
      "state": true,
    },
    <String, dynamic>{
      "date": formatDate(DateTime.now(), <String>[yyyy, " ", M, " ", dd]).toUpperCase(),
      "screen": FirstDay(date: formatDate(DateTime.now(), <String>[yyyy, " ", M, " ", dd]).toUpperCase()),
      "state": true,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("RECIPIES", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const SizedBox(width: 20),
                const Spacer(),
                const SizedBox(width: 20),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Vendor", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / List Recepies", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(child: PageView.builder(itemBuilder: (BuildContext context, int index) => _recepies[index]["screen"], itemCount: _recepies.length)),
          ],
        ),
      ),
    );
  }
}
