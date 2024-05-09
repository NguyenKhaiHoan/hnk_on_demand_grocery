import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';

class ListProductExploreBuilder extends StatelessWidget {
  const ListProductExploreBuilder(
      {super.key, required this.list, required this.compare});
  final bool compare;

  final List<ProductModel> list;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 295,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProductItemWidget(
          model: list[index],
          compare: compare,
        );
      },
    );
  }
}

class ShimmerListProductExploreBuilder extends StatelessWidget {
  const ShimmerListProductExploreBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 295,
      ),
      itemBuilder: (BuildContext context, int index) {
        return const ShimmerProductItemWidget();
      },
    );
  }
}
