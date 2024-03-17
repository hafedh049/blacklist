import 'dart:math';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key, required this.qrCode, required this.storeID});
  final String qrCode;
  final String storeID;
  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late final Map<String, Map<String, dynamic>> _productTemplate = <String, Map<String, dynamic>>{
    "Nom": <String, dynamic>{
      "controller": _usernameController,
      "type": "text",
      "required": true,
      "hint": "Enter le nom du client",
      "key": GlobalKey<State>(),
    },
    "Date De Naissance": <String, dynamic>{
      "controller": _birthDateController,
      "type": "date",
      "required": true,
      "hint": "Entrer le D.D.N : ${formatDate(DateTime.now(), const <String>[d, '-', mm, '-', yyyy]).toUpperCase()}",
      "key": GlobalKey<State>(),
    },
    "CIN": <String, dynamic>{
      "controller": _cinController,
      "type": "number",
      "required": true,
      "hint": "CIN est obigatoire : ${List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join()}",
      "key": GlobalKey<State>(),
    },
    "Téléphone": <String, dynamic>{
      "controller": _phoneController,
      "type": "phone",
      "required": true,
      "hint": "Champ obligatoire : (+216) ${List<String>.generate(2, (int index) => Random().nextInt(10).toString()).join()} ${List<String>.generate(3, (int index) => Random().nextInt(10).toString()).join()} ${List<String>.generate(3, (int index) => Random().nextInt(10).toString()).join()}",
      "key": GlobalKey<State>(),
    },
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _birthDateController.dispose();
    _cinController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor),
                ),
                const SizedBox(height: 10),
                AnimatedLoadingBorder(
                  borderWidth: 4,
                  borderColor: purpleColor,
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(color: darkColor),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (final MapEntry<String, Map<String, dynamic>> entry in _productTemplate.entries)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(entry.key, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                  const SizedBox(width: 5),
                                  Text("*", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: entry.value["required"] ? redColor : greenColor)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                color: scaffoldColor,
                                child: TextField(
                                  onChanged: (String value) {
                                    if (value.trim().length <= 1) {
                                      entry.value["key"].currentState!.setState(() {});
                                    }
                                    if (entry.value["type"] == "phone") {
                                      if (const <int>[2, 6].contains(entry.value["controller"].text.length)) {
                                        entry.value["controller"].text += "";
                                      }
                                    }
                                  },
                                  controller: entry.value["controller"],
                                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                    border: InputBorder.none,
                                    hintText: entry.value["hint"],
                                    hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                    suffixIcon: StatefulBuilder(
                                      key: entry.value["key"],
                                      builder: (BuildContext context, void Function(void Function()) _) {
                                        return entry.value["controller"].text.trim().isEmpty ? const SizedBox() : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor);
                                      },
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(
                                        entry.value["type"] == "phone"
                                            ? r"[\d ]"
                                            : entry.value["type"] == "number"
                                                ? r"\d"
                                                : r".",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        Row(
                          children: <Widget>[
                            const Spacer(),
                            AnimatedButton(
                              width: 150,
                              height: 40,
                              text: 'CREATE',
                              selectedTextColor: darkColor,
                              animatedOn: AnimatedOn.onHover,
                              animationDuration: 500.ms,
                              isReverse: true,
                              selectedBackgroundColor: greenColor,
                              backgroundColor: purpleColor,
                              transitionType: TransitionType.TOP_TO_BOTTOM,
                              textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                              onPress: () async {
                                if (_usernameController.text.trim().isEmpty) {
                                  showToast(context, "Username est obligatoire", redColor);
                                } else if (!_birthDateController.text.contains(RegExp(r'\d{4}\-\d{2}\-\d{2}'))) {
                                  showToast(context, "Année de naissance est obligatoire ou incorrect", redColor);
                                } else if (!_cinController.text.contains(RegExp(r'\d{8}'))) {
                                  showToast(context, "CIN est obligatoire", redColor);
                                } else if (!_phoneController.text.contains(RegExp(r'(\(\+216 ?\)|\d\d ?\d\d\d ?\d\d\d)'))) {
                                  showToast(context, "Téléphone est obligatoire", redColor);
                                } else {
                                  await FirebaseFirestore.instance.collection("clients").add(
                                    <String, dynamic>{
                                      'clientQrCode': widget.qrCode,
                                      'storesID': <String>[widget.storeID],
                                      'clientName': _usernameController.text,
                                      'clientCIN': _cinController.text,
                                      'clientBirthdate': DateTime.parse(_birthDateController.text),
                                      'clientPhone': _phoneController.text,
                                    },
                                  );
                                  // ignore: use_build_context_synchronously
                                  showToast(context, "Client created successfully", greenColor);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
