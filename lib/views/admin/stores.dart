import 'package:blacklist/models/store_model.dart';
import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/views/admin/add_store.dart';
import 'package:blacklist/utils/helpers/change_vendor_password.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/utils/shared.dart';
import 'package:blacklist/views/admin/delete_store.dart';
import 'package:blacklist/views/admin/drawer_holder.dart';
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
                  text: 'AJOUTER',
                  selectedTextColor: darkColor,
                  animatedOn: AnimatedOn.onHover,
                  animationDuration: 500.ms,
                  isReverse: true,
                  selectedBackgroundColor: redColor,
                  backgroundColor: purpleColor,
                  transitionType: TransitionType.TOP_TO_BOTTOM,
                  textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                  onPress: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(contentPadding: const EdgeInsets.all(16), content: AddStore(stores: _stores, callback: () => _storesKey.currentState!.setState(() {})))),
                ),
                const SizedBox(width: 20),
                AnimatedButton(
                  width: 100,
                  height: 35,
                  text: 'QUITTER',
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
                    // ignore: use_build_context_synchronously
                    showToast(context, "Au revoire", redColor);
                    // ignore: use_build_context_synchronously
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Passphrase()));
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
                                  Text("Pas de stores.", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
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
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawerHolder(storeID: item.storeID))),
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
                                                      Text("Vendeur", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Text(item.storeVendorName, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: greenColor)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Totale Produits", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                        stream: FirebaseFirestore.instance.collection("products").where("storeID", isEqualTo: item.storeID).snapshots(),
                                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                                          if (snapshot.hasData) {
                                                            int totalProducts = 0;
                                                            for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.data!.docs) {
                                                              totalProducts += (doc.get("productQuantity") as int);
                                                            }
                                                            return Text(totalProducts.toString(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor));
                                                          } else {
                                                            return Text("Attend", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: redColor));
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Etat", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                        decoration: BoxDecoration(color: item.storeState.toUpperCase() == "OUVERT" ? greenColor : redColor, borderRadius: BorderRadius.circular(5)),
                                                        padding: const EdgeInsets.all(4),
                                                        child: Text(item.storeState.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text("Accés", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: greyColor)),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      AnimatedButton(
                                                        width: 100,
                                                        height: 40,
                                                        text: 'OUVRIR',
                                                        selectedTextColor: darkColor,
                                                        animatedOn: AnimatedOn.onHover,
                                                        animationDuration: 500.ms,
                                                        isReverse: true,
                                                        selectedBackgroundColor: greenColor,
                                                        backgroundColor: purpleColor,
                                                        transitionType: TransitionType.TOP_TO_BOTTOM,
                                                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                                        onPress: () async {
                                                          if (item.storeState != "ouvert") {
                                                            await _refs[item.storeID]!.update(const <String, dynamic>{"storeState": "ouvert"});
                                                            // ignore: use_build_context_synchronously
                                                            showToast(context, "Store ouvert", greenColor);
                                                            _storesKey.currentState!.setState(() => item.storeState = "ouvert");
                                                          } else {
                                                            showToast(context, "Store est déja ouvert", redColor);
                                                          }
                                                        },
                                                      ),
                                                      const SizedBox(width: 20),
                                                      AnimatedButton(
                                                        width: 100,
                                                        height: 40,
                                                        text: 'FERMER',
                                                        selectedTextColor: darkColor,
                                                        animatedOn: AnimatedOn.onHover,
                                                        animationDuration: 500.ms,
                                                        isReverse: true,
                                                        selectedBackgroundColor: redColor,
                                                        backgroundColor: purpleColor,
                                                        transitionType: TransitionType.TOP_TO_BOTTOM,
                                                        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                                        onPress: () async {
                                                          if (item.storeState != "fermé") {
                                                            await _refs[item.storeID]!.update(const <String, dynamic>{"storeState": "fermé"});
                                                            // ignore: use_build_context_synchronously
                                                            showToast(context, "Store fermé", greenColor);
                                                            _storesKey.currentState!.setState(() => item.storeState = "fermé");
                                                          } else {
                                                            showToast(context, "Store est déja fermé", redColor);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  IconButton(
                                                    onPressed: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: ChangeVendorPassword(storeID: item.storeID))),
                                                    icon: const Icon(FontAwesome.key_solid, size: 25, color: purpleColor),
                                                  ),
                                                  IconButton(
                                                    onPressed: () => showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => AlertDialog(
                                                        content: DeleteStore(storeID: item.storeID, stores: _stores, callback: () => _storesKey.currentState!.setState(() {})),
                                                      ),
                                                    ),
                                                    icon: const Icon(FontAwesome.delete_left_solid, size: 25, color: purpleColor),
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
