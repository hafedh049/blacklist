import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/models/client_model.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/vendor/after_qr_scan.dart';
import 'package:blacklist/views/vendor/qr_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _phoneController = TextEditingController();

  List<String> _names = <String>[];
  List<String> _phones = <String>[];

  late final Map<String, Map<String, dynamic>> _productTemplate = <String, Map<String, dynamic>>{
    "NOM": <String, dynamic>{
      "controller": _usernameController,
      "type": "text",
      "required": true,
      "hint": "Enter le nom du client",
      "key": GlobalKey<State>(),
    },
    "TELEPHONE": <String, dynamic>{
      "controller": _phoneController,
      "type": "number",
      "required": true,
      "hint": "Numéro de téléphone est obligatoire",
      "key": GlobalKey<State>(),
    },
  };

  Future<bool> _load() async {
    await FirebaseFirestore.instance.collection("clients").where("storesID", arrayContains: widget.storeID).get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        _productTemplate["NOM"]!["key"].currentState!.setState(() => _names = value.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data()["clientName"]).toList().cast<String>());
        _productTemplate["TELEPHONE"]!["key"].currentState!.setState(() => _phones = value.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data()["clientPhone"]).toList().cast<String>());
      },
    );
    return true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        child: FutureBuilder<bool>(
                          future: _load(),
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            return Column(
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
                                            ? StatefulBuilder(
                                                key: entry.value["key"],
                                                builder: (BuildContext context, void Function(void Function()) _) {
                                                  return SearchField<String>(
                                                    autoCorrect: false,
                                                    onSearchTextChanged: (String value) {
                                                      if (value.trim().length <= 1) {
                                                        entry.value["key"].currentState!.setState(() {});
                                                      }
                                                      return _phones.where((String element) => element.toLowerCase().startsWith(value.toLowerCase())).map((String e) => SearchFieldListItem<String>(e, item: e, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(e)))).toList();
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
                                                    suggestions: _phones.map((String e) => SearchFieldListItem<String>(e, item: e, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(e)))).toList(),
                                                  );
                                                },
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
                                Center(
                                  child: AnimatedButton(
                                    width: 150,
                                    height: 40,
                                    text: 'SUIVANT',
                                    selectedTextColor: darkColor,
                                    animatedOn: AnimatedOn.onHover,
                                    animationDuration: 500.ms,
                                    isReverse: true,
                                    selectedBackgroundColor: greenColor,
                                    backgroundColor: purpleColor,
                                    transitionType: TransitionType.TOP_TO_BOTTOM,
                                    textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                    onPress: () async {
                                      if (_usernameController.text.trim().isNotEmpty) {
                                        await FirebaseFirestore.instance.collection("clients").where("clientName", isEqualTo: _usernameController.text.trim()).limit(1).get().then(
                                          (QuerySnapshot<Map<String, dynamic>> value) {
                                            if (value.docs.isNotEmpty) {
                                              showToast(context, "Client trouvé", purpleColor);
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AfterQRScan(storeID: widget.storeID, client: ClientModel.fromJson(value.docs.first.data()))));
                                            } else {
                                              showToast(context, "Pas de client avec ce nom", purpleColor);
                                            }
                                          },
                                        );
                                      } else if (_phoneController.text.trim().isNotEmpty) {
                                        await FirebaseFirestore.instance.collection("clients").where("clientPhone", isEqualTo: _phoneController.text.trim()).limit(1).get().then(
                                          (QuerySnapshot<Map<String, dynamic>> value) {
                                            if (value.docs.isNotEmpty) {
                                              showToast(context, "Client trouvé", purpleColor);
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AfterQRScan(storeID: widget.storeID, client: ClientModel.fromJson(value.docs.first.data()))));
                                            } else {
                                              showToast(context, "Pas de client avec ce Téléphone", purpleColor);
                                            }
                                          },
                                        );
                                      } else {
                                        showToast(context, "Entrer soit Nom soit Téléphone", purpleColor);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
