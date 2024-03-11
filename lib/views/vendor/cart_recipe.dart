import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/auth/passphrase.dart';
import 'package:blacklist/views/vendor/anonymous_client.dart';
import 'package:blacklist/views/vendor/recepies/recepies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';

class CartRecepie extends StatefulWidget {
  const CartRecepie({super.key, required this.storeID});
  final String storeID;
  @override
  State<CartRecepie> createState() => _CartRecepieState();
}

class _CartRecepieState extends State<CartRecepie> {
  late final List<Map<String, dynamic>> _items;

  @override
  void initState() {
    _items = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "Panier",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AnonymousClient(storeID: widget.storeID))),
      },
      <String, dynamic>{
        "title": "Recette",
        "callback": () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Recepies())),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("ACCEUIL", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                AnimatedButton(
                  width: 150,
                  height: 40,
                  text: 'QUITTER',
                  selectedTextColor: darkColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: greyColor,
                  backgroundColor: greyColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Passphrase())),
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (final Map<String, dynamic> item in _items) ...<Widget>[
                      InkWell(
                        onTap: item["callback"],
                        hoverColor: transparentColor,
                        splashColor: transparentColor,
                        highlightColor: transparentColor,
                        child: AnimatedLoadingBorder(
                          borderWidth: 4,
                          borderColor: purpleColor,
                          child: Container(
                            width: 200,
                            height: 150,
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(color: darkColor),
                            alignment: Alignment.center,
                            child: Text(item["title"], style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: whiteColor)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
