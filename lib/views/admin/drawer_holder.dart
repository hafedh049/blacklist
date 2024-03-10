import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';
import 'category_list.dart';
import 'clients_list.dart';
import 'dashboard/dashboard.dart';
import 'stock_alerts.dart';

class DrawerHolder extends StatefulWidget {
  const DrawerHolder({super.key, required this.storeID});
  final String storeID;
  @override
  State<DrawerHolder> createState() => _DrawerHolderState();
}

class _DrawerHolderState extends State<DrawerHolder> {
  late final List<Map<String, dynamic>> _screens = <Map<String, dynamic>>[
    <String, dynamic>{"screen": Dashboard(storeID: widget.storeID), "title": "Dashboard"},
    <String, dynamic>{"screen": CategoryList(storeID: widget.storeID), "title": "List Categories"},
    <String, dynamic>{"screen": StockAlerts(storeID: widget.storeID), "title": "Alerts Stock"},
    <String, dynamic>{"screen": ClientsList(storeID: widget.storeID), "title": "Clients"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final Map<String, dynamic> item in _screens)
              InkWell(
                hoverColor: transparentColor,
                splashColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => item["screen"])),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                  child: Text(item["title"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
