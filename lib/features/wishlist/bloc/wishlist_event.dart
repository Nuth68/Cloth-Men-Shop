import '../../../data/models/product_model.dart';

abstract class WishlistEvent {
  const WishlistEvent();
}

class AddToWishlist extends WishlistEvent {
  final ProductModel product;
  const AddToWishlist(this.product);
}

class RemoveFromWishlist extends WishlistEvent {
  final String productId;
  const RemoveFromWishlist(this.productId);
}
