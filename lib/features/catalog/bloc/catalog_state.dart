import '../../../data/models/product_model.dart';

abstract class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogLoaded extends CatalogState {
  final List<ProductModel> products;
  const CatalogLoaded(this.products);
}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
}
