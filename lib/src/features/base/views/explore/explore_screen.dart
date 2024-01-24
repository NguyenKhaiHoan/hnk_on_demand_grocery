import 'dart:ffi';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/base/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/base/views/explore/explore_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/product/views/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final exploreController = Get.put(ExploreController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: topDealProduct.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: topDealProduct[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: topSaleProduct.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: topSaleProduct[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate1Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate1Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate2Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate2Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate3Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate3Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate4Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate4Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate5Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate5Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate6Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate6Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate7Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate7Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate8Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate8Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate9Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate9Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate10Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate10Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate11Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate11Product[index], storeIcon: true);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                    child: GridView.builder(
                      itemCount: cate12Product.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 295,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItemWidget(
                            model: cate12Product[index], storeIcon: true);
                      },
                    ),
                  ),
                ]),
          ),
          floatingActionButton: Obx(() => exploreController.showFab.isTrue
              ? FloatingActionButton(
                  backgroundColor: HAppColor.hBluePrimaryColor,
                  child: Icon(
                    EvaIcons.arrowIosUpward,
                    color: HAppColor.hWhiteColor,
                  ),
                  onPressed: () => exploreController.scrollController.animateTo(
                      exploreController
                          .scrollController.position.minScrollExtent,
                      duration: Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn))
              : Container()),
        ));
  }
}
