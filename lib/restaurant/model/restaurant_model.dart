import 'package:code_mid/common/const/data.dart';
import 'package:code_mid/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'restaurant_model.g.dart';

enum RestauntPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final RestauntPriceRange priceRange;
  final List<String> tags;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.priceRange,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
}
