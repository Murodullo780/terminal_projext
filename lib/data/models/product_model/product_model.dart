import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String name,
    @JsonKey(fromJson: double.parse) required double price,
    required int stock,
    required String category,
    @JsonKey(fromJson: double.parse) required double rating,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse) required DateTime createdAt,
    int? currentCount,
    List<String>? marks,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}
