import '../models/product_model.dart';
import '../models/category_model.dart';
import '../datasources/remote/api_service.dart';

class ProductRepository {
  final ApiService _api;

  ProductRepository(this._api);

  Future<List<ProductModel>> getProducts() async {
    final data = await _api.get('/products');
    return (data as List).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ProductModel>> getNewArrivals() async {
    final data = await _api.get('/products/new');
    return (data as List).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final data = await _api.get('/products', queryParameters: {'category_id': categoryId});
    return (data as List).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ProductModel>> filterProducts({String? size, String? color, String? fit}) async {
    final params = <String, String>{};
    if (size != null) params['size'] = size;
    if (color != null) params['color'] = color;
    if (fit != null) params['fit'] = fit;
    final data = await _api.get('/products/filter', queryParameters: params);
    return (data as List).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final data = await _api.get('/categories');
    return (data as List).map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
