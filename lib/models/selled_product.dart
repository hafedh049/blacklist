import 'package:blacklist/models/product_model.dart';

class SelledProductModel extends ProductModel {
  DateTime timestamp;

  SelledProductModel({
    required String productName,
    required String productCategory,
    required double realPrice,
    required double newPrice,
    required String productReference,
    required int stockAlert,
    required categoryID,
    required this.timestamp,
    required date,
    required productQuantity,
  }) : super(
          date: date,
          productQuantity: productQuantity,
          categoryID: categoryID,
          productName: productName,
          productCategory: productCategory,
          realPrice: realPrice,
          newPrice: newPrice,
          productReference: productReference,
          stockAlert: stockAlert,
        );

  factory SelledProductModel.fromJson(Map<String, dynamic> json) {
    return SelledProductModel(
      productQuantity: json["productQuantity"],
      productName: json['productName'],
      productCategory: json['productCategory'],
      realPrice: json['realPrice'].toDouble(),
      newPrice: json['newPrice'].toDouble(),
      productReference: json['productReference'],
      stockAlert: json['stockAlert'],
      timestamp: json['timestamp'].toDate(),
      categoryID: json["categoryID"],
      date: json["date"].toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['timestamp'] = timestamp;
    return data;
  }
}
