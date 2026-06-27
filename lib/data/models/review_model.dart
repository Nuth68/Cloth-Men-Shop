class ReviewModel {
  final String id;
  final double rating;
  final String? title;
  final String? comment;
  final String? userName;
  final String? size;
  final String? color;
  final String? fitFeedback;
  final bool verifiedPurchase;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.rating,
    this.title,
    this.comment,
    this.userName,
    this.size,
    this.color,
    this.fitFeedback,
    this.verifiedPurchase = false,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['id'].toString(),
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    title: json['title'] as String?,
    comment: json['comment'] as String?,
    userName: json['userName'] as String? ?? json['user']?['name'] as String?,
    size: json['size'] as String?,
    color: json['color'] as String?,
    fitFeedback: json['fitFeedback'] as String? ?? json['fit_feedback'] as String?,
    verifiedPurchase: json['verifiedPurchase'] as bool? ?? false,
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'title': title,
    'comment': comment,
    'userName': userName,
    'size': size,
    'color': color,
    'fitFeedback': fitFeedback,
    'verifiedPurchase': verifiedPurchase,
  };
}
