import 'package:blacklist/utils/shared.dart';
import 'package:flutter/material.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  State<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  final Map<String,List<dynamic>> _data =<String,List<dynamic>>{
    'check':
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        color: darkColor,
        child:ListView.separated(itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(child: Row(children: <Widget>[],),);
        }, separatorBuilder: (BuildContext context,int index) {
          return Container(width: MediaQuery.sizeOf(context).width,height: .5,color: greyColor,margin: const EdgeInsets.symmetric(vertical: 20),);
        }, itemCount: 10,),
      ),
    );
  }
}
