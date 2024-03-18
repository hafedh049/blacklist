import 'package:blacklist/models/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:uuid/v8.dart';

import '../../utils/callbacks.dart';
import '../../utils/shared.dart';

class AddStore extends StatefulWidget {
  const AddStore({super.key, required this.callback, required this.stores});
  final List<StoreModel> stores;
  final void Function() callback;
  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _vendorNameController = TextEditingController();
  final TextEditingController _vendorPasswordController = TextEditingController();

  bool _vendorPasswordState = false;

  Future<void> _createStore() async {
    if (_storeNameController.text.trim().isEmpty) {
      showToast(context, "Enter a valid store name", redColor);
    } else if (_vendorNameController.text.trim().isEmpty) {
      showToast(context, "Enter a valid vendor name", redColor);
    } else if (_vendorPasswordController.text.trim().isEmpty) {
      showToast(context, "Enter a valid vendor password", redColor);
    } else {
      String storeID = const UuidV8().generate();

      final Map<String, dynamic> storeItem = <String, dynamic>{
        'storeID': storeID,
        'storeName': _storeNameController.text.trim(),
        'storeState': "ouvert",
        'storeVendorName': _vendorNameController.text.trim(),
        'storeVendorPassword': _vendorPasswordController.text.trim(),
        "storeTotalProducts": 0,
      };

      await FirebaseFirestore.instance.collection('stores').doc(storeID).set(storeItem);

      widget.stores.add(StoreModel.fromJson(storeItem));
      widget.callback();
      // ignore: use_build_context_synchronously
      showToast(context, "Store added successfully", greenColor);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _vendorPasswordController.dispose();
    _storeNameController.dispose();
    _vendorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: darkColor,
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) _) {
              return TextField(
                onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                onSubmitted: (String value) => _createStore(),
                controller: _storeNameController,
                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                  border: InputBorder.none,
                  hintText: 'NOM DU STORE',
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
                onSubmitted: (String value) => _createStore(),
                controller: _vendorNameController,
                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                  border: InputBorder.none,
                  hintText: 'NOM DU VONDEUR',
                  hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  prefixIcon: _vendorNameController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
                obscureText: !_vendorPasswordState,
                onSubmitted: (String value) => _createStore(),
                onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                controller: _vendorPasswordController,
                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                  border: InputBorder.none,
                  hintText: '**********',
                  hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  prefixIcon: _vendorPasswordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                  suffixIcon: IconButton(onPressed: () => _(() => _vendorPasswordState = !_vendorPasswordState), icon: Icon(_vendorPasswordState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
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
              text: 'CREER',
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
    );
  }
}
