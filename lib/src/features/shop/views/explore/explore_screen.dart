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

  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
    loadTenItemList(productController.topSellingProducts);
    exploreController.tabController.addListener(() {
      scrollToTop();
      index = exploreController.tabController.index;
      load();
    });

    exploreController.scrollController.addListener(() {
      scrollControllerListener();
      if (exploreController.scrollController.position.pixels ==
              exploreController.scrollController.position.maxScrollExtent &&
          !exploreController.isLoadingAdd.value &&
          !exploreController.isLoading.value) {
        loadMore();
      }
    });
  }

  void loadTenItemList(RxList<ProductModel> list) {
    exploreController.isLoading.value = true;
    productController.listFilterProducts.clear();
    Future.delayed(const Duration(seconds: 2), () {
      for (int i = 0; i < 10; i++) {
        productController.listFilterProducts.add(list[i]);
      }
      productController.oldList = list;
      productController.filterProductSort();
      exploreController.isLoading.value = false;
    });
  }

  void load() {
    if (index == 0) {
      loadTenItemList(productController.topSellingProducts);
    } else if (index == 1) {
      loadTenItemList(productController.topSaleProducts);
    } else if (index == 2) {
      loadTenItemList(productController.cate1Products);
    } else if (index == 3) {
      loadTenItemList(productController.cate2Products);
    } else if (index == 4) {
      loadTenItemList(productController.cate3Products);
    } else if (index == 5) {
      loadTenItemList(productController.cate4Products);
    } else if (index == 6) {
      loadTenItemList(productController.cate5Products);
    } else if (index == 7) {
      loadTenItemList(productController.cate6Products);
    } else if (index == 8) {
      loadTenItemList(productController.cate7Products);
    } else if (index == 9) {
      loadTenItemList(productController.cate8Products);
    } else if (index == 10) {
      loadTenItemList(productController.cate9Products);
    } else if (index == 11) {
      loadTenItemList(productController.cate10Products);
    } else if (index == 12) {
      loadTenItemList(productController.cate11Products);
    } else if (index == 13) {
      loadTenItemList(productController.cate12Products);
    }
  }

  void loadMore() {
    exploreController.isLoadingAdd.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      int temp = 10;
      int substract = productController.oldList.length -
          productController.listFilterProducts.length;
      int start = productController.listFilterProducts.length;
      if (substract > 10) {
        temp = 10;
      } else {
        temp = substract;
      }
      for (int i = start; i < start + temp; i++) {
        productController.listFilterProducts.add(productController.oldList[i]);
        print('load item thứ ${i + 1}');
      }
      exploreController.isLoadingAdd.value = false;
    });
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
                controller: exploreController.tabController,
                children: [
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  Obx(() => exploreController.isLoading.value
                      ? CustomLayoutWidget(
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
                      : productController.listFilterProducts.isNotEmpty
                          ? CustomLayoutWidget(
                              widget: ListProductExploreBuilder(
                                  list: productController.listFilterProducts),
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
                                  'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                              widget: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(HAppSize.deviceWidth * 0.45, 50),
                                    backgroundColor:
                                        HAppColor.hBluePrimaryColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Xóa bộ lọc",
                                    style: HAppStyle.label2Bold
                                        .copyWith(color: HAppColor.hWhiteColor),
                                  )),
                              subWidget: Container(),
                            )),
                  // Obx(() => productController.topSellingProducts.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.topSellingProducts),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.topSaleProducts.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.topSaleProducts),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate1Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate1Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate2Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate2Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate3Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate3Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate4Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate4Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate5Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate5Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate6Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate6Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate7Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate7Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate8Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate8Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate9Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate9Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate10Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate10Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate11Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate11Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
                  // Obx(() => productController.cate12Products.isNotEmpty
                  //     ? CustomLayoutWidget(
                  //         check: true,
                  //         widget: Container(),
                  //         subWidget: ListProductExploreBuilder(
                  //             list: productController.cate12Products),
                  //       )
                  //     : NotFoundScreenWidget(
                  //         title: 'Không có kết quả nào',
                  //         subtitle:
                  //             'Hãy thùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
                  //         widget: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               minimumSize:
                  //                   Size(HAppSize.deviceWidth * 0.45, 50),
                  //               backgroundColor: HAppColor.hBluePrimaryColor,
                  //             ),
                  //             onPressed: () {},
                  //             child: Text(
                  //               "Xóa bộ lọc",
                  //               style: HAppStyle.label2Bold
                  //                   .copyWith(color: HAppColor.hWhiteColor),
                  //             )),
                  //         subWidget: Container(),
                  //       )),
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
                  onPressed: () => scrollToTop())
              : Container()),
        ));
  }

  void scrollToTop() {
    exploreController.scrollController.animateTo(
        exploreController.scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn);
  }
}
