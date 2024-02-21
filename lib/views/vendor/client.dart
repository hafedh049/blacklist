import 'dart:async';
import 'dart:math';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Client extends StatefulWidget {
  const Client({super.key});

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
  late final Timer _timer;
  final GlobalKey<State> _qrKey = GlobalKey<State>();
  String _data = List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join();

  final Map<String, List<Map<String, dynamic>>> _products = <String, List<Map<String, dynamic>>>{
    for (int index = 0; index < 10; index += 1)
      "Category ${index + 1}": <Map<String, dynamic>>[
        for (int indexJ = 0; indexJ < 5; indexJ += 1)
          <String, dynamic>{
            "product": "Product ${indexJ + 1}",
            "total_buys": Random().nextInt(4000),
          },
      ],
  };

  @override
  void initState() {
    _timer = Timer.periodic(3.seconds, (Timer timer) => _qrKey.currentState!.setState(() => _data = List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join()));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                splashColor: transparentColor,
                onTap: () {
                  //SCAN THE QR
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.sizeOf(context).width * .7,
                      height: MediaQuery.sizeOf(context).height * .4,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: greenColor, borderRadius: BorderRadius.circular(5)),
                              child: Text("Foulen Fouleni", style: GoogleFonts.itim(fontSize: 16, color: greyColor, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 20),
                            for (final MapEntry<String, List<Map<String, dynamic>>> tuple in _products.entries)
                              CommentTreeWidget<String, Map<String, dynamic>>(
                                tuple.key,
                                tuple.value,
                                avatarRoot: (BuildContext context, String _) => const PreferredSize(preferredSize: Size.fromRadius(15), child: Icon(FontAwesome.product_hunt_brand, size: 25, color: purpleColor)),
                                contentRoot: (BuildContext context, String value) => Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                                  child: Text(value, style: GoogleFonts.itim(fontSize: 14, color: greyColor, fontWeight: FontWeight.w500)),
                                ),
                                contentChild: (BuildContext context, Map<String, dynamic> value) => Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(value, style: GoogleFonts.itim(fontSize: 14, color: greyColor, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                treeThemeData: const TreeThemeData(lineColor: purpleColor, lineWidth: 2),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: AnimatedLoadingBorder(
                  borderWidth: 4,
                  borderColor: purpleColor,
                  child: Container(
                    width: 300,
                    height: 150,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(color: darkColor),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: StatefulBuilder(
                              key: _qrKey,
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return Animate(
                                  key: ValueKey<String>(_data),
                                  effects: <Effect>[FadeEffect(duration: 1.seconds)],
                                  child: PrettyQrView.data(
                                    data: _data,
                                    decoration: const PrettyQrDecoration(
                                      shape: PrettyQrSmoothSymbol(color: purpleColor),
                                      image: PrettyQrDecorationImage(image: AssetImage('assets/images/flutter.png'), fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text("Scan QR", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
