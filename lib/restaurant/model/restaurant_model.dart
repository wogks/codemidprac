import 'package:code_mid/common/const/data.dart';

enum RestauntPriceRange {
  expensive,
  medium,
  cheap,
}

class RestaurantModel {
  final String id;
  final String name;
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

  factory RestaurantModel.fromJson({required Map<String, dynamic> json}) =>
      RestaurantModel(
        id: json['id'],
        name: json['name'],
        thumbUrl: 'http://$ip${json['thumbUrl']}',
        tags: List<String>.from(json['tags']),
        ratings: json['ratings'],
        ratingsCount: json['ratingsCount'],
        deliveryTime: json['deliveryTime'],
        deliveryFee: json['deliveryFee'],
        priceRange: RestauntPriceRange.values.firstWhere(
          (element) => element.name == json['priceRange'],
        ),
      );
}
