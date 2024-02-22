import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../utils/shared.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({super.key});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  final List<Map<String, dynamic>> _clients = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{
      "name": "Client ${index + 1}",
      "cin": List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join(),
      "phone_number": "+216 ${Random().nextInt(90) + 10} ${Random().nextInt(900) + 100} ${Random().nextInt(900) + 100}",
      "birth_date": formatDate(DateTime(Random().nextInt(20) + 1960, Random().nextInt(12) + 1, Random().nextInt(31) + 1), const <String>[]),
      "total_products": Random().nextInt(4000).toString(),
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Clients", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Admin", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / Clients List", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => Row(
                  children: <Widget>[
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: PrettyQrView.data(
                        data: _clients[index].toString(),
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(color: purpleColor),
                          image: PrettyQrDecorationImage(image: AssetImage('assets/images/flutter.png'), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (final MapEntry<String, dynamic> entry in _clients[index].entries)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                child: Text(entry.key.replaceAll("_", " ").toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                              ),
                              const SizedBox(width: 10),
                              Text(entry.value.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemCount: _clients.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
