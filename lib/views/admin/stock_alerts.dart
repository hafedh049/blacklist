import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';

class StockAlerts extends StatefulWidget {
  const StockAlerts({super.key});

  @override
  State<StockAlerts> createState() => _StockAlertsState();
}

class _StockAlertsState extends State<StockAlerts> {
  final List<Map<String, dynamic>> _alerts = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{
      "product_name": "Product ${index + 1}",
      "category_name": "Category ${index + 1}",
      "stock_alert": (Random().nextInt(10) + 10).toString(),
      "product_quantity": (Random().nextInt(10) + 10).toString(),
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Stock Alerts", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Admin", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / Alerts List", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
                  width: 250,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    runSpacing: 20,
                    spacing: 20,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (final MapEntry<String, dynamic> entry in _alerts[index].entries) ...<Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                  child: Text(entry.key.replaceAll("_", " ").toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                ),
                                const SizedBox(width: 10),
                                Text(entry.value.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemCount: _alerts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
