import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_with_title_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/swipe_action_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:toastification/toastification.dart';

class ProductCartWidget extends StatelessWidget {
  ProductCartWidget({
    super.key,
    required this.model,
  });
  final ProductInCartModel model;

  final cartController = Get.put(CartController());
  final productController = Get.put(ProductController());
  final storeController = Get.put(StoreController());
  final detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return SwipeActionWidget(
      check: 1,
      backgroundColorIcon: const Color(0xFFFFE6E6),
      colorIcon: HAppColor.hRedColor,
      icon: EvaIcons.trashOutline,
      function: (_) {
        // cartController.removeProduct(model);
      },
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HAppColor.hWhiteColor,
          ),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(children: [
            Stack(
              children: [
                ImageNetwork(
                  image: model.image!,
                  height: 70,
                  width: 70,
                  onLoading: CustomShimmerWidget.rectangular(height: 70),
                  duration: 100,
                  onError: const Icon(Icons.error),
                ),
              ],
            ),
            gapW10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.unit!,
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColor),
                      ),
                      GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: hAppDefaultPadding,
                                        horizontal: hAppDefaultPadding),
                                    decoration: const BoxDecoration(
                                        color: HAppColor.hBackgroundColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Thay thế sản phẩm",
                                                  style:
                                                      HAppStyle.heading4Style,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: const Icon(
                                                        EvaIcons.close))
                                              ],
                                            ),
                                            gapH6,
                                            Divider(
                                              color:
                                                  HAppColor.hGreyColorShade300,
                                            ),
                                            gapH12,
                                            Row(
                                              children: [
                                                Obx(() => cartController
                                                            .totalCartPrice
                                                            .value !=
                                                        0
                                                    ? Text.rich(TextSpan(
                                                        text:
                                                            'Tổng chênh lệch: ',
                                                        style: HAppStyle
                                                            .heading5Style,
                                                        children: [
                                                            TextSpan(
                                                                text: HAppUtils
                                                                    .vietNamCurrencyFormatting(
                                                                        cartController
                                                                            .totalDifference()),
                                                                style: HAppStyle
                                                                    .paragraph2Regular
                                                                    .copyWith(
                                                                        color: HAppColor
                                                                            .hGreyColorShade600))
                                                          ]))
                                                    : Container()),
                                                gapW4,
                                                const Icon(EvaIcons.infoOutline)
                                              ],
                                            ),
                                            gapH6,
                                            Row(
                                              children: [
                                                Obx(() => cartController
                                                            .totalCartPrice
                                                            .value !=
                                                        0
                                                    ? Text.rich(TextSpan(
                                                        text:
                                                            'Tổng giá trị đơn hàng thay thế: ',
                                                        style: HAppStyle
                                                            .heading5Style,
                                                        children: [
                                                            TextSpan(
                                                                text: HAppUtils
                                                                    .vietNamCurrencyFormatting(
                                                                        cartController
                                                                            .totalCartValue()),
                                                                style: HAppStyle
                                                                    .paragraph2Regular
                                                                    .copyWith(
                                                                        color: HAppColor
                                                                            .hGreyColorShade600))
                                                          ]))
                                                    : Container()),
                                                gapW4,
                                                const Icon(EvaIcons.infoOutline)
                                              ],
                                            ),
                                            gapH12,
                                            FutureBuilder(
                                              future: productController
                                                  .fetchProductsByQueryExceptId(
                                                      model),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 16),
                                                      child:
                                                          const ShimmerHorizontalListProductWithTitleWidget());
                                                }

                                                if (snapshot.hasError) {
                                                  return const Center(
                                                    child: Text(
                                                        'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                                                  );
                                                }

                                                if (!snapshot.hasData ||
                                                    snapshot.data == null ||
                                                    snapshot.data!.isEmpty) {
                                                  return Text(
                                                      'Không có sản phẩm tương tự');
                                                } else {
                                                  final products =
                                                      snapshot.data!;
                                                  var modelCompare =
                                                      cartController
                                                          .convertToProductModel(
                                                              model);
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 16),
                                                    child: HorizontalListProductWithTitleWidget(
                                                        list: products,
                                                        compare: true,
                                                        storeIcon: false,
                                                        quantity:
                                                            model.quantity,
                                                        modelCompare:
                                                            modelCompare,
                                                        title:
                                                            'Các sản phẩm liên quan'),
                                                  );
                                                }
                                              },
                                            ),
                                            gapH12,
                                          ]),
                                    ),
                                  );
                                });
                          },
                          child: const Row(
                            children: [
                              Icon(
                                EvaIcons.flip2Outline,
                                size: 15,
                              ),
                              gapW4,
                              Text(
                                "Thay thế",
                                style: HAppStyle.label4Bold,
                              )
                            ],
                          )),
                    ],
                  ),
                  gapH6,
                  Row(
                    children: [
                      Text(
                        model.productName ?? '',
                        maxLines: 2,
                        style: HAppStyle.heading4Style
                            .copyWith(overflow: TextOverflow.ellipsis),
                      ),
                      Spacer()
                    ],
                  ),
                  gapH6,
                  Row(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              cartController.removeSingleProductInCart(model);
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HAppColor.hBackgroundColor),
                                child: Center(
                                  child: model.quantity == 1
                                      ? const Icon(
                                          EvaIcons.trashOutline,
                                          size: 15,
                                        )
                                      : const Icon(
                                          EvaIcons.minus,
                                          size: 15,
                                        ),
                                )),
                          ),
                          gapW6,
                          Text(
                            model.quantity.toString(),
                            style: HAppStyle.paragraph2Bold,
                          ),
                          gapW6,
                          GestureDetector(
                            onTap: () {
                              cartController.addSingleProductInCart(model);
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HAppColor.hBluePrimaryColor),
                                child: const Center(
                                  child: Icon(
                                    EvaIcons.plus,
                                    size: 15,
                                    color: HAppColor.hWhiteColor,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            HAppUtils.vietNamCurrencyFormatting(
                                model.price! * model.quantity),
                            style: HAppStyle.label2Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
        ),
        onTap: () async {
          final product = await ProductRepository.instance
              .getProductInformation(model.productId);
          final store = await StoreRepository.instance
              .getStoreInformation(model.productId);
          cartController.productQuantityInCart.value =
              cartController.getProductQuantity(model.productId);
          Get.toNamed(
            HAppRoutes.productDetail,
            arguments: {
              'product': product,
              'store': store,
            },
            preventDuplicates: false,
          );
        },
      ),
    );
  }
}
