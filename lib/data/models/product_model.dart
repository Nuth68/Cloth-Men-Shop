class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final List<String> sizes;
  final List<String> colors;
  final String fit;
  final bool isNew;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.sizes = const [],
    this.colors = const [],
    this.fit = 'Regular',
    this.isNew = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['image_url'] as String,
        categoryId: json['category_id'] as String,
        sizes: List<String>.from(json['sizes'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
        fit: json['fit'] as String? ?? 'Regular',
        isNew: json['is_new'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
        'category_id': categoryId,
        'sizes': sizes,
        'colors': colors,
        'fit': fit,
        'is_new': isNew,
      };
}
