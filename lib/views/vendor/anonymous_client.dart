import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/vendor_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnonymousClient extends StatefulWidget {
  const AnonymousClient({super.key});

  @override
  State<AnonymousClient> createState() => _AnonymousClientState();
}

class _AnonymousClientState extends State<AnonymousClient> {
  late final List<Map<String, dynamic>> _items;

  @override
  void initState() {
    _items = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "Anonymous",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const VendorTable())),
      },
      <String, dynamic>{
        "title": "Client",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Container())),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
    );
  }
}
