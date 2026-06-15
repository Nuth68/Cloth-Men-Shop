import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'].toString(),
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        selectedSize: json['selectedSize'] as String,
        selectedColor: json['selectedColor'] as String,
        quantity: json['quantity'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'selectedSize': selectedSize,
        'selectedColor': selectedColor,
        'quantity': quantity,
      };

  CartItemModel copyWith({int? quantity}) =>
      CartItemModel(id: id, product: product, selectedSize: selectedSize, selectedColor: selectedColor, quantity: quantity ?? this.quantity);
}
