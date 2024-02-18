import 'package:blacklist/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:data_table_2/data_table_2.dart';

class RestorableProductSelections extends RestorableProperty<Set<int>> {
  Set<int> _productSelections = <int>{};

  bool isSelected(int index) => _productSelections.contains(index);

  void setProductSelections(List<Product> products) {
    final Set<int> updatedSet = <int>{};
    for (int index = 0; index < products.length; index += 1) {
      Product product = products[index];
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

int _idCounter = 0;

class Product {
  Product(this.name, this.category, this.date, this.reference, this.realPrice, this.newPrice, this.quantity, this.stockAlert, this.actions);

  final int id = _idCounter++;

  final String name;
  final String category;
  final DateTime date;
  final String reference;
  final double realPrice;
  final double newPrice;
  final int quantity;
  final int stockAlert;
  final bool actions;
  bool selected = false;
}

class ProductDataSource extends DataTableSource {
  ProductDataSource.empty(this.context) {
    products = <Product>[];
  }

  ProductDataSource(this.context, [sortedByNames = false, this.hasRowTaps = false, this.hasRowHeightOverrides = false, this.hasZebraStripes = false]) {
    products = _products;
    if (sortedByNames) {
      sort((Product p) => p.name, true);
    }
  }

  final BuildContext context;
  late List<Product> products;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(Product p) getField, bool ascending) {
    products.sort(
      (Product a, Product b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
      },
    );
    notifyListeners();
  }

  void updateSelectedProducts(RestorableProductSelections selectedRows) {
    _selectedCount = 0;
    for (int index = 0; index < products.length; index += 1) {
      Product product = products[index];
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
    final Product product = products[index];
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
      onTap: hasRowTaps ? () => _showSnackbar(context, 'Tapped on row ${product.name}') : null,
      onDoubleTap: hasRowTaps ? () => _showSnackbar(context, 'Double Tapped on row ${product.name}') : null,
      onLongPress: hasRowTaps ? () => _showSnackbar(context, 'Long pressed on row ${product.name}') : null,
      onSecondaryTap: hasRowTaps ? () => _showSnackbar(context, 'Right clicked on row ${product.name}') : null,
      onSecondaryTapDown: hasRowTaps ? (d) => _showSnackbar(context, 'Right button down on row ${product.name}') : null,
      specificRowHeight: hasRowHeightOverrides && product.quantity >= 25 ? 100 : null,
      cells: <DataCell>[
        DataCell(Text(formatDate(product.date, <String>[yyyy, "-", MM, "-", dd]))),
        DataCell(Text(product.reference), onTap: () => _showSnackbar(context, 'Tapped on a cell with "${product.reference}"', Colors.red)),
        DataCell(Text(product.name)),
        DataCell(Text(product.category)),
        DataCell(Text(product.realPrice.toStringAsFixed(2))),
        DataCell(Text(product.newPrice.toStringAsFixed(2))),
        DataCell(Text(product.quantity.toString())),
        DataCell(Text(product.stockAlert.toString())),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesome.eye_solid, color: greenColor, size: 15),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesome.pen_solid, color: purpleColor, size: 15),
              ),
              IconButton(
                onPressed: () {},
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

List<Product> _products = <Product>[for (int index = 0; index < 100; index++) Product("P${index + 1}", "C${index + 1}", DateTime.now(), "Ref${index + 1}", 100, 150, 200, 20, true)];

_showSnackbar(BuildContext context, String text, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: 1.seconds,
      content: Text(text),
    ),
  );
}