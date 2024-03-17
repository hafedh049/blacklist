import 'dart:async';
import 'dart:math';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/models/client_model.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/views/vendor/create_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

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
      onTap: () async {
        if (kIsWeb) {
          showToast(context, "Cette fonction est valable que sur l'android", redColor);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => QRCodeDartScanView(
                scanInvertedQRCode: true,
                typeScan: TypeScan.takePicture,
                takePictureButtonBuilder: (BuildContext context, QRCodeDartScanController controller, bool isLoading) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: darkColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          TextButton(onPressed: controller.takePictureAndDecode, child: Text(isLoading ? "Attend" : 'Capturer')),
                          const Spacer(),
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Quitter')),
                        ],
                      ),
                    ),
                  );
                },
                resolutionPreset: QRCodeDartScanResolutionPreset.medium,
                formats: const <BarcodeFormat>[BarcodeFormat.qrCode],
                onCapture: (Result result) async {
                  await FirebaseFirestore.instance.collection('clients').where("clientQrCode", isEqualTo: result.text).limit(1).get().then(
                    (QuerySnapshot<Map<String, dynamic>> value) {
                      if (value.docs.isNotEmpty) {
                        showToast(context, "USER EXISTANT", greenColor);
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AfterQRScan(storeID: widget.storeID, client: ClientModel.fromJson(value.docs.first.data()))));
                      } else {
                        showToast(context, "Aucun utilisateur avec cette QR", redColor);
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateUser(storeID: widget.storeID, qrCode: result.text)));
                      }
                    },
                  );
                },
              ),
            ),
          ); //AfterQRScan(storeID: widget.storeID)
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
              Text("Scanner QR", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
            ],
          ),
        ),
      ),
    );
  }
}
