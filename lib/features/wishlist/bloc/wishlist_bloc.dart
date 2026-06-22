import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(const WishlistInitial()) {
    on<AddToWishlist>(_onAdd);
    on<RemoveFromWishlist>(_onRemove);
  }

  void _onAdd(AddToWishlist event, Emitter<WishlistState> emit) {
    if (state is WishlistUpdated) {
      final products = [...(state as WishlistUpdated).products, event.product];
      emit(WishlistUpdated(products));
    } else {
      emit(WishlistUpdated([event.product]));
    }
  }

  void _onRemove(RemoveFromWishlist event, Emitter<WishlistState> emit) {
    if (state is WishlistUpdated) {
      final products = (state as WishlistUpdated).products.where((p) => p.id != event.productId).toList();
      emit(products.isEmpty ? const WishlistInitial() : WishlistUpdated(products));
    }
  }
}
