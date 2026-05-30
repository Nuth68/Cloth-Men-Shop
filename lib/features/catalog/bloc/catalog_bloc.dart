import 'package:flutter_bloc/flutter_bloc.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';
import '../../../data/repositories/product_repository.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ProductRepository _repository;

  CatalogBloc(this._repository) : super(const CatalogInitial()) {
    on<LoadCatalog>(_onLoad);
    on<FilterCatalog>(_onFilter);
  }

  Future<void> _onLoad(LoadCatalog event, Emitter<CatalogState> emit) async {
    emit(const CatalogLoading());
    try {
      final products = await _repository.getProducts();
      emit(CatalogLoaded(products));
    } catch (e) {
      emit(CatalogError(e.toString()));
    }
  }

  Future<void> _onFilter(FilterCatalog event, Emitter<CatalogState> emit) async {
    emit(const CatalogLoading());
    try {
      final products = await _repository.filterProducts(
        size: event.size,
        color: event.color,
        fit: event.fit,
      );
      emit(CatalogLoaded(products));
    } catch (e) {
      emit(CatalogError(e.toString()));
    }
  }
}
