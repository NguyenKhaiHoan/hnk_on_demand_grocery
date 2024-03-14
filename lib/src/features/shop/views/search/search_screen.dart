import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/no_found_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/search_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

import '../home/widgets/custom_chip_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = Get.put(SearchProductController());
  final productController = Get.put(ProductController());

  List<String> popularKeywords = [
    "Sữa chua",
    "Táo",
    "Củ cà rốt",
    "Rau xà lách",
    "Cà phê",
    "Tương ớt"
  ];

  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchController.controller.addListener(() {
      if (searchController.controller.text.isEmpty) {
        searchController.showSuffixIcon.value = false;
      } else {
        searchController.showSuffixIcon.value = true;
      }
    });
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                  searchController.resultProduct.clear();
                  searchController.productInSearch.clear();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: const Text("Tìm kiếm"),
        centerTitle: true,
        actions: [
          Padding(
            padding: hAppDefaultPaddingR,
            child: CartCircle(),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: hAppDefaultPaddingLR,
            child: TextField(
              focusNode: focusNode,
              textAlignVertical: TextAlignVertical.center,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                searchController.addHistorySearch();
                searchController
                    .addListProductInSearch(productController.listOfProduct);
                searchController.addMapProductInSearch();
              },
              controller: searchController.controller,
              autofocus: true,
              decoration: InputDecoration(
                  hintStyle: HAppStyle.paragraph1Bold
                      .copyWith(color: HAppColor.hGreyColor),
                  isCollapsed: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          width: 2, color: HAppColor.hBluePrimaryColor)),
                  contentPadding: const EdgeInsets.all(9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          width: 0.8, color: HAppColor.hGreyColorShade300)),
                  hintText: "Bạn muốn tìm gì?",
                  prefixIcon: const Icon(
                    EvaIcons.search,
                    size: 25,
                  ),
                  suffixIcon: Obx(
                    () => searchController.showSuffixIcon.value
                        ? IconButton(
                            onPressed: () {
                              searchController.controller.clear();
                              searchController.resultProduct.clear();
                              searchController.productInSearch.clear();
                            },
                            icon: const Icon(
                              EvaIcons.close,
                              size: 20,
                            ))
                        : Container(
                            width: 0,
                          ),
                  )),
            ),
          ),
          gapH16,
          Obx(() => searchController.resultProduct.isNotEmpty
              ? ListView(
                  shrinkWrap: true,
                  padding: hAppDefaultPaddingLR,
                  children: [
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CustomChipWidget(
                                title: tagsSearch[index].title,
                                active: tagsSearch[index].active,
                                onTap: () {
                                  if (index != 0) {
                                    tagsSearch[index].active =
                                        !tagsSearch[index].active;
                                    if (tagsSearch[index].active == true) {
                                      tagsSearch[0].active = false;
                                    } else {
                                      var listNoActive = tagsSearch
                                          .where((tag) => tag.active == false);
                                      if (listNoActive.length ==
                                          tagsSearch.length) {
                                        tagsSearch[0].active = true;
                                      }
                                    }
                                  }
                                  if (!tagsSearch[0].active) {
                                    searchController.showFilter.value = true;
                                  } else {
                                    searchController.showFilter.value = false;
                                  }
                                  setState(() {});
                                });
                          },
                          separatorBuilder: (_, __) => gapW10,
                          itemCount: tagsSearch.length),
                    ),
                    gapH16,
                    searchController.showFilter.value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  "${searchController.productInSearch.keys.length} Kết quả",
                                  style: HAppStyle.heading4Style,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    tagsSearch[0].active = true;
                                    for (var tag in tagsSearch) {
                                      if (tag.id != 0) {
                                        tag.active = false;
                                      }
                                    }
                                    searchController.showFilter.value = false;
                                    setState(() {});
                                  },
                                  child: const Text("Cài đặt lại"),
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ],
                )
              : Container()),
          Expanded(
              child: SingleChildScrollView(
                  child: Obx(
            () => searchController.resultProduct.isNotEmpty &&
                    searchController.controller.text.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: hAppDefaultPaddingLR,
                    shrinkWrap: true,
                    itemCount: searchController.productInSearch.keys.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: StoreRepository.instance.getStoreInformation(
                              searchController.productInSearch.keys
                                  .elementAt(index)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return const ShimmerExpansionTile();
                                },
                              );
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return Container();
                            } else {
                              final store = snapshot.data!;
                              return ExpansionTile(
                                initiallyExpanded: true,
                                tilePadding: EdgeInsets.zero,
                                shape: const Border(),
                                leading: ImageNetwork(
                                  height: 40,
                                  width: 40,
                                  image: store.storeImage,
                                  onLoading: const CustomShimmerWidget.circular(
                                      width: 40, height: 40),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(children: [
                                  Column(
                                    children: [
                                      Text(store.name),
                                      Text(
                                        "${searchController.productInSearch.values.elementAt(index).length} sản phẩm",
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hGreyColorShade600),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 40,
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          side: BorderSide(
                                              color:
                                                  HAppColor.hGreyColorShade300),
                                        ),
                                        onPressed: () => Get.toNamed(
                                            HAppRoutes.storeDetail,
                                            arguments: {'model': store}),
                                        child: const Text("Ghé thăm")),
                                  )
                                ]),
                                children: [
                                  SizedBox(
                                      width: double.infinity,
                                      height: 300,
                                      child: Obx(() => ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: searchController
                                                        .productInSearch.values
                                                        .elementAt(index)
                                                        .length >
                                                    10
                                                ? 10
                                                : searchController
                                                    .productInSearch.values
                                                    .elementAt(index)
                                                    .length,
                                            itemBuilder:
                                                (BuildContext context, index2) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 10, 0),
                                                child: ProductItemWidget(
                                                  model: searchController
                                                      .productInSearch.values
                                                      .elementAt(index)
                                                      .elementAt(index2),
                                                  compare: false,
                                                ),
                                              );
                                            },
                                          ))),
                                  gapH12,
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(HAppRoutes.searchOnStore,
                                          arguments: {
                                            'nameStore': store.name,
                                            'list': searchController
                                                .productInSearch.values
                                                .elementAt(index)
                                          });
                                    },
                                    child: Container(
                                        width: HAppSize.deviceWidth,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HAppColor.hWhiteColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Xem đầy đủ ${searchController.productInSearch.values.elementAt(index).length} sản phẩm"),
                                            gapW4,
                                            const Icon(
                                              EvaIcons.arrowForwardOutline,
                                              size: 15,
                                            )
                                          ],
                                        )),
                                  ),
                                  gapH12,
                                ],
                              );
                            }
                          });
                    })
                : searchController.controller.text.isNotEmpty
                    ? NotFoundScreenWidget(
                        title: 'Không có kết quả tìm kiếm',
                        subtitle:
                            'Hãy thử nhập tên sản phẩm khác để tìm kiếm. Hãy thử với các tên sản phẩm khác!',
                        widget: Container(),
                        subWidget: Container())
                    : Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(children: [
                          searchController.historySearch.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Lịch sử tìm kiếm",
                                          style: HAppStyle.heading4Style,
                                        ),
                                        TextButton(
                                            onPressed: () => searchController
                                                .removeAllHistorySearch(),
                                            child: Text(
                                              "Xóa",
                                              style: HAppStyle.paragraph2Regular
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hBluePrimaryColor),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                        child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount:
                                          searchController.historySearch.length,
                                      itemBuilder: (context, index) =>
                                          historySearchsItem(index),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              gapH6,
                                    )),
                                    gapH24,
                                  ],
                                )
                              : Container(),
                          popularKeywordsWidget()
                        ]),
                      ),
          )))
        ],
      ),
    ));
  }

  Widget popularKeywordsWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        const Text(
          "Từ khóa phổ biến",
          style: HAppStyle.heading4Style,
        ),
        gapH10,
        Wrap(
          children: [
            for (var keyword in popularKeywords)
              GestureDetector(
                child: Container(
                    margin: const EdgeInsets.only(bottom: 10, right: 5),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: HAppColor.hGreyColorShade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      keyword,
                      style: HAppStyle.paragraph2Regular,
                    )),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  searchController.controller.text = keyword;
                  searchController.addHistorySearch();
                  searchController
                      .addListProductInSearch(productController.listOfProduct);
                  searchController.addMapProductInSearch();
                },
              )
          ],
        ),
      ],
    );
  }

  historySearchsItem(int index) {
    return InkWell(
      onTap: () {},
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        onDismissed: (DismissDirection dir) =>
            searchController.removeHistorySearch(index),
        child: Row(
          children: [
            const Icon(
              EvaIcons.clockOutline,
            ),
            gapW10,
            Text(
              searchController.historySearch[index],
              style: HAppStyle.paragraph2Regular,
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerExpansionTile extends StatelessWidget {
  const ShimmerExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      shape: const Border(),
      leading: const CustomShimmerWidget.circular(width: 40, height: 40),
      title: Row(children: [
        Column(
          children: [
            CustomShimmerWidget.rectangular(
              height: 14,
              width: 70,
            ),
            gapH4,
            CustomShimmerWidget.rectangular(
              height: 12,
              width: 100,
            ),
          ],
        ),
        const Spacer(),
        CustomShimmerWidget.rectangular(
          height: 40,
          width: 80,
        )
      ]),
      children: [
        const ShimmerHorizontalListProductWidget(),
        gapH12,
        CustomShimmerWidget.rectangular(height: 50),
        gapH12,
      ],
    );
  }
}
