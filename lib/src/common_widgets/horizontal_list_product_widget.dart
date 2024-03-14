import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';

class HorizontalListProductWidget extends StatelessWidget {
  const HorizontalListProductWidget({
    super.key,
    required this.list,
    required this.compare,
  });

  final List<ProductModel> list;
  final bool compare;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 305,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: list.length > 10 ? 10 : list.length,
          itemBuilder: (BuildContext context, indexPrivate) {
            return ProductItemWidget(
              model: list[indexPrivate],
              compare: compare,
            );
          },
          separatorBuilder: (BuildContext context, int index) => gapW10,
        ));
  }
}

class ShimmerHorizontalListProductWidget extends StatelessWidget {
  const ShimmerHorizontalListProductWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 305,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, indexPrivate) {
            return ShimmerProductItemWidget();
          },
          separatorBuilder: (BuildContext context, int index) => gapW10,
        ));
  }
}
