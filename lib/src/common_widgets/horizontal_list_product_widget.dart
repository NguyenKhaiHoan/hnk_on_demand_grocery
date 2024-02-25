import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';

class HorizontalListProductWidget extends StatelessWidget {
  const HorizontalListProductWidget({
    super.key,
    required this.list,
    required this.storeIcon,
    required this.compare,
  });

  final RxList<ProductModel> list;
  final bool storeIcon;
  final bool compare;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 305,
        child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length > 10 ? 10 : list.length,
              itemBuilder: (BuildContext context, indexPrivate) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ProductItemWidget(
                    storeIcon: storeIcon,
                    model: list[indexPrivate],
                    list: list,
                    compare: compare,
                  ),
                );
              },
            )));
  }
}
