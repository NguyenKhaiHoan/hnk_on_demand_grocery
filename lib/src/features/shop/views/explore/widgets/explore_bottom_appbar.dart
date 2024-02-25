import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/custom_chip_widget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ExploreBottomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ExploreBottomAppBar({super.key});

  @override
  State<ExploreBottomAppBar> createState() => _ExploreBottomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(114);
}

class _ExploreBottomAppBarState extends State<ExploreBottomAppBar> {
  final exploreController = Get.put(ExploreController());
  final productController = Get.put(ProductController());

  final itemsSort = ['Mới nhất', 'Thấp - Cao', 'Cao - Thấp'];

  late bool historySelfCategory;
  late List<Tag> historyTagsCategory;

  @override
  void initState() {
    super.initState();
    productController.tagsCategoryObs.value = tagsCategory;
    productController.tagsProductObs.value = tagsProduct;
    historyTagsCategory = productController.tagsCategoryObs
        .map((tag) => Tag(tag.id, tag.title, tag.active))
        .toList();
    loadTenItemList(productController.topSellingProducts);
    exploreController.tabController.addListener(() {
      exploreController.index.value = exploreController.tabController.index;
      load();
    });
    exploreController.scrollController.addListener(() {
      scrollControllerListener();
      if (exploreController.scrollController.position.pixels ==
              exploreController.scrollController.position.maxScrollExtent &&
          !exploreController.isLoadingAdd.value &&
          !exploreController.isLoading.value &&
          productController.listFilterProducts.length >
              productController.tempListFilterProducts.length) {
        loadMore();
      }
    });
  }

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

