import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/recepies/first_day.dart';
import 'package:blacklist/views/vendor/recepies/second_day.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Recepies extends StatefulWidget {
  const Recepies({super.key});

  @override
  State<Recepies> createState() => _RecepiesState();
}

class _RecepiesState extends State<Recepies> {
  final List<Map<String, dynamic>> _recepies = <Map<String, dynamic>>[
    <String, dynamic>{
      "date": formatDate(DateTime.now().add(1.days), <String>[dd, " ", M, " ", yyyy]).toUpperCase(),
      "screen": const FirstDay(),
    },
    <String, dynamic>{
      "date": formatDate(DateTime.now(), <String>[dd, " ", M, " ", yyyy]).toUpperCase(),
      "screen": const SecondDay(),
    },
  ];

  final PageController _daysController = PageController();

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
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
                const SizedBox(width: 10),
                Text("RECETTES", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
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
                          _daysController.animateToPage(0, duration: 200.ms, curve: Curves.linear);
                        }
                      },
                      child: AnimatedContainer(
                        duration: 300.ms,
                        padding: const EdgeInsets.all(8),
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
                          _daysController.animateToPage(1, duration: 200.ms, curve: Curves.linear);
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
          ],
        ),
      ),
    );
  }
}
