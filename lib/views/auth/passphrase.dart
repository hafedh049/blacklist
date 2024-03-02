// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:convert';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/stores.dart';
import 'package:blacklist/views/vendor/cart_recipe.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _adminButtonState = false;
  bool _vendorButtonState = false;

  bool _adminEmailState = false;
  bool _adminPassphraseState = false;

  bool _vendorEmailState = false;
  bool _vendorPassphraseState = false;

  final GlobalKey<State> _adminKey = GlobalKey<State>();
  final GlobalKey<State> _vendorKey = GlobalKey<State>();

  final TextEditingController _adminEmailController = TextEditingController();
  final TextEditingController _adminPassphraseController = TextEditingController();

  final TextEditingController _vendorPassphraseController = TextEditingController();
  final TextEditingController _vendorEmailController = TextEditingController();

  final FocusNode _adminEmailFocus = FocusNode();
  final FocusNode _adminPassphraseFocus = FocusNode();

  final FocusNode _vendorEmailFocus = FocusNode();
  final FocusNode _vendorPassphraseFocus = FocusNode();

  late final List<Map<String, dynamic>> _items;

  Future<void> _signIn(GlobalKey<State> key) async {
    if (key == _adminKey) {
      if (_adminPassphraseController.text.trim().isEmpty) {
        showToast("Please enter admin the passphrase", redColor);
      } else {
        key.currentState!.setState(() => _adminButtonState = true);
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _adminEmailController.text, password: _adminPassphraseController.text);
        key.currentState!.setState(() => _adminButtonState = false);
        if (sha512.convert(utf8.encode(_adminPassphraseController.text)) == sha512.convert(utf8.encode(_adminPassphrase))) {
          showToast("Welcome ADMIN", greenColor);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const StoresList()));
        } else {
          showToast("Wrong Credentials", redColor);
          _adminPassphraseFocus.requestFocus();
        }
      }
    } else {
      if (_vendorPassphraseController.text.trim().isEmpty) {
        showToast("Please enter the vendor passphrase", redColor);
      } else {
        key.currentState!.setState(() => _vendorButtonState = true);
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _vendorEmailController.text, password: _vendorPassphraseController.text);
        key.currentState!.setState(() => _vendorButtonState = false);
        if (sha512.convert(utf8.encode(_vendorPassphraseController.text)) == sha512.convert(utf8.encode(_vendorPassphrase))) {
          showToast("Welcome VENDOR", greenColor);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const CartRecepie()));
        } else {
          showToast("Wrong Credentials", redColor);
          _vendorPassphraseFocus.requestFocus();
        }
      }
    }
  }

  @override
  void initState() {
    _items = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "ADMIN",
        "button_state": _adminButtonState,
        "passphrase_state": _adminPassphraseState,
        "email_state": _adminEmailState,
        "card_key": _adminKey,
        "email_controller": _adminEmailController,
        "email_focus_node": _adminEmailFocus,
        "passphrase_controller": _adminPassphraseController,
        "passphrase_focus_node": _adminPassphraseFocus,
      },
      <String, dynamic>{
        "title": "VENDOR",
        "button_state": _vendorButtonState,
        "email_state": _vendorEmailState,
        "passphrase_state": _vendorPassphraseState,
        "card_key": _vendorKey,
        "email_controller": _vendorEmailController,
        "email_focus_node": _vendorEmailFocus,
        "passphrase_controller": _vendorPassphraseController,
        "passphrase_focus_node": _vendorPassphraseFocus,
      },
    ];
    super.initState();
  }

  @override
  void dispose() {
    _adminPassphraseFocus.dispose();
    _vendorPassphraseFocus.dispose();
    _adminPassphraseController.dispose();
    _vendorPassphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (Map<String, dynamic> item in _items) ...<Widget>[
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
                        Text(item["title"], style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                        Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(child: Text("E-mail", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor))),
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
                                obscureText: !item["passphrase_state"],
                                focusNode: item["focus_node"],
                                onSubmitted: (String value) => _signIn(item["key"]),
                                onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                controller: item["controller"],
                                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                  border: InputBorder.none,
                                  hintText: 'Passphrase',
                                  hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                  prefixIcon: item["controller"].text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                  suffixIcon: IconButton(onPressed: () => _(() => item["passphrase_state"] = !item["passphrase_state"]), icon: Icon(item["passphrase_state"] ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                                ),
                                cursorColor: purpleColor,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                obscureText: !item["passphrase_state"],
                                focusNode: item["focus_node"],
                                onSubmitted: (String value) => _signIn(item["key"]),
                                onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                controller: item["controller"],
                                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                  border: InputBorder.none,
                                  hintText: 'Passphrase',
                                  hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                  prefixIcon: item["controller"].text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                  suffixIcon: IconButton(onPressed: () => _(() => item["passphrase_state"] = !item["passphrase_state"]), icon: Icon(item["passphrase_state"] ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                                ),
                                cursorColor: purpleColor,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        StatefulBuilder(
                          key: item["key"],
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IgnorePointer(
                                  ignoring: item["button_state"],
                                  child: AnimatedButton(
                                    width: 150,
                                    height: 40,
                                    text: item["button_state"] ? "WAIT..." : 'CONTINUE',
                                    selectedTextColor: darkColor,
                                    animatedOn: AnimatedOn.onHover,
                                    animationDuration: 500.ms,
                                    isReverse: true,
                                    selectedBackgroundColor: redColor,
                                    backgroundColor: purpleColor,
                                    transitionType: TransitionType.TOP_TO_BOTTOM,
                                    textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                    onPress: () => _signIn(item["key"]),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                AnimatedOpacity(opacity: item["button_state"] ? 1 : 0, duration: 300.ms, child: const Icon(FontAwesome.bookmark_solid, color: purpleColor, size: 35)),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (_items.last != item) const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
