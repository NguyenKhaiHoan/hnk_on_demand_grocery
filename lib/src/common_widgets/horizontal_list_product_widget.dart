import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HorizontalListProductWidget extends StatelessWidget {
  const HorizontalListProductWidget(
      {super.key,
      required this.list,
      required this.compare,
      required this.storeIcon,
      required this.title});

  final RxList<ProductModel> list;
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
        SizedBox(
            width: double.infinity,
            height: 305,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length > 10 ? 10 : list.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ProductItemWidget(
                        storeIcon: storeIcon,
                        model: list[index],
                        list: list,
                        compare: compare,
                      ),
                    );
                  },
                )))
      ],
    );
  }
}
