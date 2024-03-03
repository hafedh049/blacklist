class StoreModel {
  String storeID;
  String storeName;
  String storeState;
  String storeVendorName;
  String storeVendorEmail;
  String storeVendorPassword;
  int storeTotalProducts;

  StoreModel({
    required this.storeTotalProducts,
    required this.storeID,
    required this.storeName,
    required this.storeState,
    required this.storeVendorName,
    required this.storeVendorEmail,
    required this.storeVendorPassword,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeTotalProducts: json['storeTotalProducts'],
      storeID: json['storeID'],
      storeName: json['storeName'],
      storeState: json['storeState'],
      storeVendorName: json['storeVendorName'],
      storeVendorEmail: json['storeVendorEmail'],
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
      'storeVendorEmail': storeVendorEmail,
      'storeVendorPassword': storeVendorPassword,
    };
  }
}
