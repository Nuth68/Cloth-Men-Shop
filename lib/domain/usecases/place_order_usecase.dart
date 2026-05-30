import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository _repository;
  PlaceOrderUseCase(this._repository);

  Future<OrderModel> call({
    required List<Map<String, dynamic>> items,
    required double total,
    required String address,
  }) =>
      _repository.placeOrder(items: items, total: total, address: address);
}
