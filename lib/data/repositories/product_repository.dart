import '../models/product_model.dart';
import '../models/category_model.dart';
import '../datasources/remote/graphql_service.dart';

const _productFields = '''
  id name description price imageUrl categoryId sizes colors fit isNew
''';

class ProductRepository {
  final GraphqlService _gql;

  ProductRepository(this._gql);

  Future<List<ProductModel>> getProducts() async {
    const query = 'query Products { products { $_productFields } }';
    final res = await _gql.query(query);
    final list = res.data!['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getNewArrivals() async {
    const query = 'query NewArrivals { products(newArrivals: true) { $_productFields } }';
    final res = await _gql.query(query);
    final list = res.data!['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    const query = '''
      query ProductsByCategory(\$categoryId: Int) {
        products(categoryId: \$categoryId) { $_productFields }
      }
    ''';
    final res = await _gql.query(query, variables: {'categoryId': categoryId});
    final list = res.data!['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> filterProducts({
    String? size,
    String? color,
    String? fit,
    double minPrice = 0,
    double maxPrice = 500,
    List<String> brands = const [],
  }) async {
    const query = '''
      query FilterProducts(\$sizes: [String!], \$color: String, \$fit: String, \$minPrice: Float, \$maxPrice: Float, \$brands: [String!]) {
        products(sizes: \$sizes, color: \$color, fit: \$fit, minPrice: \$minPrice, maxPrice: \$maxPrice, brands: \$brands) { $_productFields }
      }
    ''';
    final res = await _gql.query(query, variables: {
      if (size != null) 'sizes': [size],
      if (color != null) 'color': color,
      if (fit != null) 'fit': fit,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      if (brands.isNotEmpty) 'brands': brands,
    });
    final list = res.data!['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    const query = 'query Categories { categories { id name imageUrl } }';
    final res = await _gql.query(query);
    final list = res.data!['categories'] as List<dynamic>;
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
