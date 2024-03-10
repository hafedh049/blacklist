// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/stores.dart';
import 'package:blacklist/views/vendor/cart_recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _submitButtonState = false;

  bool _passwordState = false;

  final GlobalKey<State> _cardKey = GlobalKey<State>();
  final GlobalKey<State> _pragmaKey = GlobalKey<State>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isVendor = false;

  Future<void> _signIn() async {
    if (_passwordController.text.trim().isEmpty) {
      showToast("Please enter the password", redColor);
    } else if (!_isVendor && _emailController.text.trim().isEmpty) {
      showToast("Please enter the e-mail", redColor);
    } else {
      _cardKey.currentState!.setState(() => _submitButtonState = true);
      try {
        if (!_isVendor) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
          _cardKey.currentState!.setState(() => _submitButtonState = false);
          if (FirebaseAuth.instance.currentUser != null) {
            showToast("Welcome ADMIN", greenColor);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const StoresList()));
          }
        } else {
          await FirebaseFirestore.instance.collection("stores").where("storeVendorPassword", isEqualTo: _passwordController.text).limit(1).get().then(
            (QuerySnapshot<Map<String, dynamic>> value) {
              if (value.docs.isNotEmpty) {
                _cardKey.currentState!.setState(() => _submitButtonState = false);
                showToast("Welcome VENDOR", greenColor);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CartRecepie(storeID: value.docs[0]["storeID"])));
              } else {
                _cardKey.currentState!.setState(() => _submitButtonState = false);
                showToast("Invalid Password", redColor);
              }
            },
          );
        }
      } catch (e) {
        _cardKey.currentState!.setState(() => _submitButtonState = false);
        showToast(e.toString(), redColor);
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
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
                      Text("WELCOME", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                      const SizedBox(height: 10),
                      StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("VENDEUR", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Radio(
                                    groupValue: _isVendor,
                                    value: true,
                                    onChanged: (bool? value) {
                                      _(() => _isVendor = value!);
                                      _pragmaKey.currentState!.setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("ADMIN", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Radio(
                                    groupValue: _isVendor,
                                    value: false,
                                    onChanged: (bool? value) {
                                      _(() => _isVendor = value!);
                                      _pragmaKey.currentState!.setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                      StatefulBuilder(
                          key: _pragmaKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return _isVendor
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
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
                                              onSubmitted: (String value) => _signIn(),
                                              onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                              controller: _emailController,
                                              style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(20),
                                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                                border: InputBorder.none,
                                                hintText: 'abcd@xyz.tn',
                                                hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                                prefixIcon: _emailController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                              ),
                                              cursorColor: purpleColor,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                          }),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(child: Text("Mot de passe", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor))),
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
                              obscureText: !_passwordState,
                              onSubmitted: (String value) => _signIn(),
                              onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                              controller: _passwordController,
                              style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                border: InputBorder.none,
                                hintText: '**********',
                                hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                prefixIcon: _passwordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                suffixIcon: IconButton(onPressed: () => _(() => _passwordState = !_passwordState), icon: Icon(_passwordState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                              ),
                              cursorColor: purpleColor,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      StatefulBuilder(
                        key: _cardKey,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IgnorePointer(
                                ignoring: _submitButtonState,
                                child: AnimatedButton(
                                  width: 150,
                                  height: 40,
                                  text: _submitButtonState ? "ATTEND..." : 'CONTINUER',
                                  selectedTextColor: darkColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: redColor,
                                  backgroundColor: purpleColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () => _signIn(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              AnimatedOpacity(opacity: _submitButtonState ? 1 : 0, duration: 300.ms, child: const Icon(FontAwesome.bookmark_solid, color: purpleColor, size: 35)),
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
      ),
    );
  }
}
