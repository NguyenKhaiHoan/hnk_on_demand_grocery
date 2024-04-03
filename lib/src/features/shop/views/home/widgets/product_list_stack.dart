import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class ProductListStackWidget extends StatelessWidget {
  const ProductListStackWidget({
    super.key,
    required this.items,
    this.maxItems = 5,
    this.stackHeight = 60,
  });

  final List<ProductModel> items;
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
                      child: ProductItemStack(model: items[index]),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset((index) * 40, 0),
                      child: index < maxItems - 1
                          ? ProductItemStack(model: items[index])
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
  ProductItemStack({
    super.key,
    required this.model,
    this.child,
  });

  ProductModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HAppColor.hGreyColorShade300),
      padding: const EdgeInsets.all(2),
      child: Container(
        alignment: Alignment.bottomLeft,
        // padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(model.image), fit: BoxFit.fill)),
      ),
    );
  }
}

class ProductInCartListStackWidget extends StatelessWidget {
  const ProductInCartListStackWidget({
    super.key,
    required this.items,
    this.maxItems = 5,
    this.stackHeight = 60,
  });

  final List<ProductInCartModel> items;
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
                      child: ProductInCartItemStack(model: items[index]),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset((index) * 40, 0),
                      child: index < maxItems - 1
                          ? ProductInCartItemStack(model: items[index])
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

class ProductInCartItemStack extends StatelessWidget {
  ProductInCartItemStack({
    super.key,
    required this.model,
    this.child,
  });

  ProductInCartModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HAppColor.hGreyColorShade300),
      padding: const EdgeInsets.all(2),
      child: Container(
        alignment: Alignment.bottomLeft,
        // padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(model.image!), fit: BoxFit.fill)),
        child: RoundedBackgroundText(
          'x${model.quantity}',
          style: HAppStyle.paragraph3Bold.copyWith(
            color: HAppColor.hWhiteColor,
          ),
          backgroundColor: HAppColor.hBluePrimaryColor,
        ),
      ),
    );
  }
}
