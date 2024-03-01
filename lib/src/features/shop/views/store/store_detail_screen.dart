import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_bottom_appbar.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:readmore/readmore.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({super.key});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  late StoreModel model;
  final storeController = Get.put(StoreController());
  final productController = Get.put(ProductController());

  final double coverHeight = 250;
  final double infoHeight = 200;

  final String discription =
      loremIpsum(words: 30, paragraphs: 2, initWithLorem: true);

  @override
  void initState() {
    super.initState();
    model = Get.arguments['model'];
    model.products = productController.listProducts
        .where((product) => product.storeId == model.storeId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Obx(() => AppBar(
                    backgroundColor: storeController.showAppBar.value
                        ? HAppColor.hBackgroundColor
                        : HAppColor.hTransparentColor,
                    elevation: 0,
                    toolbarHeight: 80,
                    leadingWidth: 80,
                    leading: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: hAppDefaultPadding),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            storeController.showAppBar.value = false;
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
                      ),
                    ),
                    title: AnimatedOpacity(
                      opacity: storeController.showAppBar.value ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(model.imgStore),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      GestureDetector(
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
                          child: const Center(
                            child: Icon(
                              EvaIcons.searchOutline,
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
                  ))),
          body: NestedScrollView(
            controller: storeController.scrollController,
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              storeController.scrollController.addListener(() {
                if (storeController.scrollController.offset >= 300) {
                  storeController.showAppBar.value = true;
                } else {
                  storeController.showAppBar.value = false;
                }
              });
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  expandedHeight: 310,
                  flexibleSpace: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 110),
                            child: Container(
                              color: HAppColor.hGreyColor,
                              child: Image.network(
                                model.imgBackground,
                                width: double.infinity,
                                height: coverHeight,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              top: coverHeight - infoHeight / 2,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                width: HAppSize.deviceWidth -
                                    hAppDefaultPadding * 2,
                                height: infoHeight,
                                decoration: BoxDecoration(
                                  color: HAppColor.hBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        model.imgStore),
                                                    fit: BoxFit.fill)),
                                          ),
                                          gapW10,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                model.name,
                                                style: HAppStyle.heading4Style,
                                              ),
                                              gapH4,
                                              ReadMoreText(
                                                model.category.join(', '),
                                                trimLines: 2,
                                                style: HAppStyle
                                                    .paragraph2Regular
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hGreyColorShade600),
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText:
                                                    'Hiển thị thêm',
                                                trimExpandedText: ' Rút gọn',
                                                moreStyle: HAppStyle.label3Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hBluePrimaryColor),
                                                lessStyle: HAppStyle.label3Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hBluePrimaryColor),
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    EvaIcons.star,
                                                    color:
                                                        HAppColor.hOrangeColor,
                                                    size: 20,
                                                  ),
                                                  gapW2,
                                                  Text.rich(
                                                    TextSpan(
                                                      style: HAppStyle
                                                          .paragraph2Bold,
                                                      text: model.rating
                                                          .toStringAsFixed(1),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '/5 (1k+ Đánh giá)',
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
                                              gapH8,
                                              Row(
                                                children: [
                                                  const Icon(
                                                    EvaIcons.clockOutline,
                                                    size: 20,
                                                    color: HAppColor.hDarkColor,
                                                  ),
                                                  gapW6,
                                                  Text('7:00 AM - 9:00 PM',
                                                      style: HAppStyle
                                                          .paragraph2Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColorShade600)),
                                                  Text(' ┃ ',
                                                      style: HAppStyle
                                                          .paragraph2Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColorShade300)),
                                                  const Icon(
                                                    EneftyIcons
                                                        .location_outline,
                                                    size: 18,
                                                    color: HAppColor.hDarkColor,
                                                  ),
                                                  gapW4,
                                                  Text(
                                                      '${model.distance.toStringAsFixed(1)} Km',
                                                      style: HAppStyle
                                                          .paragraph2Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColorShade600)),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => storeController
                                                .addStoreInFavorited(model),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: HAppColor
                                                        .hGreyColorShade300,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: HAppColor
                                                      .hBackgroundColor),
                                              child: Center(
                                                  child: Obx(
                                                () => !storeController
                                                        .isFavoritedStores
                                                        .contains(model)
                                                    ? const Icon(
                                                        EvaIcons.heartOutline,
                                                        color: HAppColor
                                                            .hGreyColor,
                                                      )
                                                    : const Icon(
                                                        EvaIcons.heart,
                                                        color:
                                                            HAppColor.hRedColor,
                                                      ),
                                              )),
                                            ),
                                          )
                                        ],
                                      )
                                    ]),
                              )),
                        ],
                      ),
                    ],
                  ),
                  bottom: StoreBottomAppBar(),
                )
              ];
            },
            body: TabBarView(
                controller: storeController.tabController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: hAppDefaultPaddingLR,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapH12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Bán chạy",
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController
                                                  .topSellingProducts
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.topSellingProducts
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .topSellingProducts
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list: productController
                                                .topSellingProducts,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Giảm giá",
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController
                                                  .topSaleProducts
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.topSaleProducts
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .topSaleProducts
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list: productController
                                                .topSaleProducts,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            Column(
                              children: [
                                gapH16,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      categories[0],
                                      style: HAppStyle.heading3Style,
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text("Xem tất cả",
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hBluePrimaryColor)),
                                    )
                                  ],
                                ),
                                gapH16,
                                SizedBox(
                                    width: double.infinity,
                                    height: 300,
                                    child: Obx(() => ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productController
                                                      .cate1Products
                                                      .where((product) =>
                                                          product.nameStore ==
                                                          model.name)
                                                      .length >
                                                  10
                                              ? 10
                                              : productController.cate1Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                              child: ProductItemWidget(
                                                storeIcon: false,
                                                model: productController
                                                    .cate1Products
                                                    .where((product) =>
                                                        product.nameStore ==
                                                        model.name)
                                                    .toList()[index],
                                                list: productController
                                                    .cate1Products,
                                                compare: false,
                                              ),
                                            );
                                          },
                                        ))),
                              ],
                            ),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[1],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate2Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate2Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate2Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate2Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[2],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate3Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate3Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate3Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate3Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[3],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate4Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate4Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate4Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate4Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[4],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate5Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate5Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate5Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate5Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[5],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate6Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate6Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate6Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate6Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[6],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate7Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate7Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate7Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate7Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[7],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate8Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate8Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate8Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate8Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[8],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController.cate9Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate9Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate9Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list:
                                                productController.cate9Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[9],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController
                                                  .cate10Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate10Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate10Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list: productController
                                                .cate10Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[10],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController
                                                  .cate11Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate11Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate11Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list: productController
                                                .cate11Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[11],
                                  style: HAppStyle.heading3Style,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Xem tất cả",
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hBluePrimaryColor)),
                                )
                              ],
                            ),
                            gapH16,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController
                                                  .cate12Products
                                                  .where((product) =>
                                                      product.nameStore ==
                                                      model.name)
                                                  .length >
                                              10
                                          ? 10
                                          : productController.cate12Products
                                              .where((product) =>
                                                  product.nameStore ==
                                                  model.name)
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: false,
                                            model: productController
                                                .cate12Products
                                                .where((product) =>
                                                    product.nameStore ==
                                                    model.name)
                                                .toList()[index],
                                            list: productController
                                                .cate12Products,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH24,
                          ]),
                    ),
                  ),
                  const SingleChildScrollView(
                    child: Padding(
                      padding: hAppDefaultPaddingLR,
                      child: Column(
                        children: [
                          gapH12,
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: hAppDefaultPaddingLR,
                      child: Column(
                        children: [
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
                          gapH20,
                          Image.asset('assets/images/other/location.jpg'),
                          gapH10,
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(EvaIcons.pinOutline),
                            title: const Text("Địa chỉ"),
                            subtitle: Text("Hà Nội",
                                style: TextStyle(
                                    color: HAppColor.hGreyColorShade600)),
                          ),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(EvaIcons.phoneOutline),
                            title: const Text("Số điện thoại"),
                            subtitle: Text(
                              "+84388586955",
                              style: TextStyle(
                                  color: HAppColor.hGreyColorShade600),
                            ),
                          ),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(EvaIcons.clockOutline),
                            subtitle: Text(
                                "Mở cửa từ 7:00 AM đến tận 9:00 PM các ngày trong tuần (từ Chủ Nhật)",
                                style: TextStyle(
                                    color: HAppColor.hGreyColorShade600)),
                            title: const Text("Giờ hoạt động"),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ));
  }
}
