import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import '/views/vendor/vendor_data_sources.dart';

class VendorTable extends StatefulWidget {
  const VendorTable({super.key, required this.storeID, this.gift = false, this.clientID = "ANONYMOUS"});
  final String storeID;
  final bool gift;
  final String clientID;
  @override
  State<VendorTable> createState() => VendorTableState();
}

class VendorTableState extends State<VendorTable> with RestorationMixin {
  final RestorableProductSelections _productSelections = RestorableProductSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage + 10);
  late ProductDataSource _productsDataSource;
  bool _initialized = false;
  final List<String> _columns = const <String>["Name", "Quantity", "Date", "Reference", "Price"];
  final GlobalKey<State> _pagerKey = GlobalKey<State>();
  final GlobalKey<State> _searchKey = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();
  List<VendorProduct> _products = <VendorProduct>[];

  @override
  String get restorationId => 'paginated_product_table';

  @override
  void initState() {
    super.initState();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_productSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');

    if (!_initialized) {
      _productsDataSource = ProductDataSource(context, _products, true, true, true, true);
      _initialized = true;
    }
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

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _productsDataSource.removeListener(_updateSelectedproductRowListener);
    _productsDataSource.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<VendorProduct>> _load() async {
    final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").where("storeID", isEqualTo: widget.storeID).get();
    return query.docs.map(
      (QueryDocumentSnapshot<Map<String, dynamic>> e) {
        VendorProduct vp = VendorProduct.fromJson(e.data());
        if (widget.gift) {
          vp.newPrice = 0;
        }
        return vp;
      },
    ).toList();
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
                    Text("Products", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                    const SizedBox(height: 10),
                    AnimatedButton(
                      width: 150,
                      height: 40,
                      text: 'UPDATE',
                      selectedTextColor: darkColor,
                      animatedOn: AnimatedOn.onHover,
                      animationDuration: 500.ms,
                      isReverse: true,
                      selectedBackgroundColor: greenColor,
                      backgroundColor: purpleColor,
                      transitionType: TransitionType.TOP_TO_BOTTOM,
                      textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                      onPress: () async {
                        showToast("PLEASE WAIT", purpleColor);
                        final DateTime now = DateTime.now();
                        for (VendorProduct product in _productsDataSource.products) {
                          if (product.selected) {
                            final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").where("productReference", isEqualTo: product.productReference).limit(1).get();
                            await query.docs.first.reference.update(<String, dynamic>{"date": now, "productQuantity": product.productQuantity - int.parse(product.cartController.text)});
                            for (int index = 0; index < int.parse(product.cartController.text); index += 1) {
                              await FirebaseFirestore.instance.collection("sells").add(
                                    product.toJson()
                                      ..putIfAbsent("timestamp", () => now)
                                      ..putIfAbsent("clientID", () => widget.clientID),
                                  );
                              showToast("UPDATED SUCCESSFULLY", purpleColor);
                            }
                            product.productQuantity -= int.parse(product.cartController.text);
                            product.cartController.text = "0";
                            product.selected = false;
                          }
                        }
                        // ignore: use_build_context_synchronously
                        _pagerKey.currentState!.setState(() {
                          _productsDataSource = ProductDataSource(context, _productsDataSource.products);
                          _productsDataSource.updateSelectedProducts(_productSelections);
                        });
                        showToast("UPDATED COMPLETED", purpleColor);
                      },
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
                        _products.where((VendorProduct element) => element.productName.toLowerCase().startsWith(value.toLowerCase())).toList(),
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
              child: FutureBuilder<List<VendorProduct>>(
                future: _load(),
                builder: (BuildContext context, AsyncSnapshot<List<VendorProduct>> snapshot) {
                  if (snapshot.hasData) {
                    _products = snapshot.data!;
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
                              columns: <DataColumn>[for (final String column in _columns) DataColumn(label: Text(column))],
                              source: _productsDataSource,
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  } else {
                    return Errored(error: snapshot.error.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
