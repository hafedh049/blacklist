import 'dart:math';

import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/dashboard/holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';

class StoresList extends StatefulWidget {
  const StoresList({super.key});

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  final List<Map<String, dynamic>> _stores = List<Map<String, dynamic>>.generate(20, (int index) => <String, dynamic>{"store_name": "Store ${index + 1}", "vendor_name": "Vendor ${index + 1}", "total_products": Random().nextInt(4000).toString()});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Stores", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: "Stores", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                        TextSpan(text: " / Add(Choose) store", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                      ],
                    ),
                  ),
                ],
              ),
              Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 20,
                  spacing: 20,
                  children: <Widget>[
                    for (final Map<String, dynamic> item in _stores)
                      InkWell(
                        splashColor: transparentColor,
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()));
                        },
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Store", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["store_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("Vendor", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["vendor_name"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("Total Products", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                  const SizedBox(width: 10),
                                  Text(item["total_products"], style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text("Vendor Acess", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  AnimatedButton(
                                    width: 100,
                                    height: 40,
                                    text: 'OPEN',
                                    selectedTextColor: darkColor,
                                    animatedOn: AnimatedOn.onHover,
                                    animationDuration: 500.ms,
                                    isReverse: true,
                                    selectedBackgroundColor: greenColor,
                                    backgroundColor: purpleColor,
                                    transitionType: TransitionType.TOP_TO_BOTTOM,
                                    textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                    onPress: () {},
                                  ),
                                  const SizedBox(width: 20),
                                  AnimatedButton(
                                    width: 100,
                                    height: 40,
                                    text: 'CLOSE',
                                    selectedTextColor: darkColor,
                                    animatedOn: AnimatedOn.onHover,
                                    animationDuration: 500.ms,
                                    isReverse: true,
                                    selectedBackgroundColor: redColor,
                                    backgroundColor: purpleColor,
                                    transitionType: TransitionType.TOP_TO_BOTTOM,
                                    textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                    onPress: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
