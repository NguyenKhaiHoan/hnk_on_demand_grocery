import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_widget.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HorizontalListProductWithTitleWidget extends StatelessWidget {
  const HorizontalListProductWithTitleWidget(
      {super.key,
      required this.list,
      required this.compare,
      required this.storeIcon,
      required this.title});

  final List<ProductModel> list;
  final bool compare;
  final bool storeIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: HAppStyle.heading4Style,
        ),
        gapH12,
        HorizontalListProductWidget(list: list, compare: compare)
      ],
    );
  }
}
