class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final List<String> sizes;
  final List<String> colors;
  final String brand;
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
    this.brand = 'Steav Fashion',
    this.fit = 'Regular',
    this.isNew = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        categoryId: json['categoryId'].toString(),
        sizes: List<String>.from(json['sizes'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
        brand: json['brand'] as String? ?? 'Steav Fashion',
        fit: json['fit'] as String? ?? 'Regular',
        isNew: json['isNew'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'categoryId': categoryId,
        'sizes': sizes,
        'colors': colors,
        'brand': brand,
        'fit': fit,
        'isNew': isNew,
      };
}
