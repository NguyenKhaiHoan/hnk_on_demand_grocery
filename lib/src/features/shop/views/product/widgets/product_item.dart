import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemWidget(
      {super.key,
      required this.model,
      required this.compare,
      this.modelCompare,
      this.differentText,
      this.compareOperator,
      this.comparePrice,
      this.quantity,
      this.wishlistCheck,
      this.wishlist});
  final ProductModel model;
  final ProductModel? modelCompare;
  final bool compare;
  final String? differentText;
  final String? compareOperator;
  final String? comparePrice;
  final int? quantity;

  final productController = ProductController.instance;
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());

  var choose = false.obs;
  final bool? wishlistCheck;
  final WishlistModel? wishlist;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then(
      (value) {
        if (compare) {
          if (modelCompare != null) {
            choose.value =
                cartController.checkReplaceProduct(modelCompare!.id, model);
          } else {
            choose.value = wishlist!.listIds.contains(model.id);
          }
        }
      },
    );
    return GestureDetector(
      child: Stack(alignment: Alignment.bottomRight, children: [
        Container(
          width: 165,
          decoration: BoxDecoration(
              color: HAppColor.hWhiteColor,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                ImageNetwork(
                  image: model.image,
                  height: 165,
                  width: 165,
                  duration: 500,
                  curve: Curves.easeIn,
                  onPointer: true,
                  debugPrint: false,
                  fullScreen: false,
                  fitAndroidIos: BoxFit.fill,
                  fitWeb: BoxFitWeb.fill,
                  borderRadius: BorderRadius.circular(10),
                  onLoading: CustomShimmerWidget.rectangular(height: 165),
                  onError: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
                if (!compare)
                  model.salePersent != 0
                      ? Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HAppColor.hOrangeColor),
                            child: Text('${model.salePersent}%',
                                style: HAppStyle.label4Bold
                                    .copyWith(color: HAppColor.hWhiteColor)),
                          ),
                        )
                      : Container(),
                if (!compare)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => wishlistController
                          .addOrRemoveProductInFavoriteList(model.id),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: HAppColor.hBackgroundColor),
                        child: Center(
                            child: Obx(
                          () => !UserController
                                  .instance.user.value.listOfFavoriteProduct!
                                  .contains(model.id)
                              ? const Icon(
                                  EvaIcons.heartOutline,
                                  color: HAppColor.hGreyColor,
                                )
                              : const Icon(
                                  EvaIcons.heart,
                                  color: HAppColor.hRedColor,
                                ),
                        )),
                      ),
                    ),
                  ),
                if (!compare)
                  model.status != "Còn hàng"
                      ? Positioned(
                          bottom: 10,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5)),
                                color: HAppColor.hGreyColorShade300),
                            child: Center(
                                child: Text(
                              model.status,
                              style: HAppStyle.label4Regular,
                            )),
                          ),
                        )
                      : Container()
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!compare)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                                    CategoryController
                                        .instance
                                        .listOfCategory[
                                            int.parse(model.categoryId)]
                                        .name,
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600,
                                        overflow: TextOverflow.ellipsis))),
                            Text(model.unit,
                                style: HAppStyle.paragraph3Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600)),
                          ],
                        ),
                      gapH4,
                      Text(
                        model.name,
                        style: HAppStyle.label2Bold.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      gapH4,
                      if (!compare)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  EvaIcons.star,
                                  color: HAppColor.hOrangeColor,
                                  size: 16,
                                ),
                                gapW2,
                                Text.rich(
                                  TextSpan(
                                    style: HAppStyle.paragraph2Bold,
                                    text: model.rating.toStringAsFixed(1),
                                    children: [
                                      TextSpan(
                                        text: '/5',
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hGreyColorShade600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                style: HAppStyle.paragraph2Bold,
                                text: '${model.countBuyed} ',
                                children: [
                                  TextSpan(
                                    text: 'Đã bán',
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ]),
              ),
              const Spacer(),
              !compare
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 45,
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: model.salePersent == 0
                                ? Text(
                                    HAppUtils.vietNamCurrencyFormatting(
                                        model.price),
                                    style: HAppStyle.label2Bold.copyWith(
                                        color: HAppColor.hBluePrimaryColor),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          HAppUtils.vietNamCurrencyFormatting(
                                              model.price),
                                          style: HAppStyle.paragraph3Bold
                                              .copyWith(
                                                  color: HAppColor.hGreyColor,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                      Text(
                                          HAppUtils.vietNamCurrencyFormatting(
                                              model.priceSale),
                                          style: HAppStyle.label2Bold.copyWith(
                                              color: HAppColor.hOrangeColor,
                                              decoration: TextDecoration.none))
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: model.salePersent == 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          compareOperator == '>'
                                              ? const Icon(
                                                  EvaIcons
                                                      .diagonalArrowRightUpOutline,
                                                  color: HAppColor.hRedColor,
                                                  size: 20,
                                                )
                                              : compareOperator == "<"
                                                  ? const Icon(
                                                      EvaIcons
                                                          .diagonalArrowRightDownOutline,
                                                      color: Colors.greenAccent,
                                                      size: 20,
                                                    )
                                                  : Container(),
                                          gapW4,
                                          Text(
                                            compareOperator == "="
                                                ? "Ngang nhau"
                                                : "$comparePrice",
                                            style: HAppStyle.paragraph3Regular,
                                          )
                                        ],
                                      ),
                                      Text(
                                          HAppUtils.vietNamCurrencyFormatting(
                                              model.price),
                                          style: HAppStyle.label2Bold.copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor,
                                              decoration: TextDecoration.none))
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          compareOperator == '>'
                                              ? const Icon(
                                                  EvaIcons
                                                      .diagonalArrowRightUpOutline,
                                                  color: HAppColor.hRedColor,
                                                  size: 20,
                                                )
                                              : compareOperator == "<"
                                                  ? const Icon(
                                                      EvaIcons
                                                          .diagonalArrowRightDownOutline,
                                                      color: Colors.greenAccent,
                                                      size: 20,
                                                    )
                                                  : Container(),
                                          compareOperator == "="
                                              ? Container()
                                              : gapW4,
                                          Text(
                                            compareOperator == "="
                                                ? "Bằng giá"
                                                : "$comparePrice",
                                            style: HAppStyle.paragraph3Regular,
                                          )
                                        ],
                                      ),
                                      Text(
                                          HAppUtils.vietNamCurrencyFormatting(
                                              model.priceSale),
                                          style: HAppStyle.label2Bold.copyWith(
                                              color: HAppColor.hOrangeColor,
                                              decoration: TextDecoration.none))
                                    ],
                                  )),
                      ],
                    )
            ],
          ),
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: !compare
                ? wishlistCheck == null
                    ? Visibility(
                        visible: model.status == "Còn hàng" ? true : false,
                        child: Obx(() {
                          final productQuantityInCart =
                              cartController.getProductQuantity(model.id);
                          return AnimatedCrossFade(
                            crossFadeState:
                                cartController.toggleAnimation.value &&
                                        cartController.listIdToggleAnimation
                                            .contains(model.id)
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                            firstCurve: Curves.easeOutQuart,
                            secondCurve: Curves.easeOutQuart,
                            firstChild: Container(
                                height: 45,
                                width: 45,
                                decoration: const BoxDecoration(
                                  color: HAppColor.hBluePrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                    onTap: () async {
                                      cartController.animationButtonAdd(model);
                                      final cartProduct = cartController
                                          .convertToCartProduct(model, 1);
                                      await cartController
                                          .addSingleProductInCart(cartProduct);
                                    },
                                    child: productQuantityInCart > 0
                                        ? Center(
                                            child: Text(
                                              productQuantityInCart.toString(),
                                              style: HAppStyle.paragraph1Bold
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hWhiteColor),
                                            ),
                                          )
                                        : const Icon(
                                            EvaIcons.plus,
                                            color: HAppColor.hWhiteColor,
                                          ))),
                            secondChild: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: HAppColor.hBluePrimaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          cartController
                                              .animationButtonAdd(model);
                                          final cartProduct = cartController
                                              .convertToCartProduct(model, 1);
                                          cartController
                                              .removeSingleProductInCart(
                                                  cartProduct);
                                        },
                                        icon: const Icon(
                                          EvaIcons.minus,
                                          color: HAppColor.hWhiteColor,
                                        )),
                                    gapW4,
                                    Text(
                                      productQuantityInCart.toString(),
                                      style: HAppStyle.paragraph1Bold.copyWith(
                                          color: HAppColor.hWhiteColor),
                                    ),
                                    gapW4,
                                    IconButton(
                                        onPressed: () async {
                                          cartController
                                              .animationButtonAdd(model);
                                          final cartProduct = cartController
                                              .convertToCartProduct(model, 1);
                                          await cartController
                                              .addSingleProductInCart(
                                                  cartProduct);
                                        },
                                        icon: const Icon(
                                          EvaIcons.plus,
                                          color: HAppColor.hWhiteColor,
                                        ))
                                  ],
                                )),
                            layoutBuilder: (Widget topChild, Key topChildKey,
                                Widget bottomChild, Key bottomChildKey) {
                              return Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  Positioned(
                                    key: bottomChildKey,
                                    child: bottomChild,
                                  ),
                                  Positioned(
                                    key: topChildKey,
                                    child: topChild,
                                  ),
                                ],
                              );
                            },
                          );
                        }))
                    : GestureDetector(
                        onTap: () {
                          print('Vào đây');
                          if (wishlist != null) {
                            if (wishlist!.listIds.contains(model.id)) {
                              choose.value = true;
                              wishlist!.listIds.remove(model.id);
                            } else {
                              choose.value = false;
                              wishlist!.listIds.add(model.id);
                            }
                            wishlistController.addOrRemoveProductInWishlist(
                                wishlist!.id, wishlist!.listIds);
                            wishlistController.refreshWishlistData.toggle();
                          }
                        },
                        child: Obx(() => Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: choose.value
                                    ? HAppColor.hBluePrimaryColor
                                    : HAppColor.hDarkColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  EvaIcons.checkmark,
                                  color: HAppColor.hWhiteColor,
                                ),
                              ),
                            )),
                      )
                : GestureDetector(
                    onTap: () {
                      print('Vào đây');
                      cartController.replaceProduct(modelCompare!.id, model);
                      choose.value = cartController.checkReplaceProduct(
                          modelCompare!.id, model);
                      Get.back();
                    },
                    child: Obx(() => Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: choose.value
                                ? HAppColor.hBluePrimaryColor
                                : HAppColor.hDarkColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              quantity!.toString(),
                              style: HAppStyle.paragraph1Bold
                                  .copyWith(color: HAppColor.hWhiteColor),
                            ),
                          ),
                        )),
                  ))
      ]),
      onTap: () async {
        final product =
            await ProductRepository.instance.getProductInformation(model.id);
        final store =
            await StoreRepository.instance.getStoreInformation(model.storeId);
        cartController.productQuantityInCart.value =
            cartController.getProductQuantity(model.id);
        Get.toNamed(
          HAppRoutes.productDetail,
          arguments: {
            'product': product,
            'store': store,
          },
          preventDuplicates: false,
        );
      },
    );
  }
}

class ShimmerProductItemWidget extends StatelessWidget {
  const ShimmerProductItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      decoration: BoxDecoration(
          color: HAppColor.hWhiteColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmerWidget.rectangular(
            height: 165,
            width: HAppSize.deviceWidth,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              gapH4,
              CustomShimmerWidget.rectangular(
                height: 8,
                width: HAppSize.deviceWidth,
              ),
              gapH4,
              CustomShimmerWidget.rectangular(
                height: 16,
                width: HAppSize.deviceWidth,
              ),
              gapH4,
              CustomShimmerWidget.rectangular(
                height: 14,
                width: HAppSize.deviceWidth,
              ),
            ]),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
