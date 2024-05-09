import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';

class HorizontalListProductWidget extends StatelessWidget {
  HorizontalListProductWidget(
      {super.key,
      required this.list,
      required this.compare,
      this.quantity,
      this.modelCompare,
      this.wishlistCheck,
      this.wishlist});

  final List<ProductModel> list;
  final bool compare;
  final int? quantity;
  final ProductModel? modelCompare;
  final bool? wishlistCheck;
  final WishlistModel? wishlist;

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 305,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: list.length > 10 ? 10 : list.length,
          itemBuilder: (BuildContext context, indexPrivate) {
            String differentText = "";
            String compareOperator = "";
            String comparePrice = "";
            var model = list[indexPrivate];
            if (compare) {
              if (model.salePersent == 0) {
                differentText = cartController.calculatingDifference(
                    model, modelCompare!.price);
                compareOperator = cartController.comparePrice(differentText);
                comparePrice = cartController.comparePriceNumber(differentText);
              } else {
                differentText = cartController.calculatingDifference(
                    model, modelCompare!.price);
                compareOperator = cartController.comparePrice(differentText);
                comparePrice = cartController.comparePriceNumber(differentText);
              }
              return ProductItemWidget(
                model: list[indexPrivate],
                compare: compare,
                modelCompare: modelCompare,
                differentText: differentText,
                compareOperator: compareOperator,
                comparePrice: comparePrice,
                quantity: quantity,
              );
            }
            if (wishlist != null ||
                (wishlistCheck != null && !wishlistCheck!)) {
              print('Vào các sản phẩm wishlist');
              return ProductItemWidget(
                model: list[indexPrivate],
                compare: compare,
                wishlistCheck: wishlistCheck,
                wishlist: wishlist,
              );
            }
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
            return const ShimmerProductItemWidget();
          },
          separatorBuilder: (BuildContext context, int index) => gapW10,
        ));
  }
}
