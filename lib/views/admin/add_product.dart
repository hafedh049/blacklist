import 'package:blacklist/utils/callbacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:uuid/v8.dart';

import '../../utils/shared.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key, required this.storeID, required this.categoryID, required this.categoryName, required this.callback});
  final String categoryID;
  final String categoryName;
  final String storeID;
  final void Function() callback;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDateController = TextEditingController();
  final TextEditingController _productReferenceController = TextEditingController(text: const UuidV8().generate());
  final TextEditingController _productOldPriceController = TextEditingController();
  final TextEditingController _productNewPriceController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();
  final TextEditingController _productStockAlertController = TextEditingController();

  late final Map<String, Map<String, dynamic>> _productTemplate = <String, Map<String, dynamic>>{
    "Product Name": <String, dynamic>{
      "controller": _productNameController,
      "type": "text",
      "required": true,
      "hint": "Choose Name",
    },
    "Date": <String, dynamic>{
      "controller": _productDateController,
      "type": "date",
      "required": false,
      "hint": formatDate(DateTime.now(), const <String>[yy, '-', M, '-', d, " ", HH, ':', nn, ':', ss]).toUpperCase(),
    },
    "Reference": <String, dynamic>{
      "controller": _productReferenceController,
      "type": "reference",
      "required": false,
      "hint": "",
    },
    "Base Price": <String, dynamic>{
      "controller": _productOldPriceController,
      "type": "double",
      "required": true,
      "hint": "0.00 DT",
    },
    "New Price": <String, dynamic>{
      "controller": _productNewPriceController,
      "type": "double",
      "required": true,
      "hint": "0.00 DT",
    },
    "Quantity": <String, dynamic>{
      "controller": _productQuantityController,
      "type": "number",
      "required": true,
      "hint": "0",
    },
    "Stock Alert": <String, dynamic>{
      "controller": _productStockAlertController,
      "type": "number",
      "required": true,
      "hint": "0",
    },
  };

  @override
  void dispose() {
    _productNameController.dispose();
    _productDateController.dispose();
    _productReferenceController.dispose();
    _productOldPriceController.dispose();
    _productNewPriceController.dispose();
    _productQuantityController.dispose();
    _productStockAlertController.dispose();
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
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("ADD PRODUCT", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                  const Spacer(),
                ],
              ),
              Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
              Wrap(
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
                          color: darkColor,
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return TextField(
                                onChanged: (String value) {
                                  if (value.trim().length <= 1) {
                                    _(() {});
                                  }
                                },
                                controller: entry.value["controller"],
                                readOnly: entry.value["type"] == "date" || entry.value["type"] == "reference" ? true : false,
                                style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                                  border: InputBorder.none,
                                  hintText: entry.value["hint"],
                                  hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                                  suffixIcon: entry.value["controller"].text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                ),
                                cursorColor: purpleColor,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      entry.value["type"] == "double"
                                          ? r"[\d.]"
                                          : entry.value["type"] == "number"
                                              ? r"\d"
                                              : r".",
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
              AnimatedButton(
                width: 150,
                height: 40,
                text: 'SUBMIT',
                selectedTextColor: darkColor,
                animatedOn: AnimatedOn.onHover,
                animationDuration: 500.ms,
                isReverse: true,
                selectedBackgroundColor: greenColor,
                backgroundColor: purpleColor,
                transitionType: TransitionType.TOP_TO_BOTTOM,
                textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                onPress: () async {
                  if (_productNameController.text.trim().isEmpty) {
                    showToast("Please fill the product name", redColor);
                  } else if (_productOldPriceController.text.trim().isEmpty) {
                    showToast("Please fill the product old price", redColor);
                  } else if (_productNewPriceController.text.trim().isEmpty) {
                    showToast("Please fill the product new price", redColor);
                  } else if (_productQuantityController.text.trim().isEmpty) {
                    showToast("Please fill the product quantity field", redColor);
                  } else if (_productStockAlertController.text.trim().isEmpty) {
                    showToast("Please fill the product quantity field", redColor);
                  } else {
                    await FirebaseFirestore.instance.collection('products').add(
                      <String, dynamic>{
                        "productQuantity": int.parse(_productQuantityController.text),
                        "categoryID": widget.categoryID,
                        "date": DateTime.now(),
                        'productName': _productNameController.text.trim(),
                        'productCategory': widget.categoryName,
                        'realPrice': double.parse(_productOldPriceController.text),
                        'newPrice': double.parse(_productNewPriceController.text),
                        'productReference': _productReferenceController.text,
                        'stockAlert': int.parse(_productStockAlertController.text),
                        "storeID": widget.storeID,
                      },
                    );
                    showToast("Product added successfully", greenColor);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    widget.callback();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
