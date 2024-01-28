import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:on_demand_grocery/src/common_widgets/bumble_scroll_bar_flutter.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/category_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/recent_oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/category_menu.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/home_appbar_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/shopping_reminder_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  final rootController = Get.put(RootController());
  final exploreController = Get.put(ExploreController());
  final orderController = Get.put(ProductController());

  late List<String> listBanner = [
    "https://www.bigc.vn/files/banners/2022/july-trang/mega/resize-cover-blog-4.jpg",
    "https://statics.vincom.com.vn/uu-dai/1-1702090213.jpg",
    "https://scontent.fhan14-4.fna.fbcdn.net/v/t39.30808-6/279524630_4660714097366794_183406176671654681_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=3635dc&_nc_ohc=wNpQbhy-ZMgAX81nlC-&_nc_ht=scontent.fhan14-4.fna&oh=00_AfBub2gVEthDoRh-CEasB2ellsxaRuE2sDrqI8WKsCwaQQ&oe=65A89E4C",
  ];

  int itemsPerRow = 7;
  double ratio = 1;
  double widthCategory = HAppSize.deviceWidth * 1.3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HAppColor.hBackgroundColor,
      appBar: const HomeAppbarWidget(),
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
                            child: homeController.reminder.isTrue &&
                                    orderController.isInCart.isNotEmpty
                                ? Column(
                                    children: [
                                      ShoppingReminderWidget(),
                                      gapH16
                                    ],
                                  )
                                : Container(),
                          )),
                      CarouselSlider(
                        carouselController: homeController.controller,
                        items: listBanner
                            .map((item) => Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(item),
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
                              homeController.onPageChanged(index),
                        ),
                      ),
                      gapH16,
                      Padding(
                          padding: hAppDefaultPaddingLR,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Đơn gần đây",
                                    style: HAppStyle.heading3Style,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text("Xem tất cả",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  ),
                                ],
                              ),
                              gapH6,
                              SizedBox(
                                height: 240,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return RecentOrderItemWidget(
                                        onTap: () {},
                                        model: listOder[index],
                                      );
                                    },
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 10),
                                    itemCount: listOder.length),
                              ),
                              gapH16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Danh mục",
                                    style: HAppStyle.heading3Style,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      rootController.animateToScreen(1);
                                      exploreController.animateToTab(0);
                                    },
                                    child: Text("Khám phá",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  ),
                                ],
                              ),
                              gapH16,
                              CustomBumbleScrollbar(
                                  heightContent: (widthCategory / itemsPerRow) *
                                          (categoryList.length / itemsPerRow)
                                              .ceil() *
                                          (1 / ratio) +
                                      60,
                                  child: itemGrid()),
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
                                  height: 300,
                                  child: GetBuilder<ProductController>(
                                      builder: (controller) => ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 10,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 10, 0),
                                                child: ProductItemWidget(
                                                  storeIcon: true,
                                                  model: orderController
                                                          .topSellingProducts[
                                                      index],
                                                  list: orderController
                                                      .topSellingProducts,
                                                  compare: false,
                                                ),
                                              );
                                            },
                                          ))),
                              // SizedBox(
                              //   height: 100,
                              //   child: GridView.builder(
                              //     controller: _scrollController,
                              //     scrollDirection: Axis.horizontal,
                              //     physics: const BouncingScrollPhysics(),
                              //     itemCount: categoryList.length,
                              //     itemBuilder: (context, index) {
                              //       return CategoryMenu(
                              //         onTap: () {},
                              //         model: categoryList[index],
                              //       );
                              //     },
                              //     gridDelegate:
                              //         const SliverGridDelegateWithMaxCrossAxisExtent(
                              //       maxCrossAxisExtent: 100,
                              //       childAspectRatio: 2,
                              //       crossAxisSpacing: 20,
                              //       mainAxisSpacing: 20,
                              //     ),
                              //   ),
                              // ),
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
    return await Future.delayed(const Duration(seconds: 2));
  }

  Widget itemGrid() {
    return SizedBox(
      width: widthCategory,
      child: GridView.builder(
        itemCount: categoryList.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            mainAxisExtent: 82,
            crossAxisCount: itemsPerRow,
            childAspectRatio: ratio),
        itemBuilder: (context, index) {
          return CategoryMenu(
            onTap: () {
              rootController.animateToScreen(1);
              exploreController.animateToTab(index + 2);
            },
            model: categoryList[index],
          );
        },
      ),
    );
  }
}
