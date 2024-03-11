import 'package:blacklist/models/selled_product.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

class DayCounter extends StatefulWidget {
  const DayCounter({super.key, required this.data});
  final List<SelledProductModel> data;
  @override
  State<DayCounter> createState() => _DayCounterState();
}

class _DayCounterState extends State<DayCounter> {
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
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
                const SizedBox(width: 10),
                Text(
                  '${formatDate(DateTime.now(), const <String>[dd, '/', mm, '/', yyyy, " (00:00 AM)"])} - ${formatDate(DateTime.now(), const <String>[dd, '/', mm, '/', yyyy, " (23:59 PM)"])}',
                  style: GoogleFonts.itim(fontSize: 25, fontWeight: FontWeight.w500, color: purpleColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: widget.data.isEmpty
                  ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.data[index].productName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                            const SizedBox(height: 20),
                            Text(widget.data[index].productCategory, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                            const SizedBox(height: 20),
                            Text(widget.data[index].newPrice.toStringAsFixed(2), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                            const SizedBox(height: 20),
                            Text("1", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                          ],
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                      itemCount: widget.data.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
