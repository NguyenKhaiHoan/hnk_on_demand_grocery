import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/explore_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final exploreController = Get.put(ExploreController());
  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      exploreController.scrollController
          .addListener(() => scrollControllerListener());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  scrollControllerListener() {
    if (exploreController.scrollController.offset >= 100) {
      exploreController.showFab.value = true;
    } else {
      exploreController.showFab.value = false;
    }
  }

  List<String> listExplore = [
    'Bán chạy',
    'Giảm giá',
    'Trái cây',
    'Rau củ',
    'Thịt',
    'Hải sản',
    'Trứng',
    'Sữa',
    'Gia vị',
    'Hạt',
    'Bánh mỳ',
    'Đồ uống',
    'Ăn vặt',
    'Mỳ & Gạo',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: listExplore.length,
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
            title: const Text("Khám phá"),
            centerTitle: true,
            actions: [
              Padding(
                padding: hAppDefaultPaddingR,
                child: CartCircle(),
              )
            ],
          ),
          body: NestedScrollView(
            controller: exploreController.scrollController,
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
                  bottom: ExploreBottomAppBar(),
                )
              ];
            },
            body: TabBarView(
                controller: exploreController.tabController,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount:
                              productController.topSellingProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model:
                                  productController.topSellingProducts[index],
                              storeIcon: true,
                              list: productController.topSellingProducts,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.topSaleProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.topSaleProducts[index],
                              storeIcon: true,
                              list: productController.topSaleProducts,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate1Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate1Products[index],
                              storeIcon: true,
                              list: productController.cate1Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate2Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate2Products[index],
                              storeIcon: true,
                              list: productController.cate2Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate3Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate3Products[index],
                              storeIcon: true,
                              list: productController.cate3Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate4Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate4Products[index],
                              storeIcon: true,
                              list: productController.cate4Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate5Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate5Products[index],
                              storeIcon: true,
                              list: productController.cate5Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate6Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate6Products[index],
                              storeIcon: true,
                              list: productController.cate6Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate7Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate7Products[index],
                              storeIcon: true,
                              list: productController.cate7Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate8Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate8Products[index],
                              storeIcon: true,
                              list: productController.cate8Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate9Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate9Products[index],
                              storeIcon: true,
                              list: productController.cate9Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate10Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate10Products[index],
                              storeIcon: true,
                              list: productController.cate10Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate11Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate11Products[index],
                              storeIcon: true,
                              list: productController.cate11Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: Obx(() => GridView.builder(
                          itemCount: productController.cate12Products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 295,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItemWidget(
                              model: productController.cate12Products[index],
                              storeIcon: true,
                              list: productController.cate12Products,
                              compare: false,
                            );
                          },
                        )),
                  ),
                ]),
          ),
          floatingActionButton: Obx(() => exploreController.showFab.isTrue
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: HAppColor.hBluePrimaryColor,
                  child: const Icon(
                    EvaIcons.arrowIosUpward,
                    color: HAppColor.hWhiteColor,
                  ),
                  onPressed: () => exploreController.scrollController.animateTo(
                      exploreController
                          .scrollController.position.minScrollExtent,
                      duration: const Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn))
              : Container()),
        ));
  }
}
