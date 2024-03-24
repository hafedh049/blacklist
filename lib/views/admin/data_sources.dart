import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/edit_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../models/product_model.dart';

class RestorableProductSelections extends RestorableProperty<Set<int>> {
  Set<int> _productSelections = <int>{};

  bool isSelected(int index) => _productSelections.contains(index);

  void setProductSelections(List<ProductModel> products) {
    final Set<int> updatedSet = <int>{};
    for (int index = 0; index < products.length; index += 1) {
      ProductModel product = products[index];
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

class ProductDataSource extends DataTableSource {
  ProductDataSource.empty(this.context) {
    products = <ProductModel>[];
  }

  ProductDataSource(this.context, this.products, [sortedByNames = true, this.hasRowTaps = true, this.hasRowHeightOverrides = true, this.hasZebraStripes = true]) {
    if (sortedByNames) {
      sort((ProductModel p) => p.productName, true);
    }
  }

  final BuildContext context;
  late List<ProductModel> products;
  bool hasRowTaps = true;
  bool hasRowHeightOverrides = true;
  bool hasZebraStripes = true;

  void sort<T>(Comparable<T> Function(ProductModel p) getField, bool ascending) {
    products.sort(
      (ProductModel a, ProductModel b) {
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
      ProductModel product = products[index];
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
    final ProductModel product = products[index];
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
        DataCell(Text(product.realPrice.toStringAsFixed(2))),
        DataCell(Text(product.newPrice.toStringAsFixed(2))),
        DataCell(Text(product.productQuantity.toString())),
        DataCell(Text(product.stockAlert.toString())),
        DataCell(Text(product.productReference)),
        DataCell(Text(formatDate(product.date, <String>[yyyy, " ", MM, " ", dd]))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditProduct(product: product))),
                icon: const Icon(FontAwesome.pen_solid, color: purpleColor, size: 15),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection("products").where("productReference", isEqualTo: product.productReference).get().then(
                                    (QuerySnapshot<Map<String, dynamic>> value) async => await value.docs.first.reference.delete(),
                                  );

                              await FirebaseFirestore.instance.collection("categories").where("categoryID", isEqualTo: product.categoryID).limit(1).get().then(
                                (QuerySnapshot<Map<String, dynamic>> value) async {
                                  await value.docs.first.reference.update(<String, dynamic>{"categoryArticlesCount": value.docs.first.get("categoryArticlesCount") - 1});
                                },
                              );
                              await FirebaseFirestore.instance.collection("categories").where("categoryID", isEqualTo: product.categoryID).limit(1).get().then(
                                (QuerySnapshot<Map<String, dynamic>> value) async {
                                  await value.docs.first.reference.update(<String, dynamic>{"categoryProductsCount": value.docs.first.get("categoryProductsCount") - product.productQuantity});
                                },
                              );
                              await FirebaseFirestore.instance.collection("stores").where("storeID", isEqualTo: product.storeID).limit(1).get().then(
                                (QuerySnapshot<Map<String, dynamic>> value) async {
                                  await value.docs.first.reference.update(<String, dynamic>{"storeTotalProducts": value.docs.first.get("storeTotalProducts") - product.productQuantity});
                                },
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              showToast(context, "Produit supprimé", greenColor);
                            },
                            child: Text("CONFIRMER", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("ANNULER", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(FontAwesome.x_solid, color: redColor, size: 15),
              ),
            ],
          ),
        ),
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
    for (final product in products) {
      product.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? products.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;
