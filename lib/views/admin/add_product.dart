import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDateController = TextEditingController();
  final TextEditingController _productReferenceController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _productOldPriceController = TextEditingController();
  final TextEditingController _productNewPriceController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();
  final TextEditingController _productStockAlertController = TextEditingController();

  late final Map<String, Map<String, dynamic>> _productTemplate = <String, Map<String, dynamic>>{
    "Category": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "text",
    },
    "Product Name": <String, dynamic>{
      "controller": _productNameController,
      "type": "text",
    },
    "Date": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "date",
    },
    "Reference": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "reference",
    },
    "Base Price": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "number",
    },
    "New Price": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "number",
    },
    "Quantity": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "number",
    },
    "Stock Alert": <String, dynamic>{
      "controller": _productCategoryController,
      "type": "number",
    },
  };

  @override
  void dispose() {
    _productNameController.dispose();
    _productDateController.dispose();
    _productReferenceController.dispose();
    _productCategoryController.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              children: <Widget>[
                for (final MapEntry<String, Map<String, dynamic>> entry in _productTemplate.entries)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(entry.key, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: entry.value["controller"],
                        readOnly: entry.value["date"] == "text" && entry.value["type"] == "reference" ? true : false,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        decoration: InputDecoration(contentPadding: const EdgeInsets.all(8),border: ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}