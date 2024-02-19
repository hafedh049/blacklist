import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import '/views/vendor/vendor_data_sources.dart';

class VendorTable extends StatefulWidget {
  const VendorTable({super.key});

  @override
  State<VendorTable> createState() => VendorTableState();
}

class VendorTableState extends State<VendorTable> with RestorationMixin {
  final RestorableProductSelections _productSelections = RestorableProductSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage + 10);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late ProductDataSource _productsDataSource;
  bool _initialized = false;
  final List<String> _columns = const <String>["Date", "Reference", "Name", "Category", "New Price", "Quantity"];
  final GlobalKey<State> _pagerKey = GlobalKey<State>();
  final GlobalKey<State> _searchKey = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();
  final List<Product> _products = <Product>[for (int index = 0; index < 100; index++) Product("P${index + 1}", "C${index + 1}", DateTime.now(), "Ref${index + 1}", 100, 150)];

  @override
  String get restorationId => 'paginated_product_table';
  late final Map<int, void Function()> _map;

  @override
  void initState() {
    _map = <int, void Function()>{
      0: () => _productsDataSource.sort<DateTime>((Product p) => p.date, _sortAscending.value),
      1: () => _productsDataSource.sort<String>((Product p) => p.reference, _sortAscending.value),
      2: () => _productsDataSource.sort<String>((Product p) => p.name, _sortAscending.value),
      3: () => _productsDataSource.sort<String>((Product p) => p.category, _sortAscending.value),
      4: () => _productsDataSource.sort<num>((Product p) => p.newPrice, _sortAscending.value),
      5: () => _productsDataSource.sort<num>((Product p) => p.quantity, _sortAscending.value),
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

  void sort<T>(Comparable<T> Function(Product p) getField, int columnIndex, bool ascending) {
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
                Text("Products", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Products", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / List Products", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
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
                        _products.where((Product element) => element.name.toLowerCase().startsWith(value.toLowerCase())).toList(),
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
                    hintText: "Search Products",
                    hintStyle: GoogleFonts.itim(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500),
                    prefixIcon: const Icon(Icons.search, color: purpleColor, size: 25),
                    suffixIcon: IconButton(
                      onPressed: () => _searchController.clear(),
                      icon: const Icon(FontAwesome.x_solid, size: 18, color: purpleColor),
                    ),
                  ),
                );
              },
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: ListView(
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
                        columns: <DataColumn>[for (final String column in _columns) DataColumn(label: Text(column), onSort: (int columnIndex, bool ascending) => _map[columnIndex])],
                        source: _productsDataSource,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
