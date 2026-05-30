import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class FilterBySizeUseCase {
  final ProductRepository _repository;
  FilterBySizeUseCase(this._repository);

  Future<List<ProductModel>> call(String size, {String? color, String? fit}) =>
      _repository.filterProducts(size: size, color: color, fit: fit);
}
