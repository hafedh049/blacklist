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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.all(24),
        color: darkColor,
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(column, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                        const SizedBox(width: 10),
                        const Icon(FontAwesome.sort_solid, size: 15, color: purpleColor),
                        const SizedBox(width: 60),
                      ],
                      Text("ACTION", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                    ],
                  ),
                ),
                Container(width: MediaQuery.sizeOf(context).width, height: .5, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                    itemCount: 1000,
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
