class ProductModel {
  String productName;
  String productCategory;
  String categoryID;
  double realPrice;
  double newPrice;
  String productReference;
  bool stockAlert;
  DateTime date;

  ProductModel({
    required this.categoryID,
    required this.date,
    required this.productName,
    required this.productCategory,
    required this.realPrice,
    required this.newPrice,
    required this.productReference,
    required this.stockAlert,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryID: json["categoryID"],
      date: json["date"].toDate(),
      productName: json['productName'],
      productCategory: json['productCategory'],
      realPrice: json['realPrice'].toDouble(),
      newPrice: json['newPrice'].toDouble(),
      productReference: json['productReference'],
      stockAlert: json['stockAlert'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "categoryID": categoryID,
      "date": date,
      'productName': productName,
      'productCategory': productCategory,
      'realPrice': realPrice,
      'newPrice': newPrice,
      'productReference': productReference,
      'stockAlert': stockAlert,
    };
  }
}
