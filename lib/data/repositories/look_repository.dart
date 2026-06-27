import '../datasources/remote/graphql_service.dart';
import '../models/look_model.dart';

class LookRepository {
  final GraphqlService _gql;
  LookRepository(this._gql);

  Future<List<LookModel>> getLooks() async {
    final response = await _gql.query('''
      query GetLooks {
        looks {
          id title subtitle image tag height productId
        }
      }
    ''');
    if (response.errors?.isNotEmpty == true) return [];
    final list = response.data?['looks'] as List<dynamic>? ?? [];
    return list.map((j) => LookModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}
