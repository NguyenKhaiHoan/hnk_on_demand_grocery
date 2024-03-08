import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:toastification/toastification.dart';

class ProductItemHorizalWidget extends StatelessWidget {
  ProductItemHorizalWidget({
    super.key,
    required this.model,
    required this.storeIcon,
    required this.list,
    required this.compare,
    this.modelCompare,
    this.differentText,
    this.compareOperator,
    this.comparePrice,
  });
  final ProductModel model;
  final ProductModel? modelCompare;
  final bool storeIcon;
  final RxList<ProductModel> list;
  final bool compare;
  final String? differentText;
  final String? compareOperator;
  final String? comparePrice;

  final productController = Get.put(ProductController());
  final detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 110,
        padding: const EdgeInsets.only(left: 10, top: 10),
        decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(model.imgPath),
                          fit: BoxFit.fill)),
                ),
              ),
              storeIcon
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: HAppColor.hGreyColorShade300,
                              image: DecorationImage(
                                  image: NetworkImage(model.imgStore),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    )
                  : Container(),
              model.salePersent != 0
                  ? Positioned(
                      bottom: 10,
                      left: 0,
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
              Positioned(
                top: 0,
                right: 10,
                child: GestureDetector(
                  onTap: () => productController.addProductInFavorited(model),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: HAppColor.hBackgroundColor),
                    child: Center(
                        child: Obx(
                      () =>
                          !productController.isFavoritedProducts.contains(model)
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
              model.status != ""
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
            gapW10,
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(model.category,
                                style: HAppStyle.paragraph3Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600)),
                            const Spacer(),
                            Text(model.unit,
                                style: HAppStyle.paragraph3Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600)),
                          ],
                        ),
                        gapH8,
                        Text(
                          model.name,
                          style: HAppStyle.label2Bold.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        gapH8,
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
                        ),
                      ]),
                ),
                const Spacer(),
                !compare
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 45,
                            child: Center(
                              child: model.salePersent == 0
                                  ? Text(
                                      DummyData.vietNamCurrencyFormatting(
                                          model.price),
                                      style: HAppStyle.label2Bold.copyWith(
                                          color: HAppColor.hBluePrimaryColor),
                                    )
                                  : model.status == ""
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                DummyData
                                                    .vietNamCurrencyFormatting(
                                                        model.price),
                                                style: HAppStyle
                                                    .paragraph3Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hGreyColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough)),
                                            Text(
                                                DummyData
                                                    .vietNamCurrencyFormatting(
                                                        model.priceSale),
                                                style: HAppStyle.label2Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hOrangeColor,
                                                        decoration:
                                                            TextDecoration
                                                                .none))
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                style: HAppStyle.label2Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hOrangeColor,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                text:
                                                    '${DummyData.vietNamCurrencyFormatting(model.priceSale)} ',
                                                children: [
                                                  TextSpan(
                                                    text: DummyData
                                                        .vietNamCurrencyFormatting(
                                                            model.price),
                                                    style: HAppStyle
                                                        .label4Regular
                                                        .copyWith(
                                                            color: HAppColor
                                                                .hGreyColor,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          ),
                          Visibility(
                              visible: model.status == "" ? true : false,
                              child: GestureDetector(
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: HAppColor.hBluePrimaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                      child: model.quantity != 0
                                          ? Text(
                                              "${model.quantity}",
                                              style: HAppStyle.label2Bold
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hWhiteColor),
                                            )
                                          : const Icon(
                                              EvaIcons.plus,
                                              color: HAppColor.hWhiteColor,
                                            )),
                                ),
                                onTap: () {
                                  productController.addProductInCart(model);
                                  if (model.quantity == 0) {
                                    model.quantity++;
                                    productController.refreshList(
                                        productController.isInCart);
                                    productController.refreshAllList();
                                    HAppUtils.showToastSuccess(
                                        Text(
                                          'Thêm vào Giỏ hàng!',
                                          style: HAppStyle.label2Bold.copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor),
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                style: HAppStyle
                                                    .paragraph2Regular
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hGreyColorShade600),
                                                text: 'Bạn đã thêm thành công',
                                                children: [
                                              TextSpan(
                                                  text: ' ${model.name} ',
                                                  style: HAppStyle
                                                      .paragraph2Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hBluePrimaryColor)),
                                              const TextSpan(
                                                  text: 'vào Giỏ hàng.')
                                            ])),
                                        1,
                                        context,
                                        const ToastificationCallbacks());
                                  }
                                },
                              ))
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: model.salePersent == ''
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            compareOperator == '>'
                                                ? const Icon(
                                                    EvaIcons.trendingUpOutline,
                                                    color: HAppColor.hRedColor,
                                                    size: 20,
                                                  )
                                                : compareOperator == "<"
                                                    ? const Icon(
                                                        EvaIcons
                                                            .trendingDownOutline,
                                                        color:
                                                            Colors.greenAccent,
                                                        size: 20,
                                                      )
                                                    : Container(),
                                            gapW4,
                                            Text(
                                              compareOperator == "="
                                                  ? "Ngang nhau"
                                                  : "$comparePrice",
                                              style:
                                                  HAppStyle.paragraph3Regular,
                                            )
                                          ],
                                        ),
                                        Text(
                                            DummyData.vietNamCurrencyFormatting(
                                                model.price),
                                            style: HAppStyle.label2Bold
                                                .copyWith(
                                                    color: HAppColor
                                                        .hBluePrimaryColor,
                                                    decoration:
                                                        TextDecoration.none))
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
                                                    EvaIcons.trendingUpOutline,
                                                    color: HAppColor.hRedColor,
                                                    size: 20,
                                                  )
                                                : compareOperator == "<"
                                                    ? const Icon(
                                                        EvaIcons
                                                            .trendingDownOutline,
                                                        color:
                                                            Colors.greenAccent,
                                                        size: 20,
                                                      )
                                                    : Container(),
                                            gapW4,
                                            Text(
                                              compareOperator == "="
                                                  ? "Ngang nhau"
                                                  : "$comparePrice",
                                              style:
                                                  HAppStyle.paragraph3Regular,
                                            )
                                          ],
                                        ),
                                        Text(
                                            DummyData.vietNamCurrencyFormatting(
                                                model.priceSale),
                                            style: HAppStyle.label2Bold
                                                .copyWith(
                                                    color:
                                                        HAppColor.hOrangeColor,
                                                    decoration:
                                                        TextDecoration.none))
                                      ],
                                    )),
                          GestureDetector(
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: HAppColor.hBluePrimaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                  child: Image.asset(
                                'assets/images/other/search_tick.png',
                                height: 25,
                                width: 25,
                              )),
                            ),
                            onTap: () => Get.toNamed(HAppRoutes.compare),
                          )
                        ],
                      )
              ],
            ))
          ],
        ),
      ),
      onTap: () {
        Get.toNamed(
          HAppRoutes.productDetail,
          arguments: {
            'model': model,
            'list': list,
          },
          preventDuplicates: false,
        );
      },
    );
  }
}
