import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/base/controllers/home_controller.dart';
import 'package:on_demand_grocery/src/features/base/controllers/tag_controller.dart';
import 'package:on_demand_grocery/src/features/base/models/category_model.dart';
import 'package:on_demand_grocery/src/features/base/models/recent_oder_model.dart';
import 'package:on_demand_grocery/src/features/base/views/home/widgets/category_menu.dart';
import 'package:on_demand_grocery/src/features/base/views/home/widgets/home_appbar_widget.dart';
import 'package:on_demand_grocery/src/features/base/views/home/widgets/recent_order_item_widget.dart';
import 'package:on_demand_grocery/src/features/base/views/home/widgets/shopping_reminder_widget.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/product/views/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  final tagController = Get.put(TagController());

  final List<String> listBanner = [
    "https://www.bigc.vn/files/banners/2022/july-trang/mega/resize-cover-blog-4.jpg",
    "https://statics.vincom.com.vn/uu-dai/1-1702090213.jpg",
    "https://scontent.fhan14-4.fna.fbcdn.net/v/t39.30808-6/279524630_4660714097366794_183406176671654681_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=3635dc&_nc_ohc=wNpQbhy-ZMgAX81nlC-&_nc_ht=scontent.fhan14-4.fna&oh=00_AfBub2gVEthDoRh-CEasB2ellsxaRuE2sDrqI8WKsCwaQQ&oe=65A89E4C",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              gapH12,
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      gapH12,
                      Padding(
                        padding: hAppDefaultPaddingLR,
                        child: ShoppingReminderWidget(),
                      ),
                      gapH24,
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
                      gapH24,
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
                                  Text(
                                    "Đơn gần đây",
                                    style: HAppStyle.heading3Style,
                                  ),
                                  TextButton(
                                    onPressed: () {},
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
                              gapH12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bán chạy",
                                    style: HAppStyle.heading3Style,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Xem tất cả",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  )
                                ],
                              ),
                              gapH12,
                              SizedBox(
                                  width: double.infinity,
                                  height: 286,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: ProductItemWidget(
                                            storeIcon: true,
                                            model: listProduct[index]),
                                      );
                                    },
                                  )),
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
                              gapH12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Cửa hàng",
                                    style: HAppStyle.heading3Style,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Xem tất cả",
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor)),
                                  ),
                                ],
                              ),
                              gapH12,

                              // SizedBox(
                              //   height: 42,
                              //   child: Obx(() => ListView.separated(
                              //       shrinkWrap: true,
                              //       scrollDirection: Axis.horizontal,
                              //       itemBuilder: (context, index) {
                              //         return CustomChipWidget(
                              //             title:
                              //                 tagController.tags[index].title,
                              //             active:
                              //                 tagController.tags[index].active,
                              //             onTap: () {
                              //               tagController.toggleActive(index);
                              //               setState(() {});
                              //             });
                              //       },
                              //       separatorBuilder: (_, __) =>
                              //           const SizedBox(width: 10),
                              //       itemCount: tagController.tags.length)),
                              // )

                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 0.95,
                                crossAxisCount: 4,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 20.0,
                                shrinkWrap: true,
                                children: List.generate(
                                  categoryList.length,
                                  (index) {
                                    return CategoryMenu(
                                      onTap: () {},
                                      model: categoryList[index],
                                    );
                                  },
                                ),
                              ),
                              gapH24
                            ],
                          )),
                    ])),
              )
            ],
          )),
    ));
  }

  Future<void> loadingData() async {
    return await Future.delayed(const Duration(seconds: 2));
  }
}
