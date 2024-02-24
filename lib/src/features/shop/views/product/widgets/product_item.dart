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
import 'package:toastification/toastification.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemWidget({
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
        width: 165,
        decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(model.imgPath),
                          fit: BoxFit.fill)),
                ),
              ),
              storeIcon
                  ? Positioned(
                      top: 10,
                      left: 10,
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
              Positioned(
                top: 10,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(model.category,
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColorShade600)),
                        Text(model.unit,
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColorShade600)),
                      ],
                    ),
                    gapH4,
                    Text(
                      model.name,
                      style: HAppStyle.label2Bold.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    gapH4,
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
                                text: "4.3",
                                children: [
                                  TextSpan(
                                    text: '/5',
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
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
                                  DummyData.vietNamCurrencyFormatting(
                                      model.price),
                                  style: HAppStyle.label2Bold.copyWith(
                                      color: HAppColor.hBluePrimaryColor),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        DummyData.vietNamCurrencyFormatting(
                                            model.price),
                                        style: HAppStyle.paragraph3Bold
                                            .copyWith(
                                                color: HAppColor.hGreyColor,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                    Text(
                                        DummyData.vietNamCurrencyFormatting(
                                            model.priceSale),
                                        style: HAppStyle.label2Bold.copyWith(
                                            color: HAppColor.hOrangeColor,
                                            decoration: TextDecoration.none))
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
                                          style: HAppStyle.label2Bold.copyWith(
                                              color: HAppColor.hWhiteColor),
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
                                productController
                                    .refreshList(productController.isInCart);
                                productController.refreshAllList();
                                toastification.show(
                                  progressBarTheme:
                                      const ProgressIndicatorThemeData(
                                          color: HAppColor.hBluePrimaryColor),
                                  context: context,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  autoCloseDuration: const Duration(seconds: 1),
                                  title: Text(
                                    'Thêm vào Giỏ hàng!',
                                    style: HAppStyle.label2Bold.copyWith(
                                        color: HAppColor.hBluePrimaryColor),
                                  ),
                                  description: RichText(
                                      text: TextSpan(
                                          style: HAppStyle.paragraph2Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                          text: 'Bạn đã thêm thành công',
                                          children: [
                                        TextSpan(
                                            text: ' ${model.name} ',
                                            style: HAppStyle.paragraph2Regular
                                                .copyWith(
                                                    color: HAppColor
                                                        .hBluePrimaryColor)),
                                        const TextSpan(text: 'vào Giỏ hàng.')
                                      ])),
                                  alignment: Alignment.topCenter,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  animationBuilder:
                                      (context, animation, alignment, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    color: HAppColor.hBluePrimaryColor,
                                  ),
                                  backgroundColor: HAppColor.hBackgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x07000000),
                                      blurRadius: 16,
                                      offset: Offset(0, 16),
                                      spreadRadius: 0,
                                    )
                                  ],
                                  showProgressBar: true,
                                  closeButtonShowType:
                                      CloseButtonShowType.onHover,
                                  closeOnClick: false,
                                  pauseOnHover: true,
                                  dragToClose: true,
                                );
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
                          child: model.salePersent == 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        DummyData.vietNamCurrencyFormatting(
                                            model.price),
                                        style: HAppStyle.label2Bold.copyWith(
                                            color: HAppColor.hBluePrimaryColor,
                                            decoration: TextDecoration.none))
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              ? "Bằng giá"
                                              : "$comparePrice",
                                          style: HAppStyle.paragraph3Regular,
                                        )
                                      ],
                                    ),
                                    Text(
                                        DummyData.vietNamCurrencyFormatting(
                                            model.priceSale),
                                        style: HAppStyle.label2Bold.copyWith(
                                            color: HAppColor.hOrangeColor,
                                            decoration: TextDecoration.none))
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
                            height: 20,
                            width: 20,
                          )),
                        ),
                        onTap: () => Get.toNamed(HAppRoutes.compare),
                      )
                    ],
                  )
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
