import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/no_found_screen_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
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

  final exploreController = ExploreController.instance;
  final productController = ProductController.instance;
  final categoryController = CategoryController.instance;
  final cartController = CartController.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final lengthExploreTab = categoryController.listOfCategory.length + 2;
    return DefaultTabController(
        length: lengthExploreTab,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 80,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: hAppDefaultPadding),
                child: UserImageLogoWidget(
                  size: 40,
                  hasFunction: true,
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
            body: TabBody(tabNumber: exploreController.tabController.index),
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

class TabBody extends StatefulWidget {
  final int tabNumber;
  const TabBody({required this.tabNumber, super.key});

  @override
  State<TabBody> createState() => _TabBodyState();
}

class _TabBodyState extends State<TabBody> {
  final exploreController = ExploreController.instance;
  final productController = ProductController.instance;
  final categoryController = CategoryController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => FutureBuilder(
        key: Key(exploreController.refreshData.value.toString()),
        future: productController.fetchProductsByQuery(
            productController
                .getFutureQuery(exploreController.tabController.index),
            null),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomLayoutWidget(
              widget: const ShimmerListProductExploreBuilder(),
              subWidget: Container(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return NotFoundScreenWidget(
              title: 'Không có kết quả nào',
              subtitle: 'Các sản phẩm không có ở đây :(',
              widget: Container(),
              subWidget: Container(),
            );
          } else {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return NotFoundScreenWidget(
                title: 'Không có kết quả nào',
                subtitle:
                    'Hãy xóa các lựa chọn để tìm thêm các sản phẩm phù hợp nhất :)',
                widget: Container(),
                subWidget: Container(),
              );
            }
            return CustomLayoutWidget(
              widget: ListProductExploreBuilder(
                list: data,
                compare: false,
              ),
              subWidget: const SizedBox(height: 100 - 16),
            );
          }
        })));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(() => exploreController.isLoading.value
  //       ? CustomLayoutWidget(
  //           check: true,
  //           widget: GridView.builder(
  //             shrinkWrap: true,
  //             itemCount: 10,
  //             physics: const NeverScrollableScrollPhysics(),
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               crossAxisSpacing: 10.0,
  //               mainAxisSpacing: 10.0,
  //               mainAxisExtent: 295,
  //             ),
  //             itemBuilder: (BuildContext context, int index) {
  //               return Shimmer.fromColors(
  //                 baseColor: Colors.grey.shade300,
  //                 highlightColor: Colors.grey.shade100,
  //                 child: ProductItemWidget(
  //                   model: productController.listOfProduct[index],
  //                   storeIcon: true,
  //                   compare: false,
  //                 ),
  //               );
  //             },
  //           ),
  //           subWidget: Container(),
  //         )
  //       : productController.tempListFilterProducts.isNotEmpty
  //           ? CustomLayoutWidget(
  //               check: true,
  //               widget: ListProductExploreBuilder(
  //                 list: productController.tempListFilterProducts,
  //                 storeIcon: true,
  //                 compare: false,
  //               ),
  //               subWidget: exploreController.isLoadingAdd.value
  //                   ? const SizedBox(
  //                       height: 60,
  //                       child: Center(
  //                         child: CircularProgressIndicator(
  //                           color: HAppColor.hBluePrimaryColor,
  //                         ),
  //                       ),
  //                     )
  //                   : Container(),
  //             )
  //           : NotFoundScreenWidget(
  //               title: 'Không có kết quả nào',
  //               subtitle:
  //                   'Hãy tùy chỉnh hoặc xóa bộ lọc để ra các kết quả phù hợp',
  //               widget: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     minimumSize: Size(HAppSize.deviceWidth * 0.45, 50),
  //                     backgroundColor: HAppColor.hBluePrimaryColor,
  //                   ),
  //                   onPressed: () {
  //                     for (var tag in productController.tagsCategoryObs) {
  //                       tag.active = false;
  //                     }
  //                     productController.tagsCategoryObs.refresh();
  //                     for (var tag in productController.tagsProductObs) {
  //                       tag.active = false;
  //                     }
  //                     productController.tagsProductObs.refresh();
  //                     productController.selectedValueSort.value = 'Mới nhất';
  //                     setState(() {});
  //                     load();
  //                   },
  //                   child: Text(
  //                     "Xóa bộ lọc",
  //                     style: HAppStyle.label2Bold
  //                         .copyWith(color: HAppColor.hWhiteColor),
  //                   )),
  //               subWidget: Container(),
  //             ));
  // }
}
