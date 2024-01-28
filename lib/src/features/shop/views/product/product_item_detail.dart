import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final detailController = Get.put(DetailController());
  final productController = Get.put(ProductController());
  final String discription =
      loremIpsum(words: 30, paragraphs: 2, initWithLorem: true);

  final ProductModel model = Get.arguments['model'];
  final RxList<ProductModel> list = Get.arguments['list'];

  @override
  Widget build(BuildContext context) {
    detailController.count.value = model.quantity != 0 ? model.quantity : 1;
    Future.delayed(Duration.zero, () {
      detailController.showAppBar.value = false;
      detailController.showNameInAppBar.value = false;
    });
    return Scaffold(
      body: Stack(
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
                      backgroundColor: detailController.showAppBar.value
                          ? HAppColor.hBackgroundColor
                          : HAppColor.hTransparentColor,
                      toolbarHeight: 80,
                      leadingWidth: HAppSize.deviceWidth -
                          24 -
                          24 -
                          10 -
                          16 -
                          10 -
                          40 -
                          10,
                      leading: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            gapW24,
                            GestureDetector(
                              onTap: () => Get.back(),
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
                            onTap: () {},
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
                              child: Center(
                                child: model.isFavorite == false
                                    ? const Icon(
                                        EvaIcons.heartOutline,
                                        color: HAppColor.hGreyColor,
                                      )
                                    : const Icon(
                                        EvaIcons.heart,
                                        color: HAppColor.hRedColor,
                                      ),
                              ),
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
                  print(scrollController.offset);
                  if (scrollController.offset > 0) {
                    detailController.changeShowAppBar(true);
                    if (scrollController.offset >= 93) {
                      detailController.changeShowNameInAppBar(true);
                    }
                  } else {
                    detailController.changeShowNameInAppBar(false);
                    detailController.changeShowAppBar(false);
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
                      child: ListView(
                        controller: scrollController,
                        children: [
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
                                '${model.category}',
                                style: HAppStyle.paragraph2Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600),
                              ),
                              const Spacer(),
                              AnimatedOpacity(
                                opacity:
                                    detailController.showAppBar.value ? 0 : 1,
                                duration: const Duration(milliseconds: 300),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color: HAppColor.hGreyColorShade300,
                                          width: 1.5,
                                        ),
                                        color: HAppColor.hBackgroundColor),
                                    child: Center(
                                      child: model.isFavorite == false
                                          ? const Icon(
                                              EvaIcons.heartOutline,
                                              color: HAppColor.hGreyColor,
                                            )
                                          : const Icon(
                                              EvaIcons.heart,
                                              color: HAppColor.hRedColor,
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          gapH2,
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
                                      text: "4.9",
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
                                              color:
                                                  HAppColor.hGreyColorShade600),
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
                                productController.getComparePriceProduct(model);
                              }
                            },
                            title: Row(
                              children: [
                                model.salePersent == ''
                                    ? Text(
                                        model.price,
                                        style: HAppStyle.label1Bold.copyWith(
                                            color: HAppColor.hBluePrimaryColor),
                                      )
                                    : Text.rich(
                                        TextSpan(
                                          style: HAppStyle.label1Bold.copyWith(
                                            color: HAppColor.hOrangeColor,
                                          ),
                                          text: '${model.priceSale} ',
                                          children: [
                                            TextSpan(
                                              text: '${model.price}',
                                              style: HAppStyle.paragraph2Bold
                                                  .copyWith(
                                                      color:
                                                          HAppColor.hGreyColor,
                                                      decoration: TextDecoration
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
                                  child: GetBuilder<DetailController>(
                                      builder: (controller) =>
                                          ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: productController
                                                .comparePriceProducts.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              String differentText = "";
                                              if (model.salePersent == "") {
                                                differentText = detailController
                                                    .calculatingDifference(
                                                        productController
                                                                .comparePriceProducts[
                                                            index],
                                                        model.price);
                                              } else {
                                                differentText = detailController
                                                    .calculatingDifference(
                                                        productController
                                                                .comparePriceProducts[
                                                            index],
                                                        model.priceSale);
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
                              Row(
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
                                                BorderRadius.circular(100),
                                            color: HAppColor.hBackgroundColor),
                                        child: const Center(
                                          child: Icon(
                                            EvaIcons.minus,
                                          ),
                                        )),
                                  ),
                                  gapW16,
                                  Obx(() => Text.rich(
                                        TextSpan(
                                          style: HAppStyle.paragraph1Bold,
                                          text:
                                              "${detailController.count.value} ",
                                          children: [
                                            TextSpan(
                                              text: ' /${model.unit}',
                                              style: HAppStyle.paragraph3Regular
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
                                                BorderRadius.circular(100),
                                            color: HAppColor.hBluePrimaryColor),
                                        child: const Center(
                                          child: Icon(
                                            EvaIcons.plus,
                                            color: HAppColor.hWhiteColor,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          gapH24,
                          Container(
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
                                      borderRadius: BorderRadius.circular(100),
                                      color: HAppColor.hGreyColorShade300,
                                      image: DecorationImage(
                                          image: NetworkImage(model.imgStore),
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
                                              style: HAppStyle.paragraph2Bold,
                                              text: "4.9",
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
                                              style: HAppStyle.paragraph2Bold,
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
                                            style: HAppStyle.paragraph2Regular
                                                .copyWith(
                                                    color:
                                                        HAppColor.hGreyColor),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              style: HAppStyle.paragraph2Bold,
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
                                              style: HAppStyle.paragraph2Regular
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
                          gapH24,
                          const Text(
                            "Mô tả",
                            style: HAppStyle.heading4Style,
                          ),
                          gapH12,
                          ReadMoreText(
                            discription,
                            trimLines: 3,
                            style: HAppStyle.paragraph2Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
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
                          const Text(
                            "Nhận xét",
                            style: HAppStyle.heading4Style,
                          ),
                          gapH12,
                          const Text("Nhận xét"),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ProductItemWidget(
                                      storeIcon: true,
                                      model: list[index],
                                      list: list,
                                      compare: false,
                                    ),
                                  );
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ProductItemWidget(
                                      storeIcon: true,
                                      model: list[index + 10],
                                      list: list,
                                      compare: false,
                                    ),
                                  );
                                },
                              )),
                          gapH24
                        ],
                      ),
                    )));
              },
            ),
          )
        ],
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text.rich(
                      TextSpan(
                        text: "Giá:\n",
                        children: [
                          TextSpan(
                            text: model.priceSale != ""
                                ? "${int.parse(model.priceSale.substring(0, model.priceSale.length - 5)) * detailController.count.value}.000₫"
                                : "${int.parse(model.price.substring(0, model.price.length - 5)) * detailController.count.value}.000₫",
                            style: HAppStyle.heading4Style
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                  onPressed: () {
                    productController.addProductInCart(model);
                    productController.refreshList(list);
                    productController.refreshList(productController.isInCart);
                    model.quantity = detailController.count.value;
                    print(model.quantity);
                    productController.addMapProductInCart();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(HAppSize.deviceWidth * 0.45, 50),
                    backgroundColor: HAppColor.hBluePrimaryColor,
                  ),
                  child: Obx(() => Text(
                        productController.isInCart.contains(model)
                            ? "Cập nhật giỏ hàng"
                            : "Thêm vào giỏ hàng",
                        style: HAppStyle.label2Bold
                            .copyWith(color: HAppColor.hWhiteColor),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomInfoSheet extends StatelessWidget {
  final List<Widget> child;
  final double? minSize;
  const BottomInfoSheet({
    Key? key,
    required this.child,
    this.minSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: minSize == null ? 0.65 : minSize!,
          minChildSize: minSize == null ? 0.65 : minSize!,
          maxChildSize: 0.86,
          builder: (context, con) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    controller: con,
                    children: child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
