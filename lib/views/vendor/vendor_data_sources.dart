import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class RestorableProductSelections extends RestorableProperty<Set<int>> {
  Set<int> _productSelections = <int>{};

  bool isSelected(int index) => _productSelections.contains(index);

  void setProductSelections(List<VendorProduct> products) {
    final Set<int> updatedSet = <int>{};
    for (int index = 0; index < products.length; index += 1) {
      VendorProduct product = products[index];
      if (product.selected) {
        updatedSet.add(index);
      }
    }
    _productSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _productSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _productSelections = <int>{...selectedItemIndices.map<int>((dynamic id) => id as int)};
    return _productSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _productSelections = value;
  }

  @override
  Object toPrimitives() => _productSelections.toList();
}

class VendorProduct {
  String productName;
  String storeID;
  String productCategory;
  String categoryID;
  double realPrice;
  double newPrice;
  String productReference;
  int productQuantity;
  int stockAlert;
  DateTime date;
  bool selected = false;

  VendorProduct({
    required this.storeID,
    required this.productQuantity,
    required this.categoryID,
    required this.date,
    required this.productName,
    required this.productCategory,
    required this.realPrice,
    required this.newPrice,
    required this.productReference,
    required this.stockAlert,
  });

  factory VendorProduct.fromJson(Map<String, dynamic> json) {
    return VendorProduct(
      storeID: json["storeID"],
      productQuantity: json["productQuantity"],
      categoryID: json["categoryID"],
      date: json["date"].toDate(),
      productName: json['productName'],
      productCategory: json['productCategory'],
      realPrice: json['realPrice'].toDouble(),
      newPrice: json['newPrice'].toDouble(),
      productReference: json['productReference'],
      stockAlert: json['stockAlert'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "storeID": storeID,
      "productQuantity": productQuantity,
      "categoryID": categoryID,
      "date": date,
      'productName': productName,
      'productCategory': productCategory,
      'realPrice': realPrice,
      'newPrice': newPrice,
      'productReference': productReference,
      'stockAlert': stockAlert,
    };
  }

  final TextEditingController cartController = TextEditingController(text: "0");

  void dispose() {
    cartController.dispose();
  }
}

class ProductDataSource extends DataTableSource {
  ProductDataSource.empty(this.context) {
    products = <VendorProduct>[];
  }

  ProductDataSource(this.context, this.products, [sortedByNames = true, this.hasRowTaps = true, this.hasRowHeightOverrides = true, this.hasZebraStripes = true]) {
    if (sortedByNames) {
      sort((VendorProduct p) => p.productName, true);
    }
  }

  final BuildContext context;
  late List<VendorProduct> products;
  bool hasRowTaps = true;
  bool hasRowHeightOverrides = true;
  bool hasZebraStripes = true;

  @override
  void dispose() {
    for (final VendorProduct product in products) {
      product.dispose();
    }
    super.dispose();
  }

  void sort<T>(Comparable<T> Function(VendorProduct p) getField, bool ascending) {
    products.sort(
      (VendorProduct a, VendorProduct b) {
        final Comparable<T> aValue = getField(a);
        final Comparable<T> bValue = getField(b);
        return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
      },
    );
    notifyListeners();
  }

  void updateSelectedProducts(RestorableProductSelections selectedRows) {
    _selectedCount = 0;
    for (int index = 0; index < products.length; index += 1) {
      VendorProduct product = products[index];
      if (selectedRows.isSelected(index)) {
        product.selected = true;
        _selectedCount += 1;
      } else {
        product.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= products.length) throw 'index > _products.length';
    final VendorProduct product = products[index];
    return DataRow2.byIndex(
      index: index,
      selected: product.selected,
      color: color != null ? MaterialStateProperty.all(color) : (hasZebraStripes && index.isEven ? MaterialStateProperty.all(Theme.of(context).highlightColor) : null),
      onSelectChanged: (bool? value) {
        if (product.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          product.selected = value;
          notifyListeners();
        }
      },
      cells: <DataCell>[
        DataCell(Text(product.productName)),
        !product.selected
            ? DataCell(Text(product.productQuantity.toString()))
            : DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        if (int.parse(product.cartController.text) > 0) {
                          product.cartController.text = (int.parse(product.cartController.text) - 1).toString();
                        }
                      },
                      icon: const Icon(FontAwesome.circle_minus_solid, size: 20, color: whiteColor),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: darkColor,
                      child: TextField(
                        controller: product.cartController,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(4),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                          border: OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                        ),
                        cursorColor: purpleColor,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"\d"))],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        product.cartController.text = (int.parse(product.cartController.text) + 1).toString();
                      },
                      icon: const Icon(FontAwesome.circle_plus_solid, size: 20, color: whiteColor),
                    ),
                  ],
                ),
              ),
        DataCell(Text(formatDate(product.date, const <String>[yyyy, " ", MM, " ", dd]))),
        DataCell(Text(product.productReference)),
        DataCell(Text(product.newPrice.toStringAsFixed(2))),
      ],
    );
  }

  @override
  int get rowCount => products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final VendorProduct product in products) {
      product.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? products.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;