  void loadMore() {
    exploreController.isLoadingAdd.value = true;
    Future.delayed(const Duration(seconds: 2), () {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: Column(
          children: [
            TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                controller: exploreController.tabController,
                labelStyle: HAppStyle.label3Bold,
                isScrollable: true,
                indicatorColor: HAppColor.hBluePrimaryColor,
                labelColor: HAppColor.hBluePrimaryColor,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Bán chạy',
                  ),
                  Tab(
                    text: 'Giảm giá',
                  ),
                  Tab(
                    text: 'Trái cây',
                  ),
                  Tab(
                    text: 'Rau củ',
                  ),
                  Tab(
                    text: 'Thịt',
                  ),
                  Tab(
                    text: 'Hải sản',
                  ),
                  Tab(
                    text: 'Trứng',
                  ),
                  Tab(
                    text: 'Sữa',
                  ),
                  Tab(
                    text: 'Gia vị',
                  ),
                  Tab(
                    text: 'Hạt',
                  ),
                  Tab(
                    text: 'Bánh mỳ',
                  ),
                  Tab(
                    text: 'Đồ uống',
                  ),
                  Tab(
                    text: 'Ăn vặt',
                  ),
                  Tab(
                    text: 'Mỳ & Gạo',
                  ),
                ]),
            gapH12,
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  hAppDefaultPadding, 0, hAppDefaultPadding, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Obx(() => exploreController.index.value < 2
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showModalBottomSheet(context),
                                child: Container(
                                  height: 42,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HAppColor.hGreyColorShade300,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(children: [
                                    const Text('Danh mục'),
                                    gapW2,
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: HAppColor.hGreyColor.shade700,
                                    )
                                  ]),
                                ),
                              ),
                              gapW10,
                            ],
                          )
                        : Container()),
                    Container(
                      height: 42,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: HAppColor.hGreyColorShade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        padding: EdgeInsets.zero,
                        value: productController.selectedValueSort.value,
                        style: HAppStyle.paragraph2Regular,
                        onChanged: (newValue) => setState(() {
                          productController.selectedValueSort.value = newValue!;
                          load();
                        }),
                        items: itemsSort
                            .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                            .toList(),
                        underline: const SizedBox(),
                      ),
                    ),
                    gapW10,
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Obx(() => CustomChipWidget(
                                title: productController
                                    .tagsProductObs[index].title,
                                active: productController
                                    .tagsProductObs[index].active,
                                onTap: () {
                                  productController
                                          .tagsProductObs[index].active =
                                      !productController
                                          .tagsProductObs[index].active;
                                  setState(() {});
                                  load();
                                }));
                          },
                          separatorBuilder: (_, __) => gapW10,
                          itemCount: productController.tagsProductObs.length),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _showModalBottomSheet(BuildContext context) {
    bool check = false;
    checkApplied();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      backgroundColor: HAppColor.hBackgroundColor,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: hAppDefaultPadding, vertical: hAppDefaultPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Danh mục",
                          style: HAppStyle.heading4Style,
                        ),
                        GestureDetector(
                            onTap: () {
                              for (int index = 0;
                                  index <
                                      productController.tagsCategoryObs.length;
                                  index++) {
                                productController
                                    .tagsCategoryObs[index].active = false;
                              }
                              productController.tagsCategoryObs.refresh();
                              historyTagsCategory = productController
                                  .tagsCategoryObs
                                  .map((tag) =>
                                      Tag(tag.id, tag.title, tag.active))
                                  .toList();
                              checkApplied();
                              Get.back();
                              load();
                            },
                            child: Text(
                              'Xóa danh mục',
                              style: HAppStyle.paragraph2Regular
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            ))
                      ],
                    ),
                    Divider(
                      color: HAppColor.hGreyColorShade300,
                    ),
                    gapH12,
                    Wrap(
                      children: [
                        for (int index = 0;
                            index < productController.tagsCategoryObs.length;
                            index++)
                          Obx(() => GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, right: 5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: productController
                                              .tagsCategoryObs[index].active
                                          ? HAppColor.hBluePrimaryColor
                                          : HAppColor.hBackgroundColor,
                                      border: Border.all(
                                        color: productController
                                                .tagsCategoryObs[index].active
                                            ? HAppColor.hBluePrimaryColor
                                            : HAppColor.hGreyColorShade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      productController
                                          .tagsCategoryObs[index].title,
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color: productController
                                                      .tagsCategoryObs[index]
                                                      .active
                                                  ? HAppColor.hWhiteColor
                                                  : HAppColor.hDarkColor),
                                    )),
                                onTap: () {
                                  if (!productController
                                      .tagsCategoryObs[index].active) {
                                    for (int i = 0;
                                        i <
                                            productController
                                                .tagsCategoryObs.length;
                                        i++) {
                                      if (i != index) {
                                        productController
                                            .tagsCategoryObs[i].active = false;
                                      }
                                    }
                                    productController.tagsCategoryObs.refresh();
                                    productController
                                        .tagsCategoryObs[index].active = true;
                                  } else {
                                    productController
                                            .tagsCategoryObs[index].active =
                                        !productController
                                            .tagsCategoryObs[index].active;
                                  }
                                  checkApplied();
                                },
                              ))
                      ],
                    ),
                    Obx(() => ElevatedButton(
                          onPressed: () {
                            check = true;
                            if (productController.checkApplied.value) {
                              historyTagsCategory = productController
                                  .tagsCategoryObs
                                  .map((tag) =>
                                      Tag(tag.id, tag.title, tag.active))
                                  .toList();
                              load();
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  productController.checkApplied.value
                                      ? HAppColor.hBluePrimaryColor
                                      : HAppColor.hGreyColorShade300,
                              fixedSize: Size(
                                  HAppSize.deviceWidth - hAppDefaultPadding * 2,
                                  50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: Text("Áp dụng",
                              style: HAppStyle.label2Bold.copyWith(
                                  color: productController.checkApplied.value
                                      ? HAppColor.hWhiteColor
                                      : HAppColor.hDarkColor)),
                        )),
                  ]),
            );
          },
        );
      },
    ).then((value) {
      if (!check) {
        productController.tagsCategoryObs.value = historyTagsCategory
            .map((tag) => Tag(tag.id, tag.title, tag.active))
            .toList();
        productController.tagsCategoryObs.refresh();
      }
    });
  }

  void checkApplied() {
    bool sameList = true;

    for (int index = 0;
        index < productController.tagsCategoryObs.length;
        index++) {
      if (productController.tagsCategoryObs[index].active !=
          historyTagsCategory[index].active) {
        sameList = false;
        break;
      }
    }
    if (sameList == false) {
      productController.checkApplied.value = true;
    } else {
      productController.checkApplied.value = false;
    }
  }
}
