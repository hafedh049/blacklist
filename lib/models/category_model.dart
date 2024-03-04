class CategoryModel {
  String categoryID;
  String categoryName;
  int categoryArticlesCount;
  int categoryProductsCount;
  bool categoryState;
  String storeID;

  // Constructeur
  CategoryModel({
    required this.categoryID,
    required this.storeID,
    required this.categoryName,
    required this.categoryArticlesCount,
    required this.categoryProductsCount,
    required this.categoryState,
  });

  // Méthode de désérialisation depuis JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      storeID: json["storeID"],
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      categoryArticlesCount: json['categoryArticlesCount'],
      categoryProductsCount: json['categoryProductsCount'],
      categoryState: json['categoryState'],
    );
  }

  // Méthode de sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'storeID': storeID,
      'categoryID': categoryID,
      'categoryName': categoryName,
      'categoryArticlesCount': categoryArticlesCount,
      'categoryProductsCount': categoryProductsCount,
      'categoryState': categoryState,
    };
  }
}
