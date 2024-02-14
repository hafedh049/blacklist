import 'dart:convert';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/stores.dart';
import 'package:blacklist/views/admin/vendors_management.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Passphrase extends StatefulWidget {
  const Passphrase({super.key});

  @override
  State<Passphrase> createState() => _PassphraseState();
}

class _PassphraseState extends State<Passphrase> {
  final String _adminPassphrase = "admin";
  final String _vendorPassphrase = "vendor";

  bool _buttonState = false;
  bool _passphraseState = false;

  final GlobalKey<State> _button1Key = GlobalKey<State>();
  final GlobalKey<State> _button2Key = GlobalKey<State>();

  final TextEditingController _passphrase = TextEditingController();
  final FocusNode _passphraseFocus = FocusNode();

  Future<void> _signIn(GlobalKey<State> key) async {
    if (_passphrase.text.trim().isEmpty) {
      showToast("Please enter the passphrase", redColor);
    } else {
      key.currentState!.setState(() => _buttonState = true);
      await Future.delayed(200.ms);
      key.currentState!.setState(() => _buttonState = false);
      if (sha512.convert(utf8.encode(_passphrase.text)) == sha512.convert(utf8.encode(_adminPassphrase))) {
        showToast("Welcome ADMIN", greenColor);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const StoresList()));
      } else if (sha512.convert(utf8.encode(_passphrase.text)) == sha512.convert(utf8.encode(_vendorPassphrase))) {
        showToast("Welcome VENDOR", greenColor);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const VendorsManagement()));
      } else {
        showToast("Wrong Credentials", redColor);
        _passphraseFocus.requestFocus();
      }
    }
  }

  @override
  void dispose() {
    _passphrase.dispose();
    _passphraseFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedLoadingBorder(
              borderWidth: 4,
              borderColor: purpleColor,
              child: Container(
                color: darkColor,
                width: MediaQuery.sizeOf(context).width * .7,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("ADMIN", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                    Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(child: Text("Enter passphrase to continue", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor))),
                        const SizedBox(width: 5),
                        Text("*", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: scaffoldColor, borderRadius: BorderRadius.circular(3)),
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return TextField(
                            obscureText: !_passphraseState,
                            focusNode: _passphraseFocus,
                            onSubmitted: (value) => _signIn(_button1Key),
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
                              prefixIcon: _passphrase.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                              suffixIcon: IconButton(onPressed: () => _(() => _passphraseState = !_passphraseState), icon: Icon(_passphraseState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                            ),
                            cursorColor: purpleColor,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      key: _button1Key,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IgnorePointer(
                              ignoring: _buttonState,
                              child: AnimatedButton(
                                width: 150,
                                height: 40,
                                text: _buttonState ? "WAIT..." : 'CONTINUE',
                                selectedTextColor: darkColor,
                                animatedOn: AnimatedOn.onHover,
                                animationDuration: 500.ms,
                                isReverse: true,
                                selectedBackgroundColor: redColor,
                                backgroundColor: purpleColor,
                                transitionType: TransitionType.TOP_TO_BOTTOM,
                                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                onPress: () => _signIn(_button1Key),
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedOpacity(opacity: _buttonState ? 1 : 0, duration: 300.ms, child: const Icon(FontAwesome.bookmark_solid, color: purpleColor, size: 35)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedLoadingBorder(
              borderWidth: 4,
              borderColor: purpleColor,
              child: Container(
                color: darkColor,
                width: MediaQuery.sizeOf(context).width * .7,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("VENDOR", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                    Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(child: Text("Enter passphrase to continue", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor))),
                        const SizedBox(width: 5),
                        Text("*", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: scaffoldColor, borderRadius: BorderRadius.circular(3)),
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return TextField(
                            obscureText: !_passphraseState,
                            focusNode: _passphraseFocus,
                            onSubmitted: (value) => _signIn(_button2Key),
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
                              prefixIcon: _passphrase.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                              suffixIcon: IconButton(onPressed: () => _(() => _passphraseState = !_passphraseState), icon: Icon(_passphraseState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                            ),
                            cursorColor: purpleColor,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      key: _button2Key,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IgnorePointer(
                              ignoring: _buttonState,
                              child: AnimatedButton(
                                width: 150,
                                height: 40,
                                text: _buttonState ? "WAIT..." : 'CONTINUE',
                                selectedTextColor: darkColor,
                                animatedOn: AnimatedOn.onHover,
                                animationDuration: 500.ms,
                                isReverse: true,
                                selectedBackgroundColor: redColor,
                                backgroundColor: purpleColor,
                                transitionType: TransitionType.TOP_TO_BOTTOM,
                                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                onPress: () => _signIn(_button2Key),
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedOpacity(opacity: _buttonState ? 1 : 0, duration: 300.ms, child: const Icon(FontAwesome.bookmark_solid, color: purpleColor, size: 35)),
                          ],
                        );
                      },
                    ),
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
