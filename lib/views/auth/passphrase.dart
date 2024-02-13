import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Passphrase extends StatefulWidget {
  const Passphrase({super.key});

  @override
  State<Passphrase> createState() => _PassphraseState();
}

class _PassphraseState extends State<Passphrase> {
  final TextEditingController _passphrase = TextEditingController();
  @override
  void dispose() {
    _passphrase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width * .6,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("WELCOME", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
              Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Enter passphrase to continue", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                  const SizedBox(width: 5),
                  Text("*", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(3)),
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return TextField(
                      onChanged: (String value) {
                        if (value.trim().length <= 1) {
                          _(() {});
                        }
                      },
                      controller: _passphrase,
                      style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                        border: InputBorder.none,
                        hintText: 'Passphrase',
                        hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                        suffixIcon: _passphrase.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                      ),
                      cursorColor: purpleColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}