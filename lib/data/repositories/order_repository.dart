import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../datasources/remote/graphql_service.dart';

const _cartItemFields = '''
  id product { id name description price imageUrl categoryId sizes colors fit isNew }
  quantity selectedSize selectedColor
''';

const _orderFields = '''
  id items { $_cartItemFields } total status address createdAt
''';

class OrderRepository {
  final GraphqlService _gql;

  OrderRepository(this._gql);

  Future<OrderModel> placeOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String address,
  }) async {
    const mutation = '''
      mutation CreateOrder(\$input: CreateOrderInput!) {
        createOrder(createOrderInput: \$input) { $_orderFields }
      }
    ''';
    final res = await _gql.mutate(mutation, variables: {
      'input': {
        'items': items,
        'total': total,
        'address': address,
      },
    });
    return OrderModel.fromJson(res.data!['createOrder'] as Map<String, dynamic>);
  }

  Future<List<OrderModel>> getOrders() async {
    const query = 'query Orders { orders { $_orderFields } }';
    final res = await _gql.query(query);
    final list = res.data!['orders'] as List<dynamic>;
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OrderModel> getOrderById(int id) async {
    const query = '''
      query Order(\$id: Int!) {
        order(id: \$id) { $_orderFields }
      }
    ''';
    final res = await _gql.query(query, variables: {'id': id});
    return OrderModel.fromJson(res.data!['order'] as Map<String, dynamic>);
  }
}
