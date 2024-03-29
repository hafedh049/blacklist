import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../callbacks.dart';
import '../shared.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.senderID});
  final String senderID;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _oldPasswordState = true;
  bool _newPasswordState = false;

  Future<void> _update() async {
    if (_nameController.text.trim().isEmpty) {
      showToast(context, "Entrer un nom du vendeur valide", redColor);
    } else if (_newPasswordController.text.trim().isEmpty) {
      showToast(context, "Enter son mot de passe", redColor);
    } else {
      final Map<String, dynamic> vendorItem = <String, dynamic>{
        "storeVendorName": _nameController.text.trim(),
        "storeVendorPassword": _newPasswordController.text.trim(),
      };
      await FirebaseFirestore.instance.collection('stores').doc(widget.senderID).update(vendorItem);
      // ignore: use_build_context_synchronously
      showToast(context, "Mise a jour avec succés", greenColor);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collection("stores").doc(widget.senderID).get().then(
      (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          _nameController.text = snapshot.get("storeVendorName");
          _oldPasswordController.text = snapshot.get("storeVendorPassword");
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  controller: _nameController,
                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                    border: InputBorder.none,
                    hintText: 'NOM DU VENDEUR',
                    hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                    prefixIcon: _nameController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
                  readOnly: true,
                  obscureText: !_oldPasswordState,
                  onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                  controller: _oldPasswordController,
                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                    border: InputBorder.none,
                    hintText: 'ANCIEN PASSWORD',
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
                  onSubmitted: (String value) => _update(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                    border: InputBorder.none,
                    hintText: 'NOUVEAU PASSWORD',
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
                text: 'CHANGER',
                selectedTextColor: whiteColor,
                animatedOn: AnimatedOn.onHover,
                animationDuration: 500.ms,
                isReverse: true,
                selectedBackgroundColor: darkColor,
                backgroundColor: greenColor,
                transitionType: TransitionType.TOP_TO_BOTTOM,
                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                onPress: _update,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
