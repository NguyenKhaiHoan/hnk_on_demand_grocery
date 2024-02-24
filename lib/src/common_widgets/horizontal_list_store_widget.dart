import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HorizontalListStoreWidget extends StatelessWidget {
  const HorizontalListStoreWidget(
      {super.key, required this.list, required this.title});

  final List<StoreModel> list;
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
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length > 10 ? 10 : list.length,
              itemBuilder: (BuildContext context, index) {
                return StoreItemWidget(
                  model: list[index],
                );
              },
            ))
      ],
    );
  }
}
