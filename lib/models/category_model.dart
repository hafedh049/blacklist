class CategoryModel {
  String categoryID;
  String categoryName;
  int categoryArticlesCount;
  int categoryProductsCount;
  bool categoryState;
  String storeID;
  int gift;

  // Constructor
  CategoryModel({
    required this.categoryID,
    required this.storeID,
    required this.categoryName,
    required this.categoryArticlesCount,
    required this.categoryProductsCount,
    required this.categoryState,
    required this.gift, // Include gift in constructor
  });

  // Deserialization method from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      storeID: json["storeID"],
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      categoryArticlesCount: json['categoryArticlesCount'],
      categoryProductsCount: json['categoryProductsCount'],
      categoryState: json['categoryState'],
      gift: json['gift'], // Parse gift from JSON
    );
  }

  // Serialization method to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'storeID': storeID,
      'categoryID': categoryID,
      'categoryName': categoryName,
      'categoryArticlesCount': categoryArticlesCount,
      'categoryProductsCount': categoryProductsCount,
      'categoryState': categoryState,
      'gift': gift, // Include gift in JSON
    };
  }
}
