import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double total;
  final String status;
  final String address;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.address,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        items: (json['items'] as List)
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (json['total'] as num).toDouble(),
        status: json['status'] as String,
        address: json['address'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'status': status,
        'address': address,
        'created_at': createdAt.toIso8601String(),
      };
}
