import 'dart:async';
import 'dart:math';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../utils/shared.dart';
import 'after_qr_scan.dart';

class QRView extends StatefulWidget {
  const QRView({super.key, required this.storeID});
  final String storeID;
  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
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
    return InkWell(
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      splashColor: transparentColor,
      onTap: () {
        if (kIsWeb) {
          showToast("THIS FEATURE IS AVAILABLE ONLY ON ANDROID", redColor);
        } else {
          //SCAN THE QR
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AfterQRScan(storeID: widget.storeID)));
        }
      },
      child: AnimatedLoadingBorder(
        borderWidth: 4,
        borderColor: purpleColor,
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: darkColor),
          alignment: Alignment.center,
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
    );
  }
}
