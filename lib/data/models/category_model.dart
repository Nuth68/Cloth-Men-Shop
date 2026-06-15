class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}
