part of 'product_catalog_bloc.dart';

@immutable
sealed class ProductCatalogState {}

final class ProductCatalogInitial extends ProductCatalogState {}

final class ProductCatalogLoading extends ProductCatalogState {}

final class ProductCatalogLoaded extends ProductCatalogState {
  final  List<ProductModel> data;

  ProductCatalogLoaded({required this.data});
}

final class ProductCatalogError extends ProductCatalogState {
  final String message;

  ProductCatalogError(this.message);
}
