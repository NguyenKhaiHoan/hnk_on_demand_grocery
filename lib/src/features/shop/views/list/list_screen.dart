import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/list_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final productController = Get.put(ProductController());
  final rootController = Get.put(RootController());
  final exploreController = Get.put(ExploreController());
  final storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 100,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: hAppDefaultPadding),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                        image: AssetImage('assets/logos/logo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            title: const Text("Danh sách của tôi"),
            centerTitle: true,
            actions: [
              Padding(
                padding: hAppDefaultPaddingR,
                child: CartCircle(),
              )
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  expandedHeight: 100,
                  flexibleSpace: Padding(
                    padding: hAppDefaultPaddingLR,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: HAppColor.hWhiteColor,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          width: 1,
                                          color: HAppColor.hGreyColorShade300)),
                                  child: Row(children: [
                                    const Icon(
                                      EvaIcons.search,
                                      size: 25,
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: Text("Bạn muốn tìm gì?",
                                          style: HAppStyle.paragraph2Bold
                                              .copyWith(
                                                  color: HAppColor.hGreyColor)),
                                    ))
                                  ]),
                                ),
                                onTap: () => Get.toNamed(HAppRoutes.search)),
                            gapH12,
                          ],
                        )
                      ],
                    ),
                  ),
                  bottom: ListBottomAppBar(),
                )
              ];
            },
            body: TabBarView(children: [
              Obx(() => productController.isFavoritedProducts.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(
                              hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount: productController
                                    .isFavoritedProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 150,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductItemHorizalWidget(
                                    model: productController
                                        .isFavoritedProducts[index],
                                    storeIcon: true,
                                    list: productController.isFavoritedProducts,
                                    compare: false,
                                  );
                                },
                              ),
                              gapH20,
                              Padding(
                                padding: EdgeInsets.only(
                                    left: HAppSize.deviceWidth * 0.3,
                                    right: HAppSize.deviceWidth * 0.3),
                                child: const Row(children: [
                                  Expanded(child: Divider()),
                                  Text(" Hết "),
                                  Expanded(child: Divider()),
                                ]),
                              )
                            ],
                          )),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Image.asset(
                                  'assets/images/other/nothing.png',
                                  width: HAppSize.deviceWidth * 0.4,
                                ),
                                const Text(
                                  'Bạn chưa chọn thích\nsản phẩm nào',
                                  style: HAppStyle.label2Bold,
                                  textAlign: TextAlign.center,
                                ),
                                gapH10,
                                Text(
                                  'Hãy tiếp tục chọn và đặt hàng các sản phẩm bạn yêu thích nhé! 😊',
                                  style: HAppStyle.paragraph2Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                  textAlign: TextAlign.center,
                                ),
                                gapH24,
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(HAppSize.deviceWidth * 0.45, 50),
                                      backgroundColor:
                                          HAppColor.hBluePrimaryColor,
                                    ),
                                    onPressed: () {
                                      rootController.animateToScreen(0);
                                    },
                                    child: Text(
                                      "Mua sắm ngay!",
                                      style: HAppStyle.label2Bold.copyWith(
                                          color: HAppColor.hWhiteColor),
                                    ))
                              ]),
                            ),
                            gapH40,
                            gapH6,
                            const Text(
                              "Có thể bạn sẽ thích",
                              style: HAppStyle.heading4Style,
                            ),
                            gapH12,
                            SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productController
                                                  .topSellingProducts.length >
                                              10
                                          ? 10
                                          : productController
                                              .topSellingProducts.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: ProductItemWidget(
                                            storeIcon: true,
                                            model: productController
                                                .topSellingProducts[index],
                                            list: productController
                                                .topSellingProducts,
                                            compare: false,
                                          ),
                                        );
                                      },
                                    ))),
                            gapH24
                          ],
                        ),
                      ),
                    )),
              Obx(() => storeController.isFavoritedStores.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(
                              hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    storeController.isFavoritedStores.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 200,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return StoreItemWidget(
                                      model: storeController
                                          .isFavoritedStores[index]);
                                },
                              ),
                              gapH20,
                              Padding(
                                padding: EdgeInsets.only(
                                    left: HAppSize.deviceWidth * 0.3,
                                    right: HAppSize.deviceWidth * 0.3),
                                child: const Row(children: [
                                  Expanded(child: Divider()),
                                  Text(" Hết "),
                                  Expanded(child: Divider()),
                                ]),
                              )
                            ],
                          )),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Image.asset(
                                  'assets/images/other/no_favorited_store.png',
                                  width: HAppSize.deviceWidth * 0.4,
                                ),
                                const Text(
                                  'Bạn chưa chọn thích\ncửa hàng nào',
                                  style: HAppStyle.label2Bold,
                                  textAlign: TextAlign.center,
                                ),
                                gapH10,
                                Text(
                                  'Bạn sẽ có thể nhận được các thông báo như khuyến mãi, giảm giá, ... từ các cửa hàng yêu thích đó! 😊',
                                  style: HAppStyle.paragraph2Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                  textAlign: TextAlign.center,
                                ),
                                gapH24,
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(HAppSize.deviceWidth * 0.45, 50),
                                      backgroundColor:
                                          HAppColor.hBluePrimaryColor,
                                    ),
                                    onPressed: () =>
                                        rootController.animateToScreen(3),
                                    child: Text(
                                      "Yêu thích ngay!",
                                      style: HAppStyle.label2Bold.copyWith(
                                          color: HAppColor.hWhiteColor),
                                    ))
                              ]),
                            ),
                            gapH40,
                            gapH6,
                            const Text(
                              "Tất cả các cửa hàng",
                              style: HAppStyle.heading4Style,
                            ),
                            gapH12,
                            SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listStore.length > 10
                                      ? 10
                                      : listStore.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return StoreItemWidget(
                                      model: listStore[index],
                                    );
                                  },
                                )),
                            gapH24
                          ],
                        ),
                      ),
                    )),
              Obx(() => productController.wishlistList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(
                              hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                          child: Column(
                            children: [
                              Obx(() => ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: productController
                                      .productInWishList.keys.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productController
                                                      .productInWishList.keys
                                                      .elementAt(index),
                                                  style:
                                                      HAppStyle.heading4Style,
                                                ),
                                                gapH4,
                                                Text(
                                                  productController
                                                      .findSubtitleWishList(
                                                          productController
                                                              .productInWishList
                                                              .keys
                                                              .elementAt(
                                                                  index)),
                                                  style: HAppStyle
                                                      .paragraph3Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600),
                                                ),
                                                productController
                                                        .productInWishList
                                                        .values
                                                        .elementAt(index)
                                                        .isNotEmpty
                                                    ? Column(
                                                        children: [
                                                          gapH10,
                                                          ProductListStackWidget(
                                                            maxItems: 8,
                                                            items: productController
                                                                .productInWishList
                                                                .values
                                                                .elementAt(
                                                                    index)
                                                                .map((product) =>
                                                                    product
                                                                        .imgPath)
                                                                .toList(),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            )),
                                            GestureDetector(
                                              onTap: () => Get.toNamed(
                                                  HAppRoutes.wishlistItem,
                                                  arguments: {
                                                    'title': productController
                                                        .productInWishList.keys
                                                        .elementAt(index),
                                                    'subtitle': productController
                                                        .findSubtitleWishList(
                                                            productController
                                                                .productInWishList
                                                                .keys
                                                                .elementAt(
                                                                    index)),
                                                    'list': productController
                                                        .productInWishList
                                                        .values
                                                        .elementAt(index)
                                                  }),
                                              child: Text(
                                                'Xem tất cả',
                                                style: HAppStyle
                                                    .paragraph3Regular
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hBluePrimaryColor),
                                              ),
                                            )
                                          ],
                                        ),
                                        gapH4,
                                        Divider(
                                          color: HAppColor.hGreyColorShade300,
                                        )
                                      ],
                                    );
                                  })),
                              gapH20,
                            ],
                          )),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Column(children: [
                              SizedBox(
                                height: 30 + HAppSize.deviceWidth * 0.4,
                              ),
                              const Text(
                                'Bạn chưa có danh sách\nmong ước nào',
                                style: HAppStyle.label2Bold,
                                textAlign: TextAlign.center,
                              ),
                            ]))
                          ],
                        ),
                      ),
                    )),
              Obx(() => productController
                      .registerNotificationProducts.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(
                              hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount: productController
                                    .registerNotificationProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 150,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductItemHorizalWidget(
                                    model: productController
                                        .registerNotificationProducts[index],
                                    storeIcon: true,
                                    list: productController
                                        .registerNotificationProducts,
                                    compare: false,
                                  );
                                },
                              ),
                              gapH20,
                              Padding(
                                padding: EdgeInsets.only(
                                    left: HAppSize.deviceWidth * 0.3,
                                    right: HAppSize.deviceWidth * 0.3),
                                child: const Row(children: [
                                  Expanded(child: Divider()),
                                  Text(" Hết "),
                                  Expanded(child: Divider()),
                                ]),
                              )
                            ],
                          )),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Column(children: [
                              SizedBox(
                                height: 30 + HAppSize.deviceWidth * 0.4,
                              ),
                              const Text(
                                'Bạn chưa đăng ký\nnhận thông báo sản phẩm nào',
                                style: HAppStyle.label2Bold,
                                textAlign: TextAlign.center,
                              ),
                            ]))
                          ],
                        ),
                      ),
                    )),
            ]),
          ),
        ));
  }
}
