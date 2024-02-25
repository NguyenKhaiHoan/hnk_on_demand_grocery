import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/no_found_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/explore_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/list_product_explore_builder.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:shimmer/shimmer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;
  final exploreController = Get.put(ExploreController());
  final productController = Get.put(ProductController());

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

  void loadTenItemList(RxList<ProductModel> list) {
    exploreController.isLoading.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      productController.tempListFilterProducts.clear();
      productController.filterProduct(list, exploreController.index.value);
      int temp = 0;
      int substract = productController.listFilterProducts.length -
          productController.tempListFilterProducts.length;
      if (substract > 10) {
        temp = 10;
      } else {
        temp = substract;
      }
      for (int i = 0; i < temp; i++) {
        productController.tempListFilterProducts
            .add(productController.listFilterProducts[i]);
      }
      exploreController.isLoading.value = false;
    });
  }

  void load() {
    exploreController.scrollToTop();
    if (exploreController.index.value == 0) {
      loadTenItemList(productController.topSellingProducts);
    } else if (exploreController.index.value == 1) {
      loadTenItemList(productController.topSaleProducts);
    } else if (exploreController.index.value == 2) {
      loadTenItemList(productController.cate1Products);
    } else if (exploreController.index.value == 3) {
      loadTenItemList(productController.cate2Products);
    } else if (exploreController.index.value == 4) {
      loadTenItemList(productController.cate3Products);
    } else if (exploreController.index.value == 5) {
      loadTenItemList(productController.cate4Products);
    } else if (exploreController.index.value == 6) {
      loadTenItemList(productController.cate5Products);
    } else if (exploreController.index.value == 7) {
      loadTenItemList(productController.cate6Products);
    } else if (exploreController.index.value == 8) {
      loadTenItemList(productController.cate7Products);
    } else if (exploreController.index.value == 9) {
      loadTenItemList(productController.cate8Products);
    } else if (exploreController.index.value == 10) {
      loadTenItemList(productController.cate9Products);
    } else if (exploreController.index.value == 11) {
      loadTenItemList(productController.cate10Products);
    } else if (exploreController.index.value == 12) {
      loadTenItemList(productController.cate11Products);
    } else if (exploreController.index.value == 13) {
      loadTenItemList(productController.cate12Products);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: listExplore.length,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 80,
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
                  expandedHeight: 164,
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
                  bottom: const ExploreBottomAppBar(),
                )
              ];
            },
            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: exploreController.tabController,
                children: [
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
                          check: true,
                          widget: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 295,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ProductItemWidget(
                                  model: productController.listProducts[index],
                                  storeIcon: true,
                                  list: productController.listProducts,
                                  compare: false,
                                ),
                              );
                            },
                          ),
                          subWidget: Container(),
                        )
                      : productController.tempListFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              check: true,
                              widget: ListProductExploreBuilder(
                                list: productController.tempListFilterProducts,
                                storeIcon: true,
                                compare: false,
                              ),
                              subWidget: exploreController.isLoadingAdd.value
                                  ? const SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          : NotFoundScreenWidget(
                              title: 'Không có kết quả nào',
                              subtitle:
                                  'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {
                                    for (var tag
                                        in productController.tagsCategoryObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    for (var tag
                                        in productController.tagsProductObs) {
                                      tag.active = false;
                                    }
                                    productController.tagsProductObs.refresh();
                                    productController.selectedValueSort.value =
                                        'Mới nhất';
                                    setState(() {});
                                    load();
                                  },
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
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
                  onPressed: () => exploreController.scrollToTop())
              : Container()),
        ));
  }
}
