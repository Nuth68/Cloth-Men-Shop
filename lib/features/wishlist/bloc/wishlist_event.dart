abstract class WishlistEvent {
  const WishlistEvent();
}

class AddToWishlist extends WishlistEvent {
  final String productId;
  const AddToWishlist(this.productId);
}

class RemoveFromWishlist extends WishlistEvent {
  final String productId;
  const RemoveFromWishlist(this.productId);
}
