class CategoryModel {
  String name;
  int categoryId;

  CategoryModel({
    required this.categoryId,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json["category_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "name": name,
      };
}
