import 'dart:async';
import 'dart:math';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final List<Map<String, dynamic>> _products = List<Map<String, dynamic>>.generate(
    10,
    (int index) => <String, dynamic>{},
  );

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
                    builder: (BuildContext context) => SizedBox(
                      width: MediaQuery.sizeOf(context).width * .7,
                      height: MediaQuery.sizeOf(context).height * .4,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[],
                          ),
                        ],
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
