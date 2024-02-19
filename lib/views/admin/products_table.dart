import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/helpers/data_sources.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

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
  final List<String> _columns = const <String>["Date", "Reference", "Name", "Category", "Real Price", "New Price", "Quantity", "Stock Alert", "Actions"];
  final GlobalKey<State> _pager = GlobalKey<State>();

  @override
  String get restorationId => 'paginated_product_table';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_productSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');

    if (!_initialized) {
      _productsDataSource = ProductDataSource(context, true, true, true, true);
      _initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _productsDataSource.sort<DateTime>((Product p) => p.date, _sortAscending.value);
        break;
      case 1:
        _productsDataSource.sort<String>((Product p) => p.reference, _sortAscending.value);
        break;
      case 2:
        _productsDataSource.sort<String>((Product p) => p.name, _sortAscending.value);
        break;
      case 3:
        _productsDataSource.sort<String>((Product p) => p.category, _sortAscending.value);
        break;
      case 4:
        _productsDataSource.sort<num>((Product p) => p.realPrice, _sortAscending.value);
        break;
      case 5:
        _productsDataSource.sort<num>((Product p) => p.newPrice, _sortAscending.value);
        break;
      case 6:
        _productsDataSource.sort<num>((Product p) => p.quantity, _sortAscending.value);
        break;
      case 7:
        _productsDataSource.sort<num>((Product p) => p.stockAlert, _sortAscending.value);
        break;
      default:
        break;
    }
    _productsDataSource.updateSelectedProducts(_productSelections);
    _productsDataSource.addListener(_updateSelectedproductRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _productsDataSource = ProductDataSource(context);
      _initialized = true;
    }
    _productsDataSource.addListener(_updateSelectedproductRowListener);
  }

  void _updateSelectedproductRowListener() {
    _productSelections.setProductSelections(_productsDataSource.products);
  }

  void sort<T>(Comparable<T> Function(Product p) getField, int columnIndex, bool ascending) {
    _productsDataSource.sort<T>(getField, ascending);
    _pager.currentState!.setState(
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
            Expanded(
              child: ListView(
                restorationId: 'paginated_data_table_list_view',
                children: <Widget>[
                  StatefulBuilder(
                    key: _pager,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return PaginatedDataTable(
                        availableRowsPerPage: const <int>[20, 30],
                        arrowHeadColor: purpleColor,
                        rowsPerPage: _rowsPerPage.value,
                        onRowsPerPageChanged: (int? value) {
                          _(
                            () {
                              _rowsPerPage.value = value!;
                            },
                          );
                        },
                        initialFirstRowIndex: _rowIndex.value,
                        onPageChanged: (int rowIndex) {
                          _(
                            () {
                              _rowIndex.value = rowIndex;
                            },
                          );
                        },
                        sortColumnIndex: _sortColumnIndex.value,
                        sortAscending: _sortAscending.value,
                        onSelectAll: _productsDataSource.selectAll,
                        columns: <DataColumn>[
                          for (final String column in _columns)
                            DataColumn(
                              label: Text(column),
                              onSort: (int columnIndex, bool ascending) => sort<String>((Product p) => p.name, columnIndex, ascending),
                            ),
                        ],
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
