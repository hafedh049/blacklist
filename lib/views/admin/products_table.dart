import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
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
  final List<String> _columns = const <String>["DATE", "REFERENCE", "PRODUCT NAME", "CATEGORY", "REAL PRICE", "NEW PRICE", "QUANTITY", "STOCK ALERT"];
  late final List<Map<String, dynamic>> _data;

  final PageController _pageController = PageController();

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
                        Row(
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
                        Container(width: MediaQuery.sizeOf(context).width, height: .5, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                        Expanded(
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              final List<List<Map<String, dynamic>>> data = splitter(_data);
                              return PageView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (int value) {},
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
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
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(FontAwesome.chevron_left_solid, color: purpleColor, size: 15),
                            ),
                            Text(key, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(FontAwesome.chevron_right_solid, color: purpleColor, size: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
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
