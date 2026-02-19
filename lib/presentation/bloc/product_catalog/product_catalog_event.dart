part of 'product_catalog_bloc.dart';

@immutable
sealed class ProductCatalogEvent {}

final class ProductCatalogGetEvent extends ProductCatalogEvent {}

final class ProductCatalogScanEvent extends ProductCatalogEvent {
  final ProductModel model;
  final String scanned;

  ProductCatalogScanEvent(this.scanned, this.model);
}

final class ProductCatalogAddEvent extends ProductCatalogEvent {
  final ProductModel model;
  final String mark;

  ProductCatalogAddEvent(this.model, this.mark);
}

final class ProductCatalogClearEvent extends ProductCatalogEvent {
  final ProductModel model;

  ProductCatalogClearEvent(this.model);
}

final class ProductCatalogSendEvent extends ProductCatalogEvent {}

final class ProductCatalogDeleteEvent extends ProductCatalogEvent {
  final ProductModel model;
  final String mark;

  ProductCatalogDeleteEvent(this.model, this.mark);
}

