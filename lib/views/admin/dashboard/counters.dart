import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/shared.dart';

class Counters extends StatefulWidget {
  const Counters({super.key});

  @override
  State<Counters> createState() => _CountersState();
}

class _CountersState extends State<Counters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (Map<String, dynamic> item in _gains)
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 24),
            color: darkColor,
            child: InkWell(
              focusColor: transparentColor,
              splashColor: transparentColor,
              highlightColor: transparentColor,
              hoverColor: transparentColor,
              onTap: () {
                setState(
                  () {
                    item["amount"] = Random().nextInt(4000) * Random().nextDouble();
                  },
                );
              },
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Icon(item["icon"], size: 60, color: greyColor.withOpacity(.05)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(item["icon"], size: 35, color: purpleColor),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(item["title"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: greyColor)),
                          const SizedBox(height: 5),
                          AnimatedFlipCounter(value: item["amount"], wholeDigits: 1, fractionDigits: 2, suffix: " DT", textStyle: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor), duration: 1.seconds, decimalSeparator: ",", thousandSeparator: " "),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
