import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/banner_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/chat_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/home_appbar_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/home_category.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/shopping_reminder_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/store_menu.dart';
import 'package:on_demand_grocery/src/features/shop/views/live_tracking/live_tracking_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/list_all_order_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/order_detail_screen.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  final storeController = Get.put(StoreController());
  final productController = ProductController.instance;
  final cartController = Get.put(CartController());
  final homeController = Get.put(HomeController());

  final chatController = Get.put(ChatController());
  final orderController = Get.put(OrderController());
  final rootController = RootController.instance;

  final bannerController = BannerController.instance;
  final categoryController = CategoryController.instance;
  final exploreController = Get.put(ExploreController());

  final storeRepository = Get.put(StoreRepository());

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var query = FirebaseDatabase.instance
        .ref()
        .child('Orders')
        .orderByChild('OrderUserId')
        .equalTo(AuthenticationRepository.instance.authUser!.uid);
    return Scaffold(
      backgroundColor: HAppColor.hBackgroundColor,
      appBar: HomeAppbarWidget(),
      body: LiquidPullToRefresh(
          height: 50,
          color: HAppColor.hBackgroundColor,
          backgroundColor: HAppColor.hBluePrimaryColor,
          animSpeedFactor: 4,
          showChildOpacityTransition: false,
          onRefresh: loadingData,
          child: Column(
            children: [
              Padding(
                padding: hAppDefaultPaddingLR,
                child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          color: HAppColor.hWhiteColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 1, color: HAppColor.hGreyColorShade300)),
                      child: Row(children: [
                        const Icon(
                          EvaIcons.search,
                          size: 25,
                        ),
                        Expanded(
                            child: Center(
                          child: Text("Bạn muốn tìm gì?",
                              style: HAppStyle.paragraph2Bold
                                  .copyWith(color: HAppColor.hGreyColor)),
                        ))
                      ]),
                    ),
                    onTap: () => Get.toNamed(HAppRoutes.search)),
              ),
              gapH12,
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Obx(() => Padding(
                            padding: hAppDefaultPaddingLR,
                            child: (homeController.reminder.isTrue &&
                                    cartController.cartProducts.isNotEmpty)
                                ? Column(
                                    children: [
                                      ShoppingReminderWidget(),
                                      gapH12
                                    ],
                                  )
                                : Container(),
                          )),
                      Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(children: [
                          HomeCategory(),
                        ]),
                      ),
                      gapH12,
                      Obx(() => bannerController.isLoading.value
                          ? Padding(
                              padding: hAppDefaultPaddingLR,
                              child:
                                  CustomShimmerWidget.rectangular(height: 200),
                            )
                          : CarouselSlider(
                              carouselController: bannerController.controller,
                              items: bannerController.listOfBanner
                                  .map((item) => Container(
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: ImageNetwork(
                                          height: 200,
                                          width: HAppSize.deviceWidth,
                                          duration: 500,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onLoading:
                                              CustomShimmerWidget.rectangular(
                                                  height: 200),
                                          onError: const Icon(
                                            Icons.error,
                                            color: HAppColor.hRedColor,
                                          ),
                                          image: item.image,
                                        ),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                height: 200,
                                viewportFraction: (HAppSize.deviceWidth - 38) /
                                    HAppSize.deviceWidth,
                                onPageChanged: (index, reason) =>
                                    bannerController.onPageChanged(index),
                              ),
                            )),
                      gapH12,
                      Padding(
                          padding: hAppDefaultPaddingLR,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => FutureBuilder(
                                    key: Key(
                                        'Orders${orderController.resetToggle.value.toString()}'),
                                    future: query.once(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomShimmerWidget.rectangular(
                                              height: 16,
                                              width: 100,
                                            ),
                                            gapH12,
                                            SizedBox(
                                              height: 210,
                                              child: ListView.separated(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CustomShimmerWidget
                                                        .rectangular(
                                                      height: 210,
                                                      width: 210,
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          gapW12,
                                                  itemCount: 3),
                                            )
                                          ],
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text(
                                              'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.snapshot.value ==
                                              null) {
                                        return Obx(() => orderController
                                                .isLoading.value
                                            ? Column(
                                                children: [
                                                  CustomShimmerWidget
                                                      .rectangular(
                                                    height: 16,
                                                    width: 100,
                                                  ),
                                                  gapH12,
                                                  SizedBox(
                                                    height: 210,
                                                    child: ListView.separated(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CustomShimmerWidget
                                                              .rectangular(
                                                            height: 210,
                                                            width: 210,
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                gapW12,
                                                        itemCount: 3),
                                                  )
                                                ],
                                              )
                                            : orderController.listOder.isEmpty
                                                ? Container()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            "Đơn hàng gần đây",
                                                            style: HAppStyle
                                                                .heading4Style,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Get.to(
                                                                  ListAllOrderScreen());
                                                            },
                                                            child: Text(
                                                                "Xem tất cả",
                                                                style: HAppStyle
                                                                    .paragraph3Regular
                                                                    .copyWith(
                                                                        color: HAppColor
                                                                            .hBluePrimaryColor)),
                                                          ),
                                                        ],
                                                      ),
                                                      gapH12,
                                                      SizedBox(
                                                        height: 210,
                                                        child:
                                                            ListView.separated(
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis
                                                                        .horizontal,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  var order =
                                                                      orderController
                                                                              .listOder[
                                                                          index];
                                                                  return RecentOrderItemWidget(
                                                                    onTap: () => Get.to(
                                                                        () =>
                                                                            OrderDetailScreen(),
                                                                        arguments: {
                                                                          'order':
                                                                              order
                                                                        }),
                                                                    model:
                                                                        order,
                                                                    width: 250,
                                                                  );
                                                                },
                                                                separatorBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        gapW12,
                                                                itemCount:
                                                                    orderController
                                                                        .listOder
                                                                        .length),
                                                      )
                                                    ],
                                                  ));
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Đang hoạt động",
                                                style: HAppStyle.heading4Style,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ListAllOrderScreen());
                                                },
                                                child: Text("Xem tất cả",
                                                    style: HAppStyle
                                                        .paragraph3Regular
                                                        .copyWith(
                                                            color: HAppColor
                                                                .hBluePrimaryColor)),
                                              ),
                                            ],
                                          ),
                                          gapH12,
                                          SizedBox(
                                            height: 210,
                                            child: FirebaseAnimatedList(
                                                shrinkWrap: true,
                                                sort: (a, b) {
                                                  return ((b.value as Map)[
                                                          'OrderDate'] as int)
                                                      .compareTo(((a.value
                                                              as Map)[
                                                          'OrderDate'] as int));
                                                },
                                                scrollDirection:
                                                    Axis.horizontal,
                                                query: query,
                                                itemBuilder: (context, snapshot,
                                                    animation, index) {
                                                  OrderModel order =
                                                      OrderModel.fromJson(
                                                          jsonDecode(jsonEncode(
                                                                  snapshot
                                                                      .value))
                                                              as Map<String,
                                                                  dynamic>);
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                    child:
                                                        RecentOrderItemWidget(
                                                      onTap: () {
                                                        var stepperData =
                                                            OrderController
                                                                .instance
                                                                .listStepData(
                                                                    order);
                                                        Get.to(
                                                            () =>
                                                                const LiveTrackingScreen(),
                                                            arguments: {
                                                              'order': order,
                                                              'stepperData':
                                                                  stepperData
                                                            });
                                                      },
                                                      model: order,
                                                      width: 250,
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      );
                                    }),
                                  )),
                              gapH12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Cửa hàng gần đây",
                                    style: HAppStyle.heading4Style,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rootController.animateToScreen(3);
                                    },
                                    child: Text("Xem tất cả",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  ),
                                ],
                              ),
                              gapH12,
                              SizedBox(
                                height: 110,
                                child: Obx(() => storeController
                                        .isLoadingNearby.value
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Column(children: [
                                            CustomShimmerWidget.rectangular(
                                              height: 80,
                                              width: 90,
                                            ),
                                            gapH4,
                                            CustomShimmerWidget.rectangular(
                                              height: 8,
                                              width: 20,
                                            )
                                          ]);
                                        },
                                        separatorBuilder: (_, __) => gapW20,
                                        itemCount: 3)
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder(
                                            future: StoreRepository.instance
                                                .getStoreInformation(
                                                    storeController
                                                            .allNearbyStoreId[
                                                        index]),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const ShimmerStoreMenu();
                                              }

                                              if (snapshot.hasError) {
                                                return const Center(
                                                  child: Text(
                                                      'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                                                );
                                              }

                                              if (!snapshot.hasData ||
                                                  snapshot.data == null) {
                                                return const Text(
                                                    'Không có cửa hàng nào ở gần đây');
                                              } else {
                                                final store = snapshot.data!;

                                                return StoreMenu(
                                                  model: store,
                                                );
                                              }
                                            },
                                          );
                                        },
                                        separatorBuilder: (_, __) => gapW20,
                                        itemCount: storeController
                                            .allNearbyStoreId.length)),
                              ),
                              gapH12,
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     const Text(
                              //       "Sản phẩm gần đây",
                              //       style: HAppStyle.heading4Style,
                              //     ),
                              //     GestureDetector(
                              //       onTap: () {
                              //         rootController.animateToScreen(1);
                              //         exploreController.animateToTab(0);
                              //       },
                              //       child: Text("Xem tất cả",
                              //           style: HAppStyle.paragraph3Regular
                              //               .copyWith(
                              //                   color: HAppColor
                              //                       .hBluePrimaryColor)),
                              //     )
                              //   ],
                              // ),
                              // gapH12,
                              // Obx(() => productController.isLoadingNearby.value
                              //     ? const ShimmerHorizontalListProductWidget()
                              //     : HorizontalListProductWidget(
                              //         list: productController
                              //             .sortProductByUploadTime(),
                              //         compare: false)),
                              // gapH12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Bán chạy",
                                    style: HAppStyle.heading4Style,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rootController.animateToScreen(1);
                                      exploreController.animateToTab(0);
                                    },
                                    child: Text("Xem tất cả",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  )
                                ],
                              ),
                              gapH12,
                              FutureBuilder(
                                future: ProductRepository.instance
                                    .getTopSellingProducts(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const ShimmerHorizontalListProductWidget();
                                  }

                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                          'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text('Không có sản phẩm');
                                  } else {
                                    final list = snapshot.data!;

                                    return HorizontalListProductWidget(
                                        list: list, compare: false);
                                  }
                                },
                              ),
                              gapH12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Giảm giá",
                                    style: HAppStyle.heading4Style,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rootController.animateToScreen(1);
                                      exploreController.animateToTab(1);
                                    },
                                    child: Text("Xem tất cả",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  )
                                ],
                              ),
                              gapH12,
                              FutureBuilder(
                                future: ProductRepository.instance
                                    .getTopSaleProducts(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const ShimmerHorizontalListProductWidget();
                                  }

                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                          'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text('Không có sản phẩm');
                                  } else {
                                    final list = snapshot.data!;

                                    return HorizontalListProductWidget(
                                        list: list, compare: false);
                                  }
                                },
                              ),
                              gapH100,
                            ],
                          )),
                    ])),
              )
            ],
          )),
    );
  }

  Future<void> loadingData() async {
    categoryController.fetchCategories();
    bannerController.fetchBanners();
    storeController.fetchStores();
    productController.fetchAllProducts();
  }
}
