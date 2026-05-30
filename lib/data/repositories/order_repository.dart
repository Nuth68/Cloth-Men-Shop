import '../models/order_model.dart';
import '../datasources/remote/api_service.dart';

class OrderRepository {
  final ApiService _api;

  OrderRepository(this._api);

  Future<OrderModel> placeOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String address,
  }) async {
    final data = await _api.post('/orders', body: {
      'items': items,
      'total': total,
      'address': address,
    });
    return OrderModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<OrderModel>> getOrders() async {
    final data = await _api.get('/orders');
    return (data as List).map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderModel> getOrderById(String id) async {
    final data = await _api.get('/orders/$id');
    return OrderModel.fromJson(data as Map<String, dynamic>);
  }
}
