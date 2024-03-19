import 'package:blacklist/utils/callbacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../models/store_model.dart';
import '../../utils/shared.dart';

class DeleteStore extends StatefulWidget {
  const DeleteStore({super.key, required this.storeID, required this.stores, required this.callback});
  final String storeID;
  final List<StoreModel> stores;
  final void Function() callback;
  @override
  State<DeleteStore> createState() => _DeleteStoreState();
}

class _DeleteStoreState extends State<DeleteStore> {
  final String _passphrase = "admin";
  final TextEditingController _confirmController = TextEditingController();

  void _validate() async {
    if (_confirmController.text != _passphrase) {
      showToast(context, "Enter the confirmation passphrase", redColor);
    } else {
      widget.stores.removeWhere((StoreModel element) => element.storeID == widget.storeID);
      widget.callback();
      await FirebaseFirestore.instance.collection("products").where("storeID", isEqualTo: widget.storeID).get().then(
        (QuerySnapshot<Map<String, dynamic>> value) async {
          for (final QueryDocumentSnapshot<Map<String, dynamic>> product in value.docs) {
            await product.reference.delete();
          }
        },
      );
      await FirebaseFirestore.instance.collection("sells").where("storeID", isEqualTo: widget.storeID).get().then(
        (QuerySnapshot<Map<String, dynamic>> value) async {
          for (final QueryDocumentSnapshot<Map<String, dynamic>> selledproduct in value.docs) {
            await selledproduct.reference.delete();
          }
        },
      );
      await FirebaseFirestore.instance.collection("categories").where("storeID", isEqualTo: widget.storeID).get().then(
        (QuerySnapshot<Map<String, dynamic>> value) async {
          for (final QueryDocumentSnapshot<Map<String, dynamic>> category in value.docs) {
            await category.reference.delete();
          }
        },
      );
      await FirebaseFirestore.instance.collection("stores").where("storeID", isEqualTo: widget.storeID).limit(1).get().then(
            (QuerySnapshot<Map<String, dynamic>> value) async => await value.docs.first.reference.delete(),
          );
      // ignore: use_build_context_synchronously
      showToast(context, "Store deleted", greenColor);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Are you sure to delete '${widget.stores.firstWhere((StoreModel element) => element.storeID == widget.storeID).storeName}'",
          style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        ),
        const SizedBox(height: 20),
        Container(
          color: darkColor,
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) _) {
              return TextField(
                onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                onSubmitted: (String value) => _validate(),
                controller: _confirmController,
                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                  border: InputBorder.none,
                  hintText: 'PASSPHRASE',
                  hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                  prefixIcon: _confirmController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
              text: 'EFFACER',
              selectedTextColor: whiteColor,
              animatedOn: AnimatedOn.onHover,
              animationDuration: 500.ms,
              isReverse: true,
              selectedBackgroundColor: darkColor,
              backgroundColor: greenColor,
              transitionType: TransitionType.TOP_TO_BOTTOM,
              textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
              onPress: () => _validate(),
            ),
            const SizedBox(width: 10),
            AnimatedButton(
              width: 100,
              height: 30,
              text: 'QUITTER',
              selectedTextColor: whiteColor,
              animatedOn: AnimatedOn.onHover,
              animationDuration: 500.ms,
              isReverse: true,
              selectedBackgroundColor: darkColor,
              backgroundColor: greenColor,
              transitionType: TransitionType.TOP_TO_BOTTOM,
              textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
              onPress: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
