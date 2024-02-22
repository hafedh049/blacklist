import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondDay extends StatefulWidget {
  const SecondDay({super.key, required this.date});
  final String date;
  @override
  State<SecondDay> createState() => _SecondDayState();
}

class _SecondDayState extends State<SecondDay> {
  final List<Map<String, dynamic>> _recepies = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{
      "client": <String>["User ${index + 1}", "Anonymous"][Random().nextInt(2)],
      "cin": List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join(),
      "products": List<List<String>>.generate(
        Random().nextInt(20),
        (int index) => [
          "${index + 1}",
          const <String>["Vape", "Meat", "Fish", "Steak", "Salami", "Cheese"][Random().nextInt(6)],
          const <String>["Wrata", "Djej", "Présédent", "Bagri", "Dinde"][Random().nextInt(5)],
          "${Random().nextInt(50)}",
          "${(Random().nextInt(1000) * Random().nextDouble()).toStringAsFixed(2)}]",
        ],
      ),
    },
  );
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("RECIPIES", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                    const SizedBox(height: 10),
                    InkWell(
                      hoverColor: transparentColor,
                      splashColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          // "${formatDate(DateTime.now(), <String>[yyyy, " ", M, " ", dd]).toUpperCase()} - ${formatDate(DateTime.now().add(1.days), <String>[yyyy, " ", M, " ", dd])}",
                          widget.date,
                          style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
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
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: _recepies[index]["client"] == "Anonymous" ? redColor : greenColor, borderRadius: BorderRadius.circular(5)),
                            child: Text("Client", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_recepies[index]["client"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: greenColor, borderRadius: BorderRadius.circular(5)),
                            child: Text("CIN", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const SizedBox(width: 10),
                          Text(_recepies[index]["cin"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (final List<String> product in _recepies[index]["products"])
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: product[0], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                              TextSpan(text: " • ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: product[1], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                              TextSpan(text: " / ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: product[2], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                              TextSpan(text: " • ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: " ( ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: product[3], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                              TextSpan(text: " ) ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: " ➤ ", style: GoogleFonts.itim(fontSize: 15, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: " [ ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: product[4], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                              TextSpan(text: " ] ", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                              TextSpan(text: " DT", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemCount: _recepies.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
