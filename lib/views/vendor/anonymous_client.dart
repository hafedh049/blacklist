import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/client_qr.dart';
import 'package:blacklist/views/vendor/vendor_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class AnonymousClient extends StatefulWidget {
  const AnonymousClient({super.key, required this.storeID});
  final String storeID;
  @override
  State<AnonymousClient> createState() => _AnonymousClientState();
}

class _AnonymousClientState extends State<AnonymousClient> {
  late final List<Map<String, dynamic>> _items;

  @override
  void initState() {
    _items = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "Anonyme",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VendorTable(storeID: widget.storeID))),
      },
      <String, dynamic>{
        "title": "Client",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Client(storeID: widget.storeID))),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (final Map<String, dynamic> item in _items) ...<Widget>[
                      InkWell(
                        onTap: item["callback"],
                        hoverColor: transparentColor,
                        splashColor: transparentColor,
                        highlightColor: transparentColor,
                        child: AnimatedLoadingBorder(
                          borderWidth: 4,
                          borderColor: purpleColor,
                          child: Container(
                            width: 300,
                            height: 150,
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(color: darkColor),
                            alignment: Alignment.center,
                            child: Text(item["title"], style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
