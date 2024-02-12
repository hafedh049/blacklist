import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  State<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  bool _selectAll = false;
  final List<String> _columns = const <String>["DATE", "REFERENCE", "PRODUCT NAME", "CATEGORY", "REAL PRICE", "NEW PRICE", "QUANTITY", "STOCK ALERT"];
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
                  scrollDirection: Axis.horizontal,
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
                      for (final String column in _columns) ...<Widget>[
                        Text(column, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                        const SizedBox(width: 10),
                        const Icon(FontAwesome.sort_solid, size: 15, color: greyColor),
                        const SizedBox(width: 60),
                      ],
                      Text("ACTION", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
                Container(width: MediaQuery.sizeOf(context).width, height: .5, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                Expanded(
                  child: Table(
                    border: const TableBorder(left: BorderSide.none, top: BorderSide.none, right: BorderSide.none),
                    children: <TableRow>[
                      for (int index = 0; index < 1000; index += 1)
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                              child: Checkbox(
                                value: _selectAll,
                                checkColor: purpleColor,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _selectAll = !_selectAll;
                                  });
                                },
                              ),
                            ),
                            for (final String column in _columns) TableCell(child: Text(column, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor))),
                            TableCell(
                              child: Row(
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
                            ),
                          ],
                        ),
                    ],
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
