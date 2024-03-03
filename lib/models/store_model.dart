class StoreModel {
  String storeID;
  String storeName;
  String storeState;
  String storeVendorName;
  String storeVendorEmail;
  String storeVendorPassword;
  String storeAdminEmail;
  String storeAdminPassword;

  // Constructeur
  StoreModel({
    required this.storeID,
    required this.storeName,
    required this.storeState,
    required this.storeVendorName,
    required this.storeVendorEmail,
    required this.storeVendorPassword,
    required this.storeAdminEmail,
    required this.storeAdminPassword,
  });

  // Méthode de désérialisation depuis JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeID: json['storeID'],
      storeName: json['storeName'],
      storeState: json['storeState'],
      storeVendorName: json['storeVendorName'],
      storeVendorEmail: json['storeVendorEmail'],
      storeVendorPassword: json['storeVendorPassword'],
      storeAdminEmail: json['storeAdminEmail'],
      storeAdminPassword: json['storeAdminPassword'],
    );
  }

  // Méthode de sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return {
      'storeID': storeID,
      'storeName': storeName,
      'storeState': storeState,
      'storeVendorName': storeVendorName,
      'storeVendorEmail': storeVendorEmail,
      'storeVendorPassword': storeVendorPassword,
      'storeAdminEmail': storeAdminEmail,
      'storeAdminPassword': storeAdminPassword,
    };
  }
}
