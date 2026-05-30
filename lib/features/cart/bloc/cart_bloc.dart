import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../../data/models/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitial()) {
    on<AddToCart>(_onAdd);
    on<RemoveFromCart>(_onRemove);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  void _onAdd(AddToCart event, Emitter<CartState> emit) {
    final items = state is CartUpdated ? [...(state as CartUpdated).items] : <CartItemModel>[];
    final index = items.indexWhere((i) => i.id == event.item.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(event.item);
    }
    emit(CartUpdated(items));
  }

  void _onRemove(RemoveFromCart event, Emitter<CartState> emit) {
    if (state is CartUpdated) {
      final items = (state as CartUpdated).items.where((i) => i.id != event.itemId).toList();
      emit(items.isEmpty ? const CartInitial() : CartUpdated(items));
    }
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (state is CartUpdated) {
      final items = (state as CartUpdated).items.map((i) {
        return i.id == event.itemId ? i.copyWith(quantity: event.quantity) : i;
      }).toList();
      emit(CartUpdated(items));
    }
  }
}
