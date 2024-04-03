import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HorizontalListProductWithTitleWidget extends StatelessWidget {
  const HorizontalListProductWithTitleWidget(
      {super.key,
      required this.list,
      required this.compare,
      required this.storeIcon,
      required this.title,
      this.function});

  final List<ProductModel> list;
  final bool compare;
  final bool storeIcon;
  final String title;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            title,
            style: HAppStyle.heading4Style,
          ),
          function != null
              ? GestureDetector(
                  onTap: function,
                  child: Text(
                    'Xem tất cả',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hBluePrimaryColor),
                  ),
                )
              : Container()
        ]),
        gapH12,
        HorizontalListProductWidget(list: list, compare: compare)
      ],
    );
  }
}

class ShimmerHorizontalListProductWithTitleWidget extends StatelessWidget {
  const ShimmerHorizontalListProductWithTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomShimmerWidget.rectangular(
            height: 14,
            width: 30,
          ),
          CustomShimmerWidget.rectangular(
            height: 14,
            width: 20,
          )
        ]),
        gapH12,
        const ShimmerHorizontalListProductWidget()
      ],
    );
  }
}
