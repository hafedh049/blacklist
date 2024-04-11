import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class YearCounter extends StatefulWidget {
  const YearCounter({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<YearCounter> createState() => _YearCounterState();
}

class _YearCounterState extends State<YearCounter> {
  late final List<MapEntry<String, dynamic>> _years;

  int _compareDates(String a, String b) {
    final int yearA = int.parse(a);
    final int yearB = int.parse(b);

    // Comparing years in descending order
    if (yearA > yearB) {
      return -1;
    } else if (yearA < yearB) {
      return 1;
    }
    // If both years are equal
    return 0;
  }

  @override
  void initState() {
    final String year = formatDate(DateTime.now(), const <String>[yyyy]);
    _years = (widget.data..putIfAbsent(year, () => 0)).entries.toList()..sort((MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) => _compareDates(a.key, b.key));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
            const SizedBox(height: 10),
            Expanded(
              child: _years.isEmpty
                  ? Center(child: Text("PAS DE VENTE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)))
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                  child: Text("ANNEE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                                ),
                                const SizedBox(width: 10),
                                Text(_years[index].key, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
                                  child: Text("TOTALE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                                ),
                                const SizedBox(width: 10),
                                Text(_years[index].value == 0 ? "PAS DE VENTE POUR CETTE ANNEE" : _years[index].value.toStringAsFixed(2), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                              ],
                            ),
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
