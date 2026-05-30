import '../../../data/models/cart_item_model.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartUpdated extends CartState {
  final List<CartItemModel> items;
  double get total => items.fold(0, (sum, item) => sum + item.totalPrice);

  const CartUpdated(this.items);
}
