import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import '../../../data/repositories/order_repository.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository _repository;

  CheckoutBloc(this._repository) : super(const CheckoutInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<CheckoutState> emit) async {
    emit(const CheckoutLoading());
    try {
      await _repository.placeOrder(items: [], total: 0, address: event.address);
      emit(const CheckoutSuccess());
    } catch (e) {
      emit(CheckoutFailure(e.toString()));
    }
  }
}
