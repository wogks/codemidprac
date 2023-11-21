import 'package:code_mid/common/const/data.dart';
import 'package:code_mid/common/dio/dio.dart';
import 'package:code_mid/common/layout/default_layout.dart';
import 'package:code_mid/product/component/product_card.dart';
import 'package:code_mid/restaurant/component/restaurant_card.dart';
import 'package:code_mid/restaurant/model/restaurant_detail_model.dart';
import 'package:code_mid/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  Future<RestaurantDetailModel> getRestaurantDetail(
      {required String id}) async {
    final dio = Dio();
    dio.interceptors.add(CustomInterceptor(storage: storage));
    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return await repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: 'sas',
        child: FutureBuilder<RestaurantDetailModel>(
          future: getRestaurantDetail(id: id),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            print(snapshot.error);
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return CustomScrollView(
              slivers: [
                renderTop(model: snapshot.data!),
                renderLabel(),
                renderProducts(product: snapshot.data!.products),
              ],
            );
          },
        ));
  }

  SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: Restaurantcard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts(
      {required List<RestaurantProductModel> product}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: product.length,
          (context, index) {
            final model = product[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.all(8.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
