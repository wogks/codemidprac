import 'package:code_mid/product/model/product_model.dart';
import 'package:code_mid/user/model/basket_item_modek.dart';
import 'package:code_mid/user/model/patch_basket_body.dart';
import 'package:code_mid/user/repository/user_me_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);
    return BasketProvider(repository: repository);
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  BasketProvider({required this.repository}) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: PatchBasketBody(
      basket: state
          .map((e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ))
          .toList(),
    ));
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1) 아직 장바구니에 해당되는 상품이 없다면
    //    장바구니에 상품을 추가한다.
    // 2) 만약에 이미 들어있다면
    //    장바구니에 있는 값에 +1을 한다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // true면 count와 관계없이 아예 삭제한다.
    bool isDelete = false,
  }) async {
    // 1) 장바구니에 상품이 존재할때
    //    1) 상품의 카운트가 1보다 크면 -1한다.
    //    2) 상품의 카운트가 1이면 삭제한다.
    // 2) 상품이 존재하지 않을때
    //    즉시 함수를 반환하고 아무것도 하지 않는다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count - 1,
                  )
                : e,
          )
          .toList();
    }
    await patchBasket();
  }
}
