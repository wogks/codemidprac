import 'package:code_mid/common/component/pagination_list_view.dart';
import 'package:code_mid/order/component/order_card.dart';
import 'package:code_mid/order/model/order_model.dart';
import 'package:code_mid/order/provider/order_provder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
