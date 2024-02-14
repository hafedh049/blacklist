// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/stores.dart';
import 'package:blacklist/views/vendor/products_management.dart';
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

  bool _adminButtonState = false;
  bool _vendorButtonState = false;

  bool _adminPassphraseState = false;
  bool _vendorPassphraseState = false;

  final GlobalKey<State> _adminKey = GlobalKey<State>();
  final GlobalKey<State> _vendorKey = GlobalKey<State>();

  final TextEditingController _adminPassphraseController = TextEditingController();
  final TextEditingController _vendorPassphraseController = TextEditingController();

  final FocusNode _adminPassphraseFocus = FocusNode();
  final FocusNode _vendorPassphraseFocus = FocusNode();

  late final List<Map<String,dynamic>> _items;

  Future<void> _signIn(GlobalKey<State> key) async {
    if (key == _adminKey) {
      if (_adminPassphraseController.text.trim().isEmpty) {
        showToast("Please enter admin the passphrase", redColor);
      } else {
        key.currentState!.setState(() => _adminButtonState = true);
        await Future.delayed(200.ms);
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
        await Future.delayed(200.ms);
        key.currentState!.setState(() => _vendorButtonState = false);
        if (sha512.convert(utf8.encode(_vendorPassphraseController.text)) == sha512.convert(utf8.encode(_vendorPassphrase))) {
          showToast("Welcome VENDOR", greenColor);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const StoresList()));
        } else {
          showToast("Wrong Credentials", redColor);
          _vendorPassphraseFocus.requestFocus();
        }
      }
    }
  }

@override
  void initState() {
    _items = <Map<String,dynamic>>[<String,dynamic>{"title":"ADMIN", "passphrase":_adminPassphrase,"button_state":_adminButtonState,"passphrase_state":_adminPassphraseState,"key":_adminKey,"controller":_adminPassphraseController,"focus_node":_adminPassphraseFocus},<String,dynamic>{"passphrase":_adminPassphrase,"button_state":_adminButtonState,"passphrase_state":_adminPassphraseState,"key":_adminKey,"controller":_adminPassphraseController,"focus_node":_adminPassphraseFocus},];
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            for(Map<String,dynamic> item in _items)...<Widget>[AnimatedLoadingBorder(
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
                            onChanged: (String value) =>
                              value.trim().length <= 1
                                ?_(() {}) : null
                            ,
                            controller: item["passphrase"],
                            style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                              border: InputBorder.none,
                              hintText: 'Passphrase',
                              hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                              prefixIcon: item["controller"].text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                              suffixIcon: IconButton(onPressed: () => _(() => item["passphrase_state"]= !item["passphrase_state"]), icon: Icon(item["passphrase_state"] ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
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
            ),if()const SizedBox(height: 20),],
          ],
        ),
      ),
    );
  }
}
