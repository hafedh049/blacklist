import 'dart:async';
import 'dart:math';

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
                      return PrettyQrView.data(
                        data: _data,
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(color: purpleColor),
                          image: PrettyQrDecorationImage(image: AssetImage('assets/images/flutter.png'), fit: BoxFit.cover),
                        ),
                      ).animate().fade(duration: 1.seconds);
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
    );
  }
}