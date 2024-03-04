import 'package:blacklist/models/store_model.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/utils/helpers/add_store.dart';
import 'package:blacklist/utils/helpers/change_vendor_password.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/holder.dart';
import 'package:blacklist/views/auth/passphrase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

class StoresList extends StatefulWidget {
  const StoresList({super.key});

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  final GlobalKey<State> _storesKey = GlobalKey<State>();

  final List<StoreModel> _stores = <StoreModel>[];

  final Map<String, DocumentReference> _refs = <String, DocumentReference>{};

  Future<List<StoreModel>> _loadStores() async {
    try {
      return (await FirebaseFirestore.instance.collection("stores").get()).docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
        _refs[e.get("storeID")] = e.reference;
        return StoreModel.fromJson(e.data());
      }).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

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
                Text("Stores", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
                AnimatedButton(
                  width: 100,
                  height: 35,
                  text: 'ADD STORE',
                  selectedTextColor: darkColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: redColor,
                  backgroundColor: purpleColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () => showModalBottomSheet(context: context, builder: (BuildContext context) => AddStore(stores: _stores, callback: () => _storesKey.currentState!.setState(() {}))),
                ),
                const SizedBox(width: 20),
                AnimatedButton(
                  width: 100,
                  height: 35,
                  text: 'SIGN-OUT',
                  selectedTextColor: darkColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: redColor,
                  backgroundColor: purpleColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () async {
                    await FirebaseAuth.instance.signOut();
                    showToast("Bye Bye", redColor);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Passphrase()));
                  },
                ),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: Center(
                child: FutureBuilder<List<StoreModel>>(
                  future: _loadStores(),
                  builder: (BuildContext context, AsyncSnapshot<List<StoreModel>> snapshot) {
                    if (snapshot.hasData) {
                      _stores.addAll(snapshot.data!);
                      return StatefulBuilder(
                        key: _storesKey,
                        builder: (BuildContext context, void Function(void Function()) setS) => _stores.isEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  LottieBuilder.asset("assets/lotties/empty.json"),
                                  Text("No Stores Yet.", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  runSpacing: 20,
                                  spacing: 20,
                                  children: <Widget>[
                                    for (final StoreModel item in _stores)
                                      InkWell(
                                        splashColor: transparentColor,
                                        hoverColor: transparentColor,
                                        highlightColor: transparentColor,
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Holder(storeID: item.storeID))),
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Store", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item.storeName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Vendor", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item.storeVendorName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Total Products", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item.storeTotalProducts.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("State", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                        decoration: BoxDecoration(color: item.storeState.toUpperCase() == "OPEN" ? greenColor : redColor, borderRadius: BorderRadius.circular(5)),
                                                        padding: const EdgeInsets.all(4),
                                                        child: Text(item.storeState.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                                      ),
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
                                                        onPress: () async {
                                                          if (item.storeState != "open") {
                                                            await _refs[item.storeID]!.update(<String, dynamic>{"storeState": "open"});
                                                            showToast("Store opened", greenColor);
                                                            _storesKey.currentState!.setState(() => item.storeState = "open");
                                                          } else {
                                                            showToast("Store is already open", redColor);
                                                          }
                                                        },
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
                                                        onPress: () async {
                                                          if (item.storeState != "closed") {
                                                            await _refs[item.storeID]!.update(<String, dynamic>{"storeState": "closed"});
                                                            showToast("Store closed", greenColor);
                                                            _storesKey.currentState!.setState(() => item.storeState = "closed");
                                                          } else {
                                                            showToast("Store is already closed", redColor);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () => showModalBottomSheet(context: context, builder: (BuildContext context) => ChangeVendorPassword(storeID: item.storeID)),
                                                icon: const Icon(FontAwesome.user_secret_solid, size: 25, color: purpleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    }
                    return Errored(error: snapshot.error.toString());
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
