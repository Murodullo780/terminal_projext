// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: double.parse(json['price'] as String),
      stock: (json['stock'] as num).toInt(),
      category: json['category'] as String,
      rating: double.parse(json['rating'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      currentCount: (json['currentCount'] as num?)?.toInt(),
      marks:
          (json['marks'] as List<dynamic>?)?.map((e) => e as String).toList(),
      barcodes:
          (json['barcode'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'stock': instance.stock,
      'category': instance.category,
      'rating': instance.rating,
      'created_at': instance.createdAt.toIso8601String(),
      'currentCount': instance.currentCount,
      'marks': instance.marks,
      'barcode': instance.barcodes,
    };
