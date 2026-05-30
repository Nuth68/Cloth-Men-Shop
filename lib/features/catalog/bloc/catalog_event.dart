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
  const FilterCatalog({this.size, this.color, this.fit});
}
