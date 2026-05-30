import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_event.dart';
import 'orders_state.dart';
import '../../../data/repositories/order_repository.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _repository;

  OrdersBloc(this._repository) : super(const OrdersInitial()) {
    on<LoadOrders>(_onLoad);
  }

  Future<void> _onLoad(LoadOrders event, Emitter<OrdersState> emit) async {
    emit(const OrdersLoading());
    try {
      final orders = await _repository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
