import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/banner_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/home_appbar_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/home_category.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/shopping_reminder_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/store_menu.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  final categoryController = Get.put(CategoryController());
  final homeController = Get.put(HomeController());
  final bannerController = Get.put(BannerController());
  final rootController = Get.put(RootController());
  final exploreController = Get.put(ExploreController());
  final productController = Get.put(ProductController());
  final orderController = Get.put(OrderController());

  ScrollController controller = ScrollController();

  final userController = UserController.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              gapH16,
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Obx(() => Padding(
                            padding: hAppDefaultPaddingLR,
                            child: (homeController.reminder.isTrue &&
                                    productController.isInCart.isNotEmpty)
                                ? Column(
                                    children: [
                                      ShoppingReminderWidget(),
                                      gapH16
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
                      gapH16,
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
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(item.image),
                                              fit: BoxFit.fill,
                                            )),
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
                      gapH16,
                      Padding(
                          padding: hAppDefaultPaddingLR,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => orderController.listOder.isNotEmpty
                                  ? Column(
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
                                              "Đơn gần đây",
                                              style: HAppStyle.heading3Style,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    HAppRoutes.listOrder);
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
                                        gapH6,
                                        SizedBox(
                                          height: 190,
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return RecentOrderItemWidget(
                                                  onTap: () {},
                                                  model: orderController
                                                      .listOder[index],
                                                );
                                              },
                                              separatorBuilder: (_, __) =>
                                                  gapW10,
                                              itemCount: orderController
                                                  .listOder.length),
                                        ),
                                        gapH16,
                                      ],
                                    )
                                  : Container()),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Cửa hàng",
                                    style: HAppStyle.heading3Style,
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
                              gapH16,
                              SizedBox(
                                height: 110,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return StoreMenu(
                                        model: listStore[index],
                                      );
                                    },
                                    separatorBuilder: (_, __) => gapW20,
                                    itemCount: listStore.length),
                              ),
                              gapH16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Bán chạy",
                                    style: HAppStyle.heading3Style,
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
                              gapH16,
                              SizedBox(
                                  width: double.infinity,
                                  height: 305,
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
                              gapH16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Giảm giá",
                                    style: HAppStyle.heading3Style,
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
                              gapH16,
                              SizedBox(
                                  width: double.infinity,
                                  height: 305,
                                  child: Obx(() => ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productController
                                                    .topSaleProducts.length >
                                                10
                                            ? 10
                                            : productController
                                                .topSaleProducts.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ProductItemWidget(
                                              storeIcon: true,
                                              model: productController
                                                  .topSaleProducts[index],
                                              list: productController
                                                  .topSaleProducts,
                                              compare: false,
                                            ),
                                          );
                                        },
                                      ))),
                              gapH24
                            ],
                          )),
                    ])),
              )
            ],
          )),
    );
  }

  Future<void> loadingData() async {
    return await Future.delayed(const Duration(seconds: 1), () async {
      Position position = await HAppUtils.getGeoLocationPosition();
      print(HAppUtils.getAddressFromLatLong(position));
    });
  }
}
