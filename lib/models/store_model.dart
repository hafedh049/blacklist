class StoreModel {
  String storeID;
  String storeName;
  String storeState;
  String storeVendorName;
  String storeVendorPassword;
  int storeTotalProducts;

  StoreModel({
    required this.storeTotalProducts,
    required this.storeID,
    required this.storeName,
    required this.storeState,
    required this.storeVendorName,
    required this.storeVendorPassword,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeTotalProducts: json['storeTotalProducts'],
      storeID: json['storeID'],
      storeName: json['storeName'],
      storeState: json['storeState'],
      storeVendorName: json['storeVendorName'],
      storeVendorPassword: json['storeVendorPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeTotalProducts': storeTotalProducts,
      'storeID': storeID,
      'storeName': storeName,
      'storeState': storeState,
      'storeVendorName': storeVendorName,
      'storeVendorPassword': storeVendorPassword,
    };
  }
}
