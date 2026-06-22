import '../../../data/models/cart_item_model.dart';

abstract class CartEvent {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final CartItemModel item;
  const AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String itemId;
  const RemoveFromCart(this.itemId);
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;
  const UpdateQuantity(this.itemId, this.quantity);
}

class ClearCart extends CartEvent {
  const ClearCart();
}
