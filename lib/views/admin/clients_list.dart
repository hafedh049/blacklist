import 'package:blacklist/models/client_model.dart';
import 'package:blacklist/utils/helpers/errored.dart';
import 'package:blacklist/utils/helpers/loading.dart';
import 'package:blacklist/views/admin/clients_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../utils/shared.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({super.key, required this.storeID});
  final String storeID;
  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  List<ClientModel> _clients = <ClientModel>[];
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
                Text("Clients", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: greyColor)),
                const Spacer(),
              ],
            ),
            Container(width: MediaQuery.sizeOf(context).width, height: .3, color: greyColor, margin: const EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection("clients").where("storesID", arrayContains: widget.storeID).get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      _clients = snapshot.data!.docs.map((e) => ClientModel.fromJson(e.data())).toList();
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) => InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ClientsProducts(clientID: _clients[index].clientCIN))),
                          hoverColor: transparentColor,
                          splashColor: transparentColor,
                          highlightColor: transparentColor,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
                            width: 250,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              runSpacing: 20,
                              spacing: 20,
                              children: <Widget>[
                                SizedBox(
                                  width: 250,
                                  child: PrettyQrView.data(
                                    data: _clients[index].toString(),
                                    decoration: const PrettyQrDecoration(
                                      shape: PrettyQrSmoothSymbol(color: purpleColor),
                                      image: PrettyQrDecorationImage(image: AssetImage('assets/images/flutter.png'), fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                          child: Text("CLIENT NAME", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(_clients[index].clientName.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                          child: Text("CLIENT ID", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(_clients[index].clientCIN.toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                          child: Text("CLIENT BIRTHDATE".toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(formatDate(_clients[index].clientBirthdate, const <String>[DD, " / ", MM, " / ", yyyy]).toUpperCase(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                          child: Text("CLIENT PHONE", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(_clients[index].clientPhone, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(5)),
                                          child: Text("TOTAL PRODUCTS", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                                        ),
                                        const SizedBox(width: 10),
                                        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                            future: FirebaseFirestore.instance.collection("sells").where("clientID", isEqualTo: _clients[index].clientCIN).get(),
                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                              return Text(snapshot.hasData ? snapshot.data!.docs.length.toString() : "Wait ...", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor));
                                            }),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                        itemCount: _clients.length,
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else {
                      return Errored(error: snapshot.error.toString());
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
