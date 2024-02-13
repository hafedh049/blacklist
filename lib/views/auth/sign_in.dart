import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _adminState = false;
  bool _vendorState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("SIGN IN", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Home", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: purpleColor)),
                      TextSpan(text: " / Sign In", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor)),
                    ],
                  ),
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return AnimatedPadding(
                        duration: 300.ms,
                        padding: EdgeInsets.only(bottom: _adminState ? 10 : 0),
                        child: InkWell(
                          splashColor: transparentColor,
                          highlightColor: transparentColor,
                          hoverColor: transparentColor,
                          onTap: () {},
                          onHover: (bool value) => _(() => _adminState = value),
                          child: AnimatedContainer(
                            duration: 300.ms,
                            alignment: Alignment.center,
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(color: _adminState ? purpleColor.withOpacity(.1) : darkColor, borderRadius: BorderRadius.circular(15)),
                            child: Text("ADMIN", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: greyColor)),
                          ),
                        ),
                      );
                    },
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return AnimatedPadding(
                        duration: 300.ms,
                        padding: EdgeInsets.only(bottom: _vendorState ? 10 : 0),
                        child: InkWell(
                          splashColor: transparentColor,
                          highlightColor: transparentColor,
                          hoverColor: transparentColor,
                          onTap: () {},
                          onHover: (bool value) => _(() => _vendorState = value),
                          child: AnimatedContainer(
                            duration: 300.ms,
                            alignment: Alignment.center,
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(color: _vendorState ? purpleColor.withOpacity(.1) : darkColor, borderRadius: BorderRadius.circular(15)),
                            child: Text("VENDOR", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: greyColor)),
                          ),
                        ),
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
