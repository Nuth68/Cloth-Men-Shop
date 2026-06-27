class LookModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String tag;
  final double height;
  final int? productId;

  LookModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tag,
    this.height = 400,
    this.productId,
  });

  factory LookModel.fromJson(Map<String, dynamic> json) => LookModel(
    id: json['id'].toString(),
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    image: json['image'] as String,
    tag: json['tag'] as String,
    height: (json['height'] as num?)?.toDouble() ?? 400,
    productId: json['productId'] as int?,
  );
}
