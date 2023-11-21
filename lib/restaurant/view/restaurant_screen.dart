import 'package:code_mid/common/const/data.dart';
import 'package:code_mid/common/dio/dio.dart';
import 'package:code_mid/restaurant/component/restaurant_card.dart';
import 'package:code_mid/restaurant/model/restaurant_model.dart';
import 'package:code_mid/restaurant/repository/restaurant_repository.dart';
import 'package:code_mid/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();
    dio.interceptors.add(CustomInterceptor(storage: storage));

    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return ListView.separated(
                itemBuilder: (_, index) {
                  final pItem = snapshot.data![index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailScreen(
                            id: pItem.id,
                          ),
                        ),
                      );
                    },
                    child: Restaurantcard.fromModel(
                      model: pItem,
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(height: 16);
                },
                itemCount: snapshot.data!.length,
              );
            },
          )),
    );
  }
}
