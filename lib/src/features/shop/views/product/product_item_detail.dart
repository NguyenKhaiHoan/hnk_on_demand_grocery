import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:toastification/toastification.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final detailController = Get.put(DetailController());
  final productController = Get.put(ProductController());
  final String discription =
      loremIpsum(words: 30, paragraphs: 2, initWithLorem: true);

  final ProductModel model = Get.arguments['model'];
  final RxList<ProductModel> list = Get.arguments['list'];
  final List<double> rates = [0.1, 0.3, 0.5, 0.7, 0.9];

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      detailController.showAppBar.value = false;
      detailController.showNameInAppBar.value = false;
      detailController.setCount(model);
      detailController.showFab(true);
    });
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: HAppSize.deviceHeight * 0.5,
            width: HAppSize.deviceWidth,
            child: Image.network(
              model.imgPath,
              fit: BoxFit.cover,
            ),
          ),
          Obx(() => SizedBox(
                height: 80,
                child: PreferredSize(
                    preferredSize: const Size.fromHeight(80.0),
                    child: AppBar(
                      titleSpacing: 0,
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      backgroundColor: detailController.showAppBar.value
                          ? HAppColor.hBackgroundColor
                          : HAppColor.hTransparentColor,
                      toolbarHeight: 80,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            gapW24,
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                detailController.changeShowNameInAppBar(false);
                                detailController.changeShowAppBar(false);
                                detailController.showFabMenu(true);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: HAppColor.hGreyColorShade300,
                                      width: 1.5,
                                    ),
                                    color: HAppColor.hBackgroundColor),
                                child: const Center(
                                  child: Icon(
                                    EvaIcons.arrowBackOutline,
                                  ),
                                ),
                              ),
                            ),
                            gapW16,
                            Expanded(
                              child: AnimatedOpacity(
                                opacity: detailController.showNameInAppBar.value
                                    ? 1
                                    : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  model.name,
                                  style: HAppStyle.heading4Style,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      actions: [
                        gapW10,
                        AnimatedOpacity(
                          opacity: detailController.showAppBar.value ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: GestureDetector(
                            onTap: () {
                              productController.addProductInFavorited(model);
                              if (productController.isFavoritedProducts
                                  .contains(model)) {
                                toastification.show(
                                  progressBarTheme:
                                      const ProgressIndicatorThemeData(
                                          color: HAppColor.hBluePrimaryColor),
                                  context: context,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  autoCloseDuration: const Duration(seconds: 1),
                                  title: Text(
                                    'Thêm vào Yêu thích!',
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
                                        const TextSpan(text: 'vào Yêu thích.')
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
                              } else {
                                toastification.show(
                                  progressBarTheme:
                                      const ProgressIndicatorThemeData(
                                          color: HAppColor.hBluePrimaryColor),
                                  context: context,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  autoCloseDuration: const Duration(seconds: 1),
                                  title: Text(
                                    'Xóa khỏi Yêu thích!',
                                    style: HAppStyle.label2Bold.copyWith(
                                        color: HAppColor.hBluePrimaryColor),
                                  ),
                                  description: RichText(
                                      text: TextSpan(
                                          style: HAppStyle.paragraph2Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                          text: 'Bạn đã xóa thành công',
                                          children: [
                                        TextSpan(
                                            text: ' ${model.name} ',
                                            style: HAppStyle.paragraph2Regular
                                                .copyWith(
                                                    color: HAppColor
                                                        .hBluePrimaryColor)),
                                        const TextSpan(text: 'khỏi Yêu thích.')
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
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: HAppColor.hGreyColorShade300,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  color: HAppColor.hBackgroundColor),
                              child: Center(
                                  child: Obx(() => productController
                                          .isFavoritedProducts
                                          .contains(model)
                                      ? const Icon(
                                          EvaIcons.heart,
                                          color: HAppColor.hRedColor,
                                        )
                                      : const Icon(
                                          EvaIcons.heartOutline,
                                          color: HAppColor.hGreyColor,
                                        ))),
                            ),
                          ),
                        ),
                        gapW10,
                        Padding(
                          padding: hAppDefaultPaddingR,
                          child: CartCircle(),
                        )
                      ],
                    )),
              )),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 1.0 - (90 / HAppSize.deviceHeight),
              builder: (context, scrollController) {
                scrollController.addListener(() {
                  if (scrollController.offset > 0) {
                    detailController.changeShowAppBar(true);
                    if (scrollController.offset >= 93) {
                      detailController.changeShowNameInAppBar(true);
                    }
                  } else {
                    detailController.changeShowNameInAppBar(false);
                    detailController.changeShowAppBar(false);
                  }
                  if (scrollController.offset <= 700) {
                    detailController.showFabMenu(true);
                  } else {
                    detailController.showFabMenu(false);
                  }
                });
                return Obx(() => Container(
                    decoration: BoxDecoration(
                      color: HAppColor.hBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: detailController.showAppBar.value
                              ? const Radius.circular(0)
                              : const Radius.circular(20),
                          topRight: detailController.showAppBar.value
                              ? const Radius.circular(0)
                              : const Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: !detailController.showAppBar.value
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.3),
                          spreadRadius:
                              !detailController.showAppBar.value ? 5 : 2,
                          blurRadius:
                              !detailController.showAppBar.value ? 7 : 3,
                          offset: !detailController.showAppBar.value
                              ? const Offset(0, 3)
                              : const Offset(
                                  0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          hAppDefaultPadding, 0, hAppDefaultPadding, 0),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapH24,
                            Obx(
                              () => detailController.showAppBar.value
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  EvaIcons.listOutline,
                                  color: HAppColor.hGreyColorShade600,
                                ),
                                gapW4,
                                Text(
                                  model.category,
                                  style: HAppStyle.paragraph2Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                ),
                                const Spacer(),
                                AnimatedOpacity(
                                  opacity:
                                      detailController.showAppBar.value ? 0 : 1,
                                  duration: const Duration(milliseconds: 300),
                                  child: GestureDetector(
                                    onTap: () {
                                      productController
                                          .addProductInFavorited(model);
                                      if (productController.isFavoritedProducts
                                          .contains(model)) {
                                        toastification.show(
                                          progressBarTheme:
                                              const ProgressIndicatorThemeData(
                                                  color: HAppColor
                                                      .hBluePrimaryColor),
                                          context: context,
                                          type: ToastificationType.success,
                                          style: ToastificationStyle.flat,
                                          autoCloseDuration:
                                              const Duration(seconds: 1),
                                          title: Text(
                                            'Thêm vào Yêu thích!',
                                            style: HAppStyle.label2Bold
                                                .copyWith(
                                                    color: HAppColor
                                                        .hBluePrimaryColor),
                                          ),
                                          description: RichText(
                                              text: TextSpan(
                                                  style: HAppStyle
                                                      .paragraph2Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600),
                                                  text:
                                                      'Bạn đã thêm thành công',
                                                  children: [
                                                TextSpan(
                                                    text: ' ${model.name} ',
                                                    style: HAppStyle
                                                        .paragraph2Regular
                                                        .copyWith(
                                                            color: HAppColor
                                                                .hBluePrimaryColor)),
                                                const TextSpan(
                                                    text: 'vào Yêu thích.')
                                              ])),
                                          alignment: Alignment.topCenter,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          animationBuilder: (context, animation,
                                              alignment, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: HAppColor.hBluePrimaryColor,
                                          ),
                                          backgroundColor:
                                              HAppColor.hBackgroundColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                      } else {
                                        toastification.show(
                                          progressBarTheme:
                                              const ProgressIndicatorThemeData(
                                                  color: HAppColor
                                                      .hBluePrimaryColor),
                                          context: context,
                                          type: ToastificationType.success,
                                          style: ToastificationStyle.flat,
                                          autoCloseDuration:
                                              const Duration(seconds: 1),
                                          title: Text(
                                            'Xóa khỏi Yêu thích!',
                                            style: HAppStyle.label2Bold
                                                .copyWith(
                                                    color: HAppColor
                                                        .hBluePrimaryColor),
                                          ),
                                          description: RichText(
                                              text: TextSpan(
                                                  style: HAppStyle
                                                      .paragraph2Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600),
                                                  text: 'Bạn đã xóa thành công',
                                                  children: [
                                                TextSpan(
                                                    text: ' ${model.name} ',
                                                    style: HAppStyle
                                                        .paragraph2Regular
                                                        .copyWith(
                                                            color: HAppColor
                                                                .hBluePrimaryColor)),
                                                const TextSpan(
                                                    text: 'khỏi Yêu thích.')
                                              ])),
                                          alignment: Alignment.topCenter,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          animationBuilder: (context, animation,
                                              alignment, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: HAppColor.hBluePrimaryColor,
                                          ),
                                          backgroundColor:
                                              HAppColor.hBackgroundColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: HAppColor.hGreyColorShade300,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: HAppColor.hBackgroundColor),
                                      child: Center(
                                          child: Obx(() => productController
                                                  .isFavoritedProducts
                                                  .contains(model)
                                              ? const Icon(
                                                  EvaIcons.heart,
                                                  color: HAppColor.hRedColor,
                                                )
                                              : const Icon(
                                                  EvaIcons.heartOutline,
                                                  color: HAppColor.hGreyColor,
                                                ))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            gapH12,
                            Text(
                              model.name,
                              style: HAppStyle.heading2Style,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH6,
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      EvaIcons.star,
                                      color: HAppColor.hOrangeColor,
                                      size: 20,
                                    ),
                                    gapW2,
                                    Text.rich(
                                      TextSpan(
                                        style: HAppStyle.paragraph1Bold,
                                        text: "4.3",
                                        children: [
                                          TextSpan(
                                            text: '/5',
                                            style: HAppStyle.paragraph2Regular
                                                .copyWith(
                                                    color: HAppColor
                                                        .hGreyColorShade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    "•",
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  ),
                                )),
                                Text.rich(
                                  TextSpan(
                                    style: HAppStyle.paragraph1Bold,
                                    text: "2.3k+ ",
                                    children: [
                                      TextSpan(
                                        text: 'Nhận xét',
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hGreyColorShade600),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    "•",
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  ),
                                )),
                                Text.rich(
                                  TextSpan(
                                    style: HAppStyle.paragraph1Bold,
                                    text: '${model.countBuyed} ',
                                    children: [
                                      TextSpan(
                                        text: 'Đã bán',
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor.hGreyColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            gapH12,
                            ExpansionTile(
                              initiallyExpanded: false,
                              tilePadding: EdgeInsets.zero,
                              shape: const Border(),
                              onExpansionChanged: (value) {
                                if (value) {
                                  productController
                                      .getComparePriceProduct(model);
                                }
                              },
                              title: Row(
                                children: [
                                  model.salePersent == ''
                                      ? Text(
                                          model.price,
                                          style: HAppStyle.label1Bold.copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor),
                                        )
                                      : Text.rich(
                                          TextSpan(
                                            style:
                                                HAppStyle.label1Bold.copyWith(
                                              color: HAppColor.hOrangeColor,
                                            ),
                                            text: '${model.priceSale} ',
                                            children: [
                                              TextSpan(
                                                text: model.price,
                                                style: HAppStyle.paragraph2Bold
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
                                  const Spacer(),
                                  const Text("So sánh giá")
                                ],
                              ),
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    height: 315,
                                    child: Obx(() => ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productController
                                              .comparePriceProducts.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            String differentText = "";
                                            String compareOperator = "";
                                            String comparePrice = "";

                                            if (model.salePersent == "") {
                                              differentText = detailController
                                                  .calculatingDifference(
                                                      productController
                                                              .comparePriceProducts[
                                                          index],
                                                      model.price);
                                              compareOperator = detailController
                                                  .comparePrice(differentText);
                                              comparePrice = detailController
                                                  .comparePriceNumber(
                                                      differentText);
                                            } else {
                                              differentText = detailController
                                                  .calculatingDifference(
                                                      productController
                                                              .comparePriceProducts[
                                                          index],
                                                      model.priceSale);
                                              compareOperator = detailController
                                                  .comparePrice(differentText);
                                              comparePrice = detailController
                                                  .comparePriceNumber(
                                                      differentText);
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16),
                                              child: ProductItemWidget(
                                                storeIcon: true,
                                                model: productController
                                                        .comparePriceProducts[
                                                    index],
                                                list: productController
                                                    .comparePriceProducts,
                                                compare: true,
                                                differentText: differentText,
                                                compareOperator:
                                                    compareOperator,
                                                comparePrice: comparePrice,
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  gapW10,
                                        )))
                              ],
                            ),
                            gapH12,
                            Row(
                              children: [
                                const Text(
                                  "Số lượng",
                                  style: HAppStyle.heading4Style,
                                ),
                                const Spacer(),
                                model.status == ""
                                    ? Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              detailController.changeCount("-");
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: HAppColor
                                                        .hBackgroundColor),
                                                child: const Center(
                                                  child: Icon(
                                                    EvaIcons.minus,
                                                  ),
                                                )),
                                          ),
                                          gapW16,
                                          Obx(() => Text.rich(
                                                TextSpan(
                                                  style:
                                                      HAppStyle.paragraph1Bold,
                                                  text: detailController
                                                      .countText.value,
                                                  children: [
                                                    TextSpan(
                                                      text: '  /${model.unit}',
                                                      style: HAppStyle
                                                          .paragraph3Regular
                                                          .copyWith(
                                                        color: HAppColor
                                                            .hGreyColorShade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          gapW16,
                                          GestureDetector(
                                            onTap: () {
                                              detailController.changeCount("+");
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: HAppColor
                                                        .hBluePrimaryColor),
                                                child: const Center(
                                                  child: Icon(
                                                    EvaIcons.plus,
                                                    color:
                                                        HAppColor.hWhiteColor,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                HAppColor.hGreyColorShade300),
                                        child: Center(
                                            child: Text(
                                          model.status,
                                          style: HAppStyle.label3Regular,
                                        )),
                                      ),
                              ],
                            ),
                            gapH24,
                            GestureDetector(
                              onTap: () => Get.toNamed(HAppRoutes.storeDetail,
                                  arguments: {
                                    'model': productController
                                        .checkProductInStore(model)
                                  }),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1.5,
                                        color: HAppColor.hGreyColorShade300)),
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: HAppColor.hGreyColorShade300,
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(model.imgStore),
                                              fit: BoxFit.cover)),
                                    ),
                                    gapW10,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.nameStore,
                                            style: HAppStyle.heading4Style,
                                          ),
                                          gapH4,
                                          Row(
                                            children: [
                                              const Icon(
                                                EvaIcons.star,
                                                color: HAppColor.hOrangeColor,
                                                size: 20,
                                              ),
                                              gapW2,
                                              Text.rich(
                                                TextSpan(
                                                  style:
                                                      HAppStyle.paragraph2Bold,
                                                  text: "4.3",
                                                  children: [
                                                    TextSpan(
                                                      text: '/5 (1k+ Đánh giá)',
                                                      style: HAppStyle
                                                          .paragraph2Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          gapH4,
                                          Row(
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  style:
                                                      HAppStyle.paragraph2Bold,
                                                  text: "130 ",
                                                  children: [
                                                    TextSpan(
                                                      text: 'Sản phẩm',
                                                      style: HAppStyle
                                                          .paragraph2Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                " • ",
                                                style: HAppStyle
                                                    .paragraph2Regular
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hGreyColor),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  style:
                                                      HAppStyle.paragraph2Bold,
                                                  text: '1k+ ',
                                                  children: [
                                                    TextSpan(
                                                      text: 'Đã bán',
                                                      style: HAppStyle
                                                          .paragraph2Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          gapH4,
                                          Row(
                                            children: [
                                              const Icon(
                                                EneftyIcons.location_outline,
                                                size: 15,
                                                color: HAppColor.hDarkColor,
                                              ),
                                              gapW4,
                                              Text('Hà Nội',
                                                  style: HAppStyle
                                                      .paragraph2Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            gapH24,
                            const Text(
                              "Mô tả",
                              style: HAppStyle.heading4Style,
                            ),
                            gapH12,
                            ReadMoreText(
                              discription,
                              trimLines: 3,
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Hiển thị thêm',
                              trimExpandedText: ' Rút gọn',
                              moreStyle: HAppStyle.label3Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                              lessStyle: HAppStyle.label3Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            ),
                            gapH12,
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text(
                                    'Xuất xứ',
                                    style: HAppStyle.paragraph2Regular,
                                  ),
                                  Text(
                                    'Việt Nam',
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  )
                                ]),
                                TableRow(children: [
                                  const Text(
                                    'Đơn vị',
                                    style: HAppStyle.paragraph2Regular,
                                  ),
                                  Text(
                                    model.unit,
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  )
                                ])
                              ],
                            ),
                            gapH24,
                            OutlinedButton(
                                onPressed: () {
                                  Get.toNamed(HAppRoutes.wishlist,
                                      arguments: {'model': model});
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth - 48, 40),
                                    backgroundColor: HAppColor.hBackgroundColor,
                                    side: BorderSide(
                                        width: 2,
                                        color: HAppColor.hGreyColorShade300)),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      EvaIcons.plus,
                                      size: 20,
                                      color: HAppColor.hDarkColor,
                                    ),
                                    gapW4,
                                    Text(
                                      "Thêm vào WishList",
                                      style: HAppStyle.label2Bold,
                                    )
                                  ],
                                )),
                            gapH24,
                            const Text(
                              "Nhận xét",
                              style: HAppStyle.heading4Style,
                            ),
                            gapH12,
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(
                                            style: HAppStyle.heading3Style,
                                            text: '4.3',
                                            children: [
                                              TextSpan(
                                                  text: '/5',
                                                  style: HAppStyle
                                                      .paragraph1Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600))
                                            ])),
                                        Text(
                                          '2.3k+ Nhận xét',
                                          style: HAppStyle.paragraph2Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                        gapH10,
                                        RatingBar.builder(
                                          itemSize: 20,
                                          initialRating: 4.3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.only(right: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            EvaIcons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ]),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            const Spacer(),
                                            Text(
                                              "${index + 1}",
                                              style: HAppStyle.paragraph3Regular
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hGreyColorShade600),
                                            ),
                                            gapW4,
                                            const Icon(
                                              EvaIcons.star,
                                              color: Colors.amber,
                                              size: 15,
                                            ),
                                            gapW4,
                                            LinearPercentIndicator(
                                              barRadius:
                                                  const Radius.circular(100),
                                              backgroundColor:
                                                  HAppColor.hGreyColorShade300,
                                              width:
                                                  (HAppSize.deviceWidth / 2.8),
                                              lineHeight: 5,
                                              animation: true,
                                              animationDuration: 2000,
                                              percent: rates[index],
                                              progressColor: Colors.amber,
                                            )
                                          ],
                                        );
                                      }),
                                )
                              ],
                            ),
                            gapH24,
                            const Text(
                              "Thường được mua chung",
                              style: HAppStyle.heading4Style,
                            ),
                            gapH12,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Obx(
                                          () => ProductItemWidget(
                                            storeIcon: true,
                                            model: list
                                                .where((product) =>
                                                    product != model)
                                                .toList()[index],
                                            list: list,
                                            compare: false,
                                          ),
                                        ));
                                  },
                                )),
                            gapH24,
                            const Text(
                              "Sản phẩm liên quan",
                              style: HAppStyle.heading4Style,
                            ),
                            gapH12,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Obx(() => ProductItemWidget(
                                            storeIcon: true,
                                            model: list
                                                .where((product) =>
                                                    product != model)
                                                .toList()[index + 10],
                                            list: list,
                                            compare: false,
                                          )),
                                    );
                                  },
                                )),
                            gapH24
                          ],
                        ),
                      ),
                    )));
              },
            ),
          )
        ],
      )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
            hAppDefaultPadding, 20, hAppDefaultPadding, 16),
        decoration: BoxDecoration(
          color: HAppColor.hBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            model.status == ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text.rich(
                            TextSpan(
                              text: "Giá:\n",
                              children: [
                                TextSpan(
                                  text: model.priceSale != ""
                                      ? "${int.parse(model.priceSale.substring(0, model.priceSale.length - 5)) * int.parse(detailController.countText.value)}.000₫"
                                      : "${int.parse(model.price.substring(0, model.price.length - 5)) * int.parse(detailController.countText.value)}.000₫",
                                  style: HAppStyle.heading4Style.copyWith(
                                      color: HAppColor.hBluePrimaryColor),
                                ),
                              ],
                            ),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          if (model.quantity == 0) {
                            productController.addProductInCart(model);
                          }
                          model.quantity =
                              int.parse(detailController.countText.value);
                          detailController.setCount(model);
                          productController.refreshAllList();
                          productController
                              .refreshList(productController.isInCart);
                          productController.addMapProductInCart();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(HAppSize.deviceWidth * 0.1, 50),
                          backgroundColor: HAppColor.hBluePrimaryColor,
                        ),
                        child: Obx(() => Text(
                              productController.isInCart.contains(model)
                                  ? "Cập nhật Giỏ hàng"
                                  : "Thêm vào Giỏ hàng",
                              style: HAppStyle.label2Bold
                                  .copyWith(color: HAppColor.hWhiteColor),
                            )),
                      ),
                    ],
                  )
                : Row(children: [
                    GestureDetector(
                      onTap: () {
                        productController
                            .addRegisterNotificationProducts(model);
                        for (var product
                            in productController.registerNotificationProducts) {
                          print(product.name);
                        }
                        if (productController.registerNotificationProducts
                            .contains(model)) {
                          toastification.show(
                            progressBarTheme: const ProgressIndicatorThemeData(
                                color: HAppColor.hBluePrimaryColor),
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            autoCloseDuration: const Duration(seconds: 5),
                            title: Text(
                              'Đăng ký nhận thông báo khi có hàng!',
                              style: HAppStyle.label2Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            ),
                            description: RichText(
                                text: TextSpan(
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                    text:
                                        'Chúng tôi sẽ gửi cho bạn thông báo khi sản phẩm',
                                    children: [
                                  TextSpan(
                                      text: ' ${model.name} ',
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                  const TextSpan(
                                      text:
                                          'có sẵn để đặt hàng. Bạn có thể hủy đăng ký bất cứ lúc nào bằng cách nhấn lại nút thông báo.')
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
                            closeButtonShowType: CloseButtonShowType.onHover,
                            closeOnClick: false,
                            pauseOnHover: true,
                            dragToClose: true,
                          );
                        } else {
                          toastification.show(
                            progressBarTheme: const ProgressIndicatorThemeData(
                                color: HAppColor.hBluePrimaryColor),
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            autoCloseDuration: const Duration(seconds: 5),
                            title: Text(
                              'Hủy đăng ký nhận thông báo khi có hàng!',
                              style: HAppStyle.label2Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            ),
                            description: RichText(
                                text: TextSpan(
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                    text:
                                        'Bạn đã được gỡ khỏi danh sách nhận thông báo về sản phẩm',
                                    children: [
                                  TextSpan(
                                      text: ' ${model.name}',
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                  const TextSpan(
                                      text:
                                          '. Nếu bạn muốn đăng ký lại, bạn có thể nhấn vào nút chuông bất cứ lúc nào.')
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
                            closeButtonShowType: CloseButtonShowType.onHover,
                            closeOnClick: false,
                            pauseOnHover: true,
                            dragToClose: true,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: HAppColor.hGreyColorShade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(100),
                            color: HAppColor.hBackgroundColor),
                        child: Center(
                            child: Obx(() => !productController
                                    .registerNotificationProducts
                                    .contains(model)
                                ? const Icon(
                                    EneftyIcons.notification_bing_outline)
                                : const Icon(
                                    EneftyIcons.notification_bing_bold,
                                    color: HAppColor.hBluePrimaryColor,
                                  ))),
                      ),
                    ),
                    gapW10,
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            productController.addProductInFavorited(model);
                            if (productController.isFavoritedProducts
                                .contains(model)) {
                              toastification.show(
                                progressBarTheme:
                                    const ProgressIndicatorThemeData(
                                        color: HAppColor.hBluePrimaryColor),
                                context: context,
                                type: ToastificationType.success,
                                style: ToastificationStyle.flat,
                                autoCloseDuration: const Duration(seconds: 1),
                                title: Text(
                                  'Thêm vào Yêu thích!',
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
                                      const TextSpan(text: 'vào Yêu thích.')
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
                            } else {
                              toastification.show(
                                progressBarTheme:
                                    const ProgressIndicatorThemeData(
                                        color: HAppColor.hBluePrimaryColor),
                                context: context,
                                type: ToastificationType.success,
                                style: ToastificationStyle.flat,
                                autoCloseDuration: const Duration(seconds: 1),
                                title: Text(
                                  'Xóa khỏi Yêu thích!',
                                  style: HAppStyle.label2Bold.copyWith(
                                      color: HAppColor.hBluePrimaryColor),
                                ),
                                description: RichText(
                                    text: TextSpan(
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hGreyColorShade600),
                                        text: 'Bạn đã xóa thành công',
                                        children: [
                                      TextSpan(
                                          text: ' ${model.name} ',
                                          style: HAppStyle.paragraph2Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hBluePrimaryColor)),
                                      const TextSpan(text: 'khỏi Yêu thích.')
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HAppColor.hBluePrimaryColor,
                          ),
                          child: Obx(
                            () => productController.isFavoritedProducts
                                    .contains(model)
                                ? Text(
                                    "Xóa khỏi Yêu thích",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )
                                : Text(
                                    "Thêm vào Yêu thích",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  ),
                          )),
                    ),
                  ]),
          ],
        ),
      ),
      floatingActionButton: Obx(() => detailController.showFab.isTrue
          ? SpeedDial(
              foregroundColor: HAppColor.hWhiteColor,
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: HAppColor.hRedColor.shade200,
              overlayColor: HAppColor.hBackgroundColor,
              overlayOpacity: 0.4,
              spacing: 12,
              children: [
                SpeedDialChild(
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.store,
                      color: HAppColor.hRedColor,
                    ),
                    label: 'Ghé thăm ${model.nameStore}',
                    onTap: () =>
                        Get.toNamed(HAppRoutes.storeDetail, arguments: {
                          'model': productController.checkProductInStore(model)
                        }),
                    backgroundColor: HAppColor.hBackgroundColor),
                SpeedDialChild(
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.message,
                      color: HAppColor.hRedColor,
                    ),
                    label: 'Trò chuyện',
                    onTap: () => Get.toNamed(HAppRoutes.chat, arguments: {
                          'model': model,
                          'store': productController.checkProductInStore(model)
                        }),
                    backgroundColor: HAppColor.hBackgroundColor)
              ],
            )
          : Container()),
    );
  }
}
