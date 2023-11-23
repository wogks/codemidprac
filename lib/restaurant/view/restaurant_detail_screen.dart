import 'package:code_mid/common/layout/default_layout.dart';
import 'package:code_mid/common/model/cursor_pagination_model.dart';
import 'package:code_mid/common/utils/pagination_utils.dart';
import 'package:code_mid/product/component/product_card.dart';
import 'package:code_mid/rating/component/rating_card.dart';
import 'package:code_mid/rating/model/rating_model.dart';
import 'package:code_mid/restaurant/component/restaurant_card.dart';
import 'package:code_mid/restaurant/model/restaurant_detail_model.dart';
import 'package:code_mid/restaurant/model/restaurant_model.dart';
import 'package:code_mid/restaurant/provider/restaurant_provider.dart';
import 'package:code_mid/restaurant/provider/restaurant_rating_provider.dart';
import 'package:code_mid/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  listener() {
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantRatingProvider(widget.id).notifier));
  }

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return DefaultLayout(
      title: 'sas',
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(product: state.products),
          if (ratingState is CursorPagination<RatingModel>)
            renderRatings(model: ratingState.data),
        ],
      ),
    );
  }

  SliverPadding renderRatings({required List<RatingModel> model}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => RatingCard.fromModel(
                  model: model[index],
                ),
            childCount: model.length),
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: product.length,
          (context, index) {
            final model = product[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
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
