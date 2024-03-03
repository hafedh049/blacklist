class CategoryModel {
  String categoryID;
  String categoryName;
  int categoryArticlesCount;
  int categoryProductsCount;
  bool categoryState;

  // Constructeur
  CategoryModel({
    required this.categoryID,
    required this.categoryName,
    required this.categoryArticlesCount,
    required this.categoryProductsCount,
    required this.categoryState,
  });

  // Méthode de désérialisation depuis JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
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
      'categoryID': categoryID,
      'categoryName': categoryName,
      'categoryArticlesCount': categoryArticlesCount,
      'categoryProductsCount': categoryProductsCount,
      'categoryState': categoryState,
    };
  }
}
