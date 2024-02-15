/*import 'package:blacklist/utils/shared.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/callbacks.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  State<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  bool _selectAll = false;
  final List<String> _columns = const <String>["CHECKBOX", "DATE", "REFERENCE", "PRODUCT NAME", "CATEGORY", "REAL PRICE", "NEW PRICE", "QUANTITY", "STOCK ALERT", "ACTIONS"];
  late final List<Map<String, dynamic>> _data;

  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final GlobalKey<State> _currentPageIndexKey = GlobalKey<State>();

  @override
  void initState() {
    _data = List<Map<String, dynamic>>.generate(1000, (int index) => <String, dynamic>{for (final String key in _columns) key: key});
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.all(24),
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("PRODUCTS LIST", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                    const Spacer(),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Dashboard", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                          TextSpan(text: " / Products List", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              final List<List<Map<String, dynamic>>> data = splitter(_data);
                              return PageView.builder(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (int value) => _currentPageIndexKey.currentState!.setState(() => _currentPageIndex = value),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return DataTable2(
                                    empty: null,
                                    isHorizontalScrollBarVisible: true,
                                    isVerticalScrollBarVisible: true,
                                    onSelectAll: (bool? value) {},
                                    showCheckboxColumn: true,
                                    columns: _columns
                                        .map(
                                          (String e) => DataColumn2(
                                            size: ColumnSize.L,
                                            fixedWidth: 60,
                                            tooltip: e,
                                            label: e == "CHECKBOX"
                                                ? Checkbox(
                                                    value: _selectAll,
                                                    checkColor: purpleColor,
                                                    onChanged: (bool? value) => setState(() => _selectAll = !_selectAll),
                                                  )
                                                : Text(e, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                                          ),
                                        )
                                        .toList(),
                                    rows: data[index]
                                        .map(
                                          (Map<String, dynamic> e) => DataRow2(
                                            specificRowHeight: 40,
                                            cells: e.keys
                                                .map(
                                                  (String e) => DataCell(
                                                    Text(e, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        )
                                        .toList(),
                                  );

                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        for (Map<String, dynamic> map in data[index]) ...<Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Checkbox(
                                                value: _selectAll,
                                                checkColor: purpleColor,
                                                onChanged: (bool? value) => setState(() => _selectAll = !_selectAll),
                                              ),
                                              const SizedBox(width: 30),
                                              for (final String key in map.keys) ...<Widget>[
                                                Text(key, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                                const SizedBox(width: 85),
                                              ],
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
                                                    icon: const Icon(FontAwesome.circle_xmark_solid, color: redColor, size: 15),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if (map != data[index].last) ...<Widget>[
                                            const SizedBox(height: 20),
                                            const Divider(thickness: .3, height: .3, color: greyColor),
                                            const SizedBox(height: 20),
                                          ],
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _pageController.previousPage(duration: 200.ms, curve: Curves.linear);
                      },
                      icon: const Icon(FontAwesome.chevron_left_solid, color: purpleColor, size: 15),
                    ),
                    StatefulBuilder(
                      key: _currentPageIndexKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Text((_currentPageIndex + 1).toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor));
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        _pageController.nextPage(duration: 200.ms, curve: Curves.linear);
                      },
                      icon: const Icon(FontAwesome.chevron_right_solid, color: purpleColor, size: 15),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}*/
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../data_sources.dart';
import '../nav_helper.dart';

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021

class DataTable2Demo extends StatefulWidget {
  const DataTable2Demo({super.key});

  @override
  DataTable2DemoState createState() => DataTable2DemoState();
}

class DataTable2DemoState extends State<DataTable2Demo> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late DessertDataSource _dessertsDataSource;
  bool _initialized = false;
  bool showCustomArrow = false;
  bool sortArrowsAlwaysVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final currentRouteOption = getCurrentRouteOption(context);
      _dessertsDataSource = DessertDataSource(context, false, currentRouteOption == rowTaps, currentRouteOption == rowHeightOverrides, currentRouteOption == showBordersWithZebraStripes);
      _initialized = true;
      _dessertsDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Dessert d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _dessertsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _dessertsDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const alwaysShowArrows = false;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Theme(
          // Using themes to override scroll bar appearence, note that iOS scrollbars do not support color overrides
          data: ThemeData(
              iconTheme: const IconThemeData(color: Colors.white),
              scrollbarTheme: ScrollbarThemeData(
                thickness: MaterialStateProperty.all(5),
                // thumbVisibility: MaterialStateProperty.all(true),
                // thumbColor: MaterialStateProperty.all<Color>(Colors.yellow)
              )),
          child: DataTable2(
            // Forcing all scrollbars to be visible, alternatively themes can be used (see above)
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[850]!),
            headingTextStyle: const TextStyle(color: Colors.white),
            headingCheckboxTheme: const CheckboxThemeData(side: BorderSide(color: Colors.white, width: 2.0)),
            //checkboxAlignment: Alignment.topLeft,
            isHorizontalScrollBarVisible: true,
            isVerticalScrollBarVisible: true,
            columnSpacing: 12,
            horizontalMargin: 12,
            sortArrowBuilder: getCurrentRouteOption(context) == custArrows
                ? (ascending, sorted) => sorted || alwaysShowArrows
                    ? Stack(
                        children: [
                          Padding(padding: const EdgeInsets.only(right: 0), child: _SortIcon(ascending: true, active: sorted && ascending)),
                          Padding(padding: const EdgeInsets.only(left: 10), child: _SortIcon(ascending: false, active: sorted && !ascending)),
                        ],
                      )
                    : null
                : null,
            border: getCurrentRouteOption(context) == fixedColumnWidth ? TableBorder(top: const BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.grey[300]!), left: BorderSide(color: Colors.grey[300]!), right: BorderSide(color: Colors.grey[300]!), verticalInside: BorderSide(color: Colors.grey[300]!), horizontalInside: const BorderSide(color: Colors.grey, width: 1)) : (getCurrentRouteOption(context) == showBordersWithZebraStripes ? TableBorder.all() : null),
            dividerThickness: 1, // this one will be ignored if [border] is set above
            bottomMargin: 10,
            minWidth: 900,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
            sortArrowAnimationDuration: const Duration(milliseconds: 500), // custom animation duration
            onSelectAll: (val) => setState(() => _dessertsDataSource.selectAll(val)),
            columns: [
              DataColumn2(
                label: const Text('Desert'),
                size: ColumnSize.S,
                // example of fixed 1st row
                fixedWidth: getCurrentRouteOption(context) == fixedColumnWidth ? 200 : null,
                onSort: (columnIndex, ascending) => _sort<String>((d) => d.name, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Calories'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.calories, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Fat (gm)'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.fat, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Carbs (gm)'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.carbs, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Protein (gm)'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.protein, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Sodium (mg)'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.sodium, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Calcium (%)'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.calcium, columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Iron (%)'),
                size: ColumnSize.S,
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>((d) => d.iron, columnIndex, ascending),
              ),
            ],
            empty: Center(child: Container(padding: const EdgeInsets.all(20), color: Colors.grey[200], child: const Text('No data'))),
            rows: getCurrentRouteOption(context) == noData ? [] : List<DataRow>.generate(_dessertsDataSource.rowCount, (index) => _dessertsDataSource.getRow(index)),
          )),
    );
  }
}

class _SortIcon extends StatelessWidget {
  final bool ascending;
  final bool active;

  const _SortIcon({required this.ascending, required this.active});

  @override
  Widget build(BuildContext context) {
    return Icon(
      ascending ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
      size: 28,
      color: active ? Colors.cyan : null,
    );
  }
}
