import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/add_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../models/product_model.dart';
import 'data_sources.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({super.key, required this.storeID, required this.categoryID, required this.categoryName});
  final String categoryID;
  final String categoryName;
  final String storeID;

  @override
  State<ProductTable> createState() => ProductTableState();
}

class ProductTableState extends State<ProductTable> with RestorationMixin {
  final RestorableProductSelections _productSelections = RestorableProductSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage + 10);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late ProductDataSource _productsDataSource;
  bool _initialized = false;
  final List<String> _columns = const <String>["Nom", "Coût", "Prix", "Quantité", "Stock Alert", "Reference", "Date", "Actions"];
  final GlobalKey<State> _pagerKey = GlobalKey<State>();
  final GlobalKey<State> _searchKey = GlobalKey<State>();
  final GlobalKey<State> _futureKey = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _products = <ProductModel>[];

  @override
  String get restorationId => 'paginated_product_table';
  late final Map<int, void Function()> _map;

  @override
  void initState() {
    _map = <int, void Function()>{
      0: () => _productsDataSource.sort<DateTime>((ProductModel p) => p.date, _sortAscending.value),
      1: () => _productsDataSource.sort<String>((ProductModel p) => p.productReference, _sortAscending.value),
      2: () => _productsDataSource.sort<String>((ProductModel p) => p.productName, _sortAscending.value),
      3: () => _productsDataSource.sort<String>((ProductModel p) => p.productCategory, _sortAscending.value),
      4: () => _productsDataSource.sort<num>((ProductModel p) => p.realPrice, _sortAscending.value),
      5: () => _productsDataSource.sort<num>((ProductModel p) => p.newPrice, _sortAscending.value),
      6: () => _productsDataSource.sort<num>((ProductModel p) => p.productQuantity, _sortAscending.value),
      7: () => _productsDataSource.sort<num>((ProductModel p) => p.stockAlert, _sortAscending.value),
    };
    super.initState();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_productSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');

    if (!_initialized) {
      _productsDataSource = ProductDataSource(context, _products, true, true, true, true);
      _initialized = true;
    }
    _map[_sortColumnIndex.value];
    _productsDataSource.updateSelectedProducts(_productSelections);
    _productsDataSource.addListener(_updateSelectedproductRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _productsDataSource = ProductDataSource(context, _products);
      _initialized = true;
    }
    _productsDataSource.addListener(_updateSelectedproductRowListener);
  }

  void _updateSelectedproductRowListener() {
    _productSelections.setProductSelections(_productsDataSource.products);
  }

  void sort<T>(Comparable<T> Function(ProductModel p) getField, int columnIndex, bool ascending) {
    _productsDataSource.sort<T>(getField, ascending);
    _pagerKey.currentState!.setState(
      () {
        _sortColumnIndex.value = columnIndex;
        _sortAscending.value = ascending;
      },
    );
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _sortColumnIndex.dispose();
    _sortAscending.dispose();
    _productsDataSource.removeListener(_updateSelectedproductRowListener);
    _productsDataSource.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: purpleColor)),
                        const SizedBox(width: 10),
                        Text("Produits", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AnimatedButton(
                      width: 150,
                      height: 40,
                      text: 'AJOUTER',
                      selectedTextColor: darkColor,
                      animatedOn: AnimatedOn.onHover,
                      animationDuration: 500.ms,
                      isReverse: true,
                      selectedBackgroundColor: greenColor,
                      backgroundColor: purpleColor,
                      transitionType: TransitionType.TOP_TO_BOTTOM,
                      textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                      onPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AddProduct(
                            storeID: widget.storeID,
                            callback: () {
                              _futureKey.currentState!.setState(() {});
                            },
                            categoryName: widget.categoryName,
                            categoryID: widget.categoryID,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            StatefulBuilder(
              key: _searchKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return TextField(
                  controller: _searchController,
                  onChanged: (String value) {
                    _pagerKey.currentState!.setState(
                      () => _productsDataSource = ProductDataSource(
                        context,
                        _products.where((ProductModel element) => element.productName.toLowerCase().startsWith(value.toLowerCase())).toList(),
                        true,
                        true,
                        true,
                        true,
                      ),
                    );
                  },
                  style: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: purpleColor)),
                    contentPadding: const EdgeInsets.all(16),
                    hintText: "Recherche",
                    hintStyle: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500),
                    prefixIcon: const Icon(Icons.search, color: purpleColor, size: 25),
                    suffixIcon: IconButton(onPressed: () => _searchController.clear(), icon: const Icon(FontAwesome.x_solid, size: 18, color: purpleColor)),
                  ),
                );
              },
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: StatefulBuilder(
                key: _futureKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection("products").where("categoryID", isEqualTo: widget.categoryID).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        _products = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).toList();
                        _productsDataSource = ProductDataSource(context, _products, true, true, true, true);
                        return ListView(
                          restorationId: restorationId,
                          children: <Widget>[
                            StatefulBuilder(
                              key: _pagerKey,
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return PaginatedDataTable(
                                  availableRowsPerPage: const <int>[20, 30],
                                  arrowHeadColor: purpleColor,
                                  rowsPerPage: _rowsPerPage.value,
                                  onRowsPerPageChanged: (int? value) => _(() => _rowsPerPage.value = value!),
                                  initialFirstRowIndex: _rowIndex.value,
                                  onPageChanged: (int rowIndex) => _(() => _rowIndex.value = rowIndex),
                                  sortColumnIndex: _sortColumnIndex.value,
                                  sortAscending: _sortAscending.value,
                                  onSelectAll: _productsDataSource.selectAll,
                                  columns: <DataColumn>[for (final String column in _columns) DataColumn(label: Text(column), onSort: (int columnIndex, bool ascending) => _map[columnIndex])],
                                  source: _productsDataSource,
                                );
                              },
                            ),
                          ],
                        );
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loading();
                      }
                      return Errored(error: snapshot.error.toString());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
