// ignore_for_file: use_build_context_synchronously

import 'package:code_mid/common/const/colors.dart';
import 'package:code_mid/common/layout/default_layout.dart';
import 'package:code_mid/order/provider/order_provder.dart';
import 'package:code_mid/order/view/order_done_screen.dart';
import 'package:code_mid/product/component/product_card.dart';
import 'package:code_mid/user/provider/bascket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String routeName = 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    if (basket.isEmpty) {
      return const DefaultLayout(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text('장바구니가 비었습니다!'))],
      ));
    }
    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 32,
                    );
                  },
                  itemCount: basket.length,
                  itemBuilder: (context, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '장바구니 금액',
                        style: TextStyle(color: PRIMARY_COLOR),
                      ),
                      Text(
                        '₩${basket.fold<int>(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              (element.product.price * element.count),
                        )}',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '배달비',
                        style: TextStyle(color: PRIMARY_COLOR),
                      ),
                      if (basket.isNotEmpty)
                        Text(basket[0]
                            .product
                            .restaurant
                            .deliveryFee
                            .toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '총액',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text((basket[0].product.restaurant.deliveryFee +
                              basket.fold<int>(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    (element.product.price * element.count),
                              ))
                          .toString())
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      onPressed: () async {
                        final res =
                            await ref.read(orderProvider.notifier).postOrder();
                        if (res) {
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('결제실패')));
                        }
                      },
                      child: const Text('결제하기'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
