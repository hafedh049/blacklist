import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  State<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  bool _selectAll = false;
  final List<String> _columns = const <String>["DATE", "REFERENCE", "PRODUCT NAME", "CATEGORY", "REAL PRICE", "NEW PRICE", "QUANTITY"];
  final Map<String, List<dynamic>> _data = <String, List<dynamic>>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        color: darkColor,
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: _selectAll,
                        checkColor: purpleColor,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectAll = !_selectAll;
                          });
                        },
                      ),
                      for(final String column in _columns)...<Widget>[  Text(column),,const SizedBox(width: 10),,const SizedBox(width: 30),],
                    ],
                  ),
                ),
                Container(width: MediaQuery.sizeOf(context).width, height: .5, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _selectAll,
                              checkColor: purpleColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _selectAll = !_selectAll;
                                });
                              },
                            ),
                            const SizedBox(width: 30),
                            Text("26/09/23"),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => Container(width: MediaQuery.sizeOf(context).width, height: .5, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                    itemCount: 10,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
