import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsManagement extends StatefulWidget {
  const ProductsManagement({super.key});

  @override
  State<ProductsManagement> createState() => _ProductsManagementState();
}

class _ProductsManagementState extends State<ProductsManagement> {
  bool _selectAll = false;
  final Map<String, List<dynamic>> _columns = <String, List<dynamic>>{
    "DATE": [],
    "REFERENCE": [],
    "PRODUCT NAME": [],
    "CATEGORY": [],
    "PRICE": [],
    "QUANTITY": [],
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(24),
        child: Column(
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
                      TextSpan(text: "Home", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
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
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[],
                      ),
                    )

                        /*Column(
                      mainAxisSize: MainAxisSize.min,
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
                            for (final String column in _columns)
                              Row(
                                children: <Widget>[
                                  Text(column, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                                  const SizedBox(width: 5),
                                  const Icon(Bootstrap.arrow_down_up, size: 15, color: purpleColor),
                                ],
                              ),
                          ],
                        ),
                        Container(width: MediaQuery.sizeOf(context).width, height: .5, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
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
                                  for (final String column in _columns) ...<Widget>[
                                    Text(column, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                                  ],
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                            itemCount: 1000,
                          ),
                        ),
                      ],
                    )*/
                        ;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
