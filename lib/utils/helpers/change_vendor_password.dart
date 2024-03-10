import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../callbacks.dart';
import '../shared.dart';
import 'change_password.dart';

class ChangeVendorPassword extends StatefulWidget {
  const ChangeVendorPassword({super.key, required this.storeID});
  final String storeID;
  @override
  State<ChangeVendorPassword> createState() => _ChangeVendorPasswordState();
}

class _ChangeVendorPasswordState extends State<ChangeVendorPassword> {
  void _changePassword() => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: ChangePassword(senderID: widget.storeID)));

  final String _adminPassphrase = "admin";

  bool _adminState = false;

  final TextEditingController _adminController = TextEditingController();

  final FocusNode _adminFocus = FocusNode();

  @override
  void dispose() {
    _adminController.dispose();
    _adminFocus.dispose();
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
                  autofocus: true,
                  obscureText: !_adminState,
                  focusNode: _adminFocus,
                  onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                  controller: _adminController,
                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  onSubmitted: (String value) {
                    if (_adminController.text == _adminPassphrase) {
                      Navigator.pop(context);
                      _changePassword();
                    } else {
                      _adminFocus.requestFocus();
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
    );
  }
}
