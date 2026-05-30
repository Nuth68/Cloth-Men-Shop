abstract class WishlistState {
  const WishlistState();
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class WishlistUpdated extends WishlistState {
  final List<String> productIds;
  const WishlistUpdated(this.productIds);
}
