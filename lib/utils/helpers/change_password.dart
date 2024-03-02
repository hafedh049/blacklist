import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../shared.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _oldPasswordState = false;
  bool _newPasswordState = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
                  obscureText: !_oldPasswordState,
                  onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                  controller: _oldPasswordController,
                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                    border: InputBorder.none,
                    hintText: 'VENDOR NAME',
                    hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                    prefixIcon: _oldPasswordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
                  obscureText: !_oldPasswordState,
                  onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                  controller: _oldPasswordController,
                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                    border: InputBorder.none,
                    hintText: 'VENDOR E-MAIL',
                    hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                    prefixIcon: _oldPasswordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
    );
  }
}
