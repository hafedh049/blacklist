import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/holder.dart';
import 'package:blacklist/views/auth/passphrase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

class StoresList extends StatefulWidget {
  const StoresList({super.key});

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  final GlobalKey<State> _storesKey = GlobalKey<State>();

  final List<Map<String, dynamic>> _stores = <Map<String, dynamic>>[];

  final TextEditingController _adminController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _vendorNameController = TextEditingController();

  final String _adminPassphrase = "admin";

  bool _oldPasswordState = false;
  bool _newPasswordState = false;

  bool _adminState = false;

  @override
  void dispose() {
    _adminController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _storeNameController.dispose();
    _vendorNameController.dispose();
    super.dispose();
  }

  Future<void> _createStore() async {
    if (_storeNameController.text.trim().isEmpty) {
      showToast("Enter a valid store name", redColor);
    }
    if (_vendorNameController.text.trim().isEmpty) {
      showToast("Enter a valid vendor name", redColor);
    } else {
      String now = DateTime.now().millisecondsSinceEpoch.toString();
      final Map<String, dynamic> storeItem = <String, dynamic>{
        "store_name": _storeNameController.text.trim(),
        "store_vendor_name": _vendorNameController.text.trim(),
        "store_total_products": 0,
        "store_state": "open",
        "store_id": now,
      };
      final Map<String, dynamic> vendorItem = <String, dynamic>{
        "store_id": now,
        "vendor_name": _vendorNameController.text.trim(),
        "vendor_email":_vendorEmailController.text.trim(),
        "vendor_password":_vendorPasswordController.text.trim(),
        "vendor_id": ,
      };
      await FirebaseFirestore.instance.collection('stores').add(storeItem);
      _stores.add(storeItem);
      _storesKey.currentState!.setState(() {});
      showToast("Store added successfully", greenColor);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void _changePassword() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: darkColor,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return TextField(
                    obscureText: !_oldPasswordState,
                    onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                    controller: _oldPasswordController,
                    style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                      border: InputBorder.none,
                      hintText: 'OLD PASSWORD',
                      hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                      prefixIcon: _oldPasswordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                      suffixIcon: IconButton(onPressed: () => _(() => _oldPasswordState = !_oldPasswordState), icon: Icon(_oldPasswordState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                    ),
                    cursorColor: purpleColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: darkColor,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return TextField(
                    obscureText: !_newPasswordState,
                    onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                    controller: _newPasswordController,
                    style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                      border: InputBorder.none,
                      hintText: 'NEW PASSWORD',
                      hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                      prefixIcon: _newPasswordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                      suffixIcon: IconButton(onPressed: () => _(() => _newPasswordState = !_newPasswordState), icon: Icon(_newPasswordState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
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
                const Spacer(),
                AnimatedButton(
                  width: 100,
                  height: 30,
                  text: 'CHANGE',
                  selectedTextColor: whiteColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: darkColor,
                  backgroundColor: greenColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Stores", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                AnimatedButton(
                  width: 100,
                  height: 35,
                  text: 'ADD STORE',
                  selectedTextColor: darkColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: redColor,
                  backgroundColor: purpleColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: darkColor,
                              child: StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) _) {
                                  return TextField(
                                    onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                    controller: _storeNameController,
                                    style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(20),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                      border: InputBorder.none,
                                      hintText: 'STORE NAME',
                                      hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                      prefixIcon: _storeNameController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                    ),
                                    cursorColor: purpleColor,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: darkColor,
                              child: StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) _) {
                                  return TextField(
                                    onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                    controller: _vendorNameController,
                                    style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                    onSubmitted: (String value) async => await _createStore(),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(20),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                      border: InputBorder.none,
                                      hintText: 'VENDOR NAME',
                                      hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                      prefixIcon: _vendorNameController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
                                const Spacer(),
                                AnimatedButton(
                                  width: 100,
                                  height: 30,
                                  text: 'CREATE',
                                  selectedTextColor: whiteColor,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: 500.ms,
                                  isReverse: true,
                                  selectedBackgroundColor: darkColor,
                                  backgroundColor: greenColor,
                                  transitionType: TransitionType.TOP_TO_BOTTOM,
                                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  onPress: () async => await _createStore(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                AnimatedButton(
                  width: 100,
                  height: 35,
                  text: 'SIGN-OUT',
                  selectedTextColor: darkColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: redColor,
                  backgroundColor: purpleColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Passphrase()));
                  },
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: Center(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadStores(),
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      _stores.addAll(snapshot.data!);
                      return StatefulBuilder(
                        key: _storesKey,
                        builder: (BuildContext context, void Function(void Function()) setS) => _stores.isEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  LottieBuilder.asset("assets/lotties/empty.json"),
                                  Text("No Stores Yet.", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  runSpacing: 20,
                                  spacing: 20,
                                  children: <Widget>[
                                    for (final Map<String, dynamic> item in _stores)
                                      InkWell(
                                        splashColor: transparentColor,
                                        hoverColor: transparentColor,
                                        highlightColor: transparentColor,
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()));
                                        },
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Store", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item["store_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Vendor", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item["vendor_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Total Products", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item["total_products"].toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text("Vendor Acess", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      AnimatedButton(
                                                        width: 100,
                                                        height: 40,
                                                        text: 'OPEN',
                                                        selectedTextColor: darkColor,
                                                        animatedOn: AnimatedOn.onHover,
                                                        animationDuration: 500.ms,
                                                        isReverse: true,
                                                        selectedBackgroundColor: greenColor,
                                                        backgroundColor: purpleColor,
                                                        transitionType: TransitionType.TOP_TO_BOTTOM,
                                                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                                        onPress: () {},
                                                      ),
                                                      const SizedBox(width: 20),
                                                      AnimatedButton(
                                                        width: 100,
                                                        height: 40,
                                                        text: 'CLOSE',
                                                        selectedTextColor: darkColor,
                                                        animatedOn: AnimatedOn.onHover,
                                                        animationDuration: 500.ms,
                                                        isReverse: true,
                                                        selectedBackgroundColor: redColor,
                                                        backgroundColor: purpleColor,
                                                        transitionType: TransitionType.TOP_TO_BOTTOM,
                                                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                                        onPress: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) => Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            color: darkColor,
                                                            child: StatefulBuilder(
                                                              builder: (BuildContext context, void Function(void Function()) _) {
                                                                return TextField(
                                                                  autofocus: true,
                                                                  obscureText: !_adminState,
                                                                  onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                                                  controller: _adminController,
                                                                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                                                  onSubmitted: (String value) {
                                                                    if (_adminController.text == _adminPassphrase) {
                                                                      Navigator.pop(context);
                                                                      _changePassword();
                                                                    } else {
                                                                      showToast("Wrong Credentials", redColor);
                                                                    }
                                                                  },
                                                                  decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.all(20),
                                                                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                                                    border: InputBorder.none,
                                                                    hintText: "Security Bypass",
                                                                    hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                                                    prefixIcon: _adminController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                                                    suffixIcon: IconButton(onPressed: () => _(() => _adminState = !_adminState), icon: Icon(_adminState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                                                                  ),
                                                                  cursorColor: purpleColor,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              const Spacer(),
                                                              AnimatedButton(
                                                                width: 100,
                                                                height: 30,
                                                                text: 'CONTINUE',
                                                                selectedTextColor: whiteColor,
                                                                animatedOn: AnimatedOn.onHover,
                                                                animationDuration: 500.ms,
                                                                isReverse: true,
                                                                selectedBackgroundColor: darkColor,
                                                                backgroundColor: greenColor,
                                                                transitionType: TransitionType.TOP_TO_BOTTOM,
                                                                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                                                onPress: () {
                                                                  if (_adminController.text == _adminPassphrase) {
                                                                    Navigator.pop(context);
                                                                    _changePassword();
                                                                  } else {
                                                                    showToast("Wrong Credentials", redColor);
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(FontAwesome.user_secret_solid, size: 25, color: purpleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    }
                    return Errored(error: snapshot.error.toString());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
