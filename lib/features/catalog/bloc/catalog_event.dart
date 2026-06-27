abstract class CatalogEvent {
  const CatalogEvent();
}

class LoadCatalog extends CatalogEvent {
  const LoadCatalog();
}

class FilterCatalog extends CatalogEvent {
  final String? size;
  final String? color;
  final String? fit;
  final double minPrice;
  final double maxPrice;
  final List<String> brands;
  const FilterCatalog({
    this.size,
    this.color,
    this.fit,
    this.minPrice = 0,
    this.maxPrice = 500,
    this.brands = const [],
  });
}
