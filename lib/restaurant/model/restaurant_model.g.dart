// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) =>
    RestaurantModel(
      id: json['id'] as String,
      priceRange: $enumDecode(_$RestauntPriceRangeEnumMap, json['priceRange']),
      name: json['name'] as String,
      thumbUrl: DataUtils.pathToUrl(json['thumbUrl'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      ratings: (json['ratings'] as num).toDouble(),
      ratingsCount: json['ratingsCount'] as int,
      deliveryTime: json['deliveryTime'] as int,
      deliveryFee: json['deliveryFee'] as int,
    );

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbUrl': instance.thumbUrl,
      'priceRange': _$RestauntPriceRangeEnumMap[instance.priceRange]!,
      'tags': instance.tags,
      'ratings': instance.ratings,
      'ratingsCount': instance.ratingsCount,
      'deliveryTime': instance.deliveryTime,
      'deliveryFee': instance.deliveryFee,
    };

const _$RestauntPriceRangeEnumMap = {
  RestauntPriceRange.expensive: 'expensive',
  RestauntPriceRange.medium: 'medium',
  RestauntPriceRange.cheap: 'cheap',
};
