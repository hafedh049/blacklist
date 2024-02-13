import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoresList extends StatefulWidget {
  const StoresList({super.key});

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Stores", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Stores", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / Add(Choose) store", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[],
                    ),
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
