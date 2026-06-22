import '../../../data/models/product_model.dart';

abstract class WishlistState {
  const WishlistState();
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class WishlistUpdated extends WishlistState {
  final List<ProductModel> products;
  const WishlistUpdated(this.products);
}
