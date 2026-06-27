class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String categoryId;
  final List<String> sizes;
  final List<String> colors;
  final String brand;
  final String fit;
  final bool isNew;
  final double rating;

  /// Convenience getter that returns the first image URL.
  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    String? imageUrl,
    List<String>? imageUrls,
    required this.categoryId,
    this.sizes = const [],
    this.colors = const [],
    this.brand = 'Steav Fashion',
    this.fit = 'Regular',
    this.isNew = false,
    this.rating = 0.0,
  }) : imageUrls = imageUrls ?? (imageUrl != null ? [imageUrl] : ['']);

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrls: json['imageUrls'] != null
            ? List<String>.from(json['imageUrls'])
            : null,
        imageUrl: json['imageUrl'] as String?,
        categoryId: json['categoryId'].toString(),
        sizes: List<String>.from(json['sizes'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
        brand: json['brand'] as String? ?? 'Steav Fashion',
        fit: json['fit'] as String? ?? 'Regular',
        isNew: json['isNew'] as bool? ?? false,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'imageUrls': imageUrls,
        'categoryId': categoryId,
        'sizes': sizes,
        'colors': colors,
        'brand': brand,
        'fit': fit,
        'isNew': isNew,
        'rating': rating,
      };
}
