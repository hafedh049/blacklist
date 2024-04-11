import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class MonthCounter extends StatefulWidget {
  const MonthCounter({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<MonthCounter> createState() => _MonthCounterState();
}

class _MonthCounterState extends State<MonthCounter> {
  late final List<MapEntry<String, dynamic>> _months;

  int _compareDates(String a, String b) {
    final List<int> dateA = a.split('/').map(int.parse).toList();
    final List<int> dateB = b.split('/').map(int.parse).toList();

    // Comparing years in descending order
    if (dateA[1] > dateB[1]) {
      return -1;
    } else if (dateA[1] < dateB[1]) {
      return 1;
    }

    // Comparing months in descending order
    if (dateA[0] > dateB[0]) {
      return -1;
    } else if (dateA[0] < dateB[0]) {
      return 1;
    }

    // If both dates are equal
    return 0;
  }

  @override
  void initState() {
    final String month = formatDate(DateTime.now(), const <String>[mm, "/", yyyy]);
    _months = (widget.data..putIfAbsent(month, () => 0)).entries.toList()..sort((MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) => _compareDates(a.key, b.key));

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
              child: _months.isEmpty
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
                                  child: Text("MOIS", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                                ),
                                const SizedBox(width: 10),
                                Text(_months[index].key, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
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
                                Text(_months[index].value == 0 ? "PAS DE VENTE DANS CE MOIS" : _months[index].value.toStringAsFixed(2), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
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
