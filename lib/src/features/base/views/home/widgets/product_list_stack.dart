import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProductListStackWidget extends StatelessWidget {
  const ProductListStackWidget({
    super.key,
    required this.items,
    this.maxItems = 5,
    this.stackHeight = 60,
  });

  final List<String> items;
  final int maxItems;
  final double stackHeight;

  @override
  Widget build(BuildContext context) {
    bool checkMax = items.length < maxItems;
    return SizedBox(
        height: stackHeight,
        child: Stack(
          children: List.generate(
            checkMax ? items.length : maxItems,
            (index) => checkMax
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset((index) * 40, 0),
                      child: ProductItemStack(imageUrl: items[index]),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset((index) * 40, 0),
                      child: index < maxItems - 1
                          ? ProductItemStack(imageUrl: items[index])
                          : Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HAppColor.hBackgroundColor),
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "+${(items.length - maxItems + 1)}",
                                    style: HAppStyle.paragraph2Regular,
                                  )))),
                    ),
                  ),
          ),
        ));
  }
}

class ProductItemStack extends StatelessWidget {
  const ProductItemStack({
    super.key,
    required this.imageUrl,
    this.child,
  });

  final String imageUrl;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HAppColor.hWhiteColor),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(imageUrl), fit: BoxFit.cover)),
        ));
  }
}
