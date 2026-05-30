import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;
  GetProductsUseCase(this._repository);

  Future<List<ProductModel>> call() => _repository.getProducts();
}

class GetNewArrivalsUseCase {
  final ProductRepository _repository;
  GetNewArrivalsUseCase(this._repository);

  Future<List<ProductModel>> call() => _repository.getNewArrivals();
}
