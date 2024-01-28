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
  final orderController = Get.put(ProductController());

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
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount:
                                  orderController.topSellingProducts.length,
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
                                      orderController.topSellingProducts[index],
                                  storeIcon: true,
                                  list: orderController.topSellingProducts,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.topSaleProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.topSaleProducts[index],
                                  storeIcon: true,
                                  list: orderController.topSaleProducts,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate1Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate1Products[index],
                                  storeIcon: true,
                                  list: orderController.cate1Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate2Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate2Products[index],
                                  storeIcon: true,
                                  list: orderController.cate2Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate3Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate3Products[index],
                                  storeIcon: true,
                                  list: orderController.cate3Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate4Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate4Products[index],
                                  storeIcon: true,
                                  list: orderController.cate4Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate5Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate5Products[index],
                                  storeIcon: true,
                                  list: orderController.cate5Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate6Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate6Products[index],
                                  storeIcon: true,
                                  list: orderController.cate6Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate7Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate7Products[index],
                                  storeIcon: true,
                                  list: orderController.cate7Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate8Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate8Products[index],
                                  storeIcon: true,
                                  list: orderController.cate8Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate9Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate9Products[index],
                                  storeIcon: true,
                                  list: orderController.cate9Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate10Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate10Products[index],
                                  storeIcon: true,
                                  list: orderController.cate10Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate11Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate11Products[index],
                                  storeIcon: true,
                                  list: orderController.cate11Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                    child: GetBuilder<ProductController>(
                        builder: (controller) => GridView.builder(
                              itemCount: orderController.cate12Products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 295,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemWidget(
                                  model: orderController.cate12Products[index],
                                  storeIcon: true,
                                  list: orderController.cate12Products,
                                  compare: false,
                                );
                              },
                            )),
                  ),
                ]),
          ),
          floatingActionButton: Obx(() => exploreController.showFab.isTrue
              ? FloatingActionButton(
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
