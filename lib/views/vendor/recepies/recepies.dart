import 'dart:math';

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
      "total": (Random().nextInt(4000) * Random().nextDouble()).toStringAsFixed(2),
    },
    <String, dynamic>{
      "date": formatDate(DateTime.now(), <String>[yyyy, " ", M, " ", dd]).toUpperCase(),
      "screen": FirstDay(date: formatDate(DateTime.now(), <String>[yyyy, " ", M, " ", dd]).toUpperCase()),
      "total": (Random().nextInt(4000) * Random().nextDouble()).toStringAsFixed(2),
    },
  ];

  final PageController _daysController = PageController();

  final GlobalKey<State> _totalKey = GlobalKey<State>();

  int _selectedPage = 0;

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      hoverColor: transparentColor,
                      splashColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {
                        if (_selectedPage != 0) {
                          _(() => _selectedPage = 0);
                          _totalKey.currentState!.setState(() {});
                          _daysController.jumpToPage(0);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: _selectedPage == 0 ? purpleColor : darkColor, borderRadius: BorderRadius.circular(5)),
                        child: Text(_recepies[0]["date"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                      ),
                    ),
                    InkWell(
                      hoverColor: transparentColor,
                      splashColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {
                        if (_selectedPage != 1) {
                          _(() => _selectedPage = 1);
                          _totalKey.currentState!.setState(() {});
                          _daysController.jumpToPage(1);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: _selectedPage == 1 ? purpleColor : darkColor, borderRadius: BorderRadius.circular(5)),
                        child: Text(_recepies[1]["date"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(child: PageView.builder(controller: _daysController, itemBuilder: (BuildContext context, int index) => _recepies[index]["screen"], itemCount: _recepies.length)),
            Row(
              children: <Widget>[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                  child: StatefulBuilder(
                    key: _totalKey,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return Text("RECETTE [ ${_recepies[_selectedPage]["total"]} ]", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
