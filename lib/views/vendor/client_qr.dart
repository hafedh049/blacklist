import 'dart:math';

import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/qr_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:searchfield/searchfield.dart';

class Client extends StatefulWidget {
  const Client({super.key, required this.storeID});
  final String storeID;
  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();

  final List<String> _names = names;

  late final Map<String, Map<String, dynamic>> _productTemplate = <String, Map<String, dynamic>>{
    "Full Name": <String, dynamic>{
      "controller": _usernameController,
      "type": "text",
      "required": true,
      "hint": "Enter the client name",
      "key": GlobalKey<State>(),
    },
    "Birth Date": <String, dynamic>{
      "controller": _birthDateController,
      "type": "date",
      "required": true,
      "hint": "Prompt the birthdate : ${formatDate(DateTime.now(), const <String>[yy, '-', M, '-', d]).toUpperCase()}",
      "key": GlobalKey<State>(),
    },
    "CIN": <String, dynamic>{
      "controller": _cinController,
      "type": "number",
      "required": true,
      "hint": "CIN is required : ${List<String>.generate(8, (int index) => Random().nextInt(10).toString()).join()}",
      "key": GlobalKey<State>(),
    },
  };

  @override
  void initState() {
    FirebaseFirestore.instance.collection("clients").where("storesID", arrayContains: widget.storeID).get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        _productTemplate["Full Name"]!["key"].currentState!.setState(() => names = value.docs.map((e) => e.data()["clientName"]).toList().cast<String>());
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _birthDateController.dispose();
    _cinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                QRView(storeID: widget.storeID),
                const SizedBox(height: 20),
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
                                child: entry.value["type"] != "text"
                                    ? TextField(
                                        onChanged: (String value) {
                                          if (value.trim().length <= 1) {
                                            entry.value["key"].currentState!.setState(() {});
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
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(entry.value["type"] == "number" ? r"\d" : r"."))],
                                      )
                                    : StatefulBuilder(
                                        key: entry.value["key"],
                                        builder: (BuildContext context, void Function(void Function()) _) {
                                          return SearchField<String>(
                                            autoCorrect: false,
                                            onSearchTextChanged: (String value) {
                                              if (value.trim().length <= 1) {
                                                entry.value["key"].currentState!.setState(() {});
                                              }
                                              return _names.where((String element) => element.toLowerCase().startsWith(value.toLowerCase())).map((String e) => SearchFieldListItem<String>(e, item: e, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(e)))).toList();
                                            },
                                            controller: entry.value["controller"],
                                            searchStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                            searchInputDecoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(20),
                                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                              border: InputBorder.none,
                                              hintText: entry.value["hint"],
                                              hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                              suffixIcon: entry.value["controller"].text.trim().isEmpty ? const SizedBox() : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                            ),
                                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(entry.value["type"] == "number" ? r"\d" : r".")), LengthLimitingTextInputFormatter(8)],
                                            suggestions: _names.map((String e) => SearchFieldListItem<String>(e, item: e, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(e)))).toList(),
                                          );
                                        },
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
                              text: 'NEXT',
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
