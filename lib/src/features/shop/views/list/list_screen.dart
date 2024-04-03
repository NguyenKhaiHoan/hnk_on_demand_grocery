import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/end_custom_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_with_title_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_store_with_title_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/no_found_screen_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/result_wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/widgets/list_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/widgets/wishlist_item_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/repositories/wishlist_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>
    with AutomaticKeepAliveClientMixin<ListScreen> {
  @override
  bool get wantKeepAlive => true;

  final productController = ProductController.instance;
  final rootController = RootController.instance;
  final exploreController = ExploreController.instance;
  final storeController = StoreController.instance;
  final wishlistController = WishlistController.instance;

  late final ValueNotifier<bool> _showFab;

  @override
  void initState() {
    super.initState();
    _showFab = ValueNotifier<bool>(false);
    wishlistController.tabController.addListener(() {
      _showFab.value = wishlistController.tabController.index == 2;
    });
  }

  @override
  void dispose() {
    _showFab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: 4,
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
            title: const Text("Danh sách"),
            centerTitle: true,
            actions: [
              Padding(
                padding: hAppDefaultPaddingR,
                child: CartCircle(),
              )
            ],
          ),
          body: NestedScrollView(
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
                  bottom: ListBottomAppBar(),
                )
              ];
            },
            body: TabBarView(
                controller: wishlistController.tabController,
                children: [
                  Obx(() => FutureBuilder(
                      key: Key(wishlistController.refreshFavoriteData.value
                          .toString()),
                      future: wishlistController.fetchAllFavoriteProductList(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomLayoutWidget(
                            widget: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 150,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return const ShimmerProductItemHorizalWidget();
                              },
                            ),
                            subWidget: const EndCustomWidget(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return NotFoundScreenWidget(
                            title: 'Bạn chưa chọn thích\nsản phẩm nào',
                            subtitle:
                                'Hãy tiếp tục chọn và đặt hàng các sản phẩm bạn yêu thích nhé! 😊',
                            widget: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size(HAppSize.deviceWidth * 0.45, 50),
                                  backgroundColor: HAppColor.hBluePrimaryColor,
                                ),
                                onPressed: () {
                                  rootController.animateToScreen(0);
                                },
                                child: Text(
                                  "Mua sắm ngay!",
                                  style: HAppStyle.label2Bold
                                      .copyWith(color: HAppColor.hWhiteColor),
                                )),
                            subWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  HorizontalListProductWithTitleWidget(
                                    list: productController.listOfProduct
                                        .where((p0) => p0.countBuyed > 100)
                                        .toList(),
                                    compare: false,
                                    storeIcon: true,
                                    title: 'Có thể bạn sẽ thích',
                                  ),
                                  gapH100,
                                ]),
                          );
                        } else {
                          final data = snapshot.data!;
                          return CustomLayoutWidget(
                            widget: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 150,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemHorizalWidget(
                                  model: data[index],
                                  compare: false,
                                );
                              },
                            ),
                            subWidget: const EndCustomWidget(),
                          );
                        }
                      }))),
                  // SingleChildScrollView(),
                  Obx(() => FutureBuilder(
                      key: Key(wishlistController.refreshFavoriteStoreData.value
                          .toString()),
                      future: wishlistController.fetchAllFavoriteStoreList(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomLayoutWidget(
                            widget: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 200,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return const ShimmerStoreItemWidget();
                              },
                            ),
                            subWidget: const EndCustomWidget(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return NotFoundScreenWidget(
                            title: 'Bạn chưa chọn thích\ncửa hàng nào',
                            subtitle:
                                'Bạn sẽ có thể nhận được các thông báo như khuyến mãi, giảm giá, ... từ các cửa hàng yêu thích đó! 😊',
                            widget: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size(HAppSize.deviceWidth * 0.45, 50),
                                  backgroundColor: HAppColor.hBluePrimaryColor,
                                ),
                                onPressed: () =>
                                    rootController.animateToScreen(3),
                                child: Text(
                                  "Yêu thích ngay!",
                                  style: HAppStyle.label2Bold
                                      .copyWith(color: HAppColor.hWhiteColor),
                                )),
                            subWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  HorizontalListStoreWithTitleWidget(
                                      list: storeController.listOfStore,
                                      title: 'Các cửa hàng nổi bật'),
                                  gapH100,
                                ]),
                          );
                        } else {
                          final data = snapshot.data!;
                          return CustomLayoutWidget(
                            widget: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: data.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 200,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return StoreItemWidget(model: data[index]);
                              },
                            ),
                            subWidget: const EndCustomWidget(),
                          );
                        }
                      }))),
                  // SingleChildScrollView(),
                  Obx(() => FutureBuilder(
                      key: Key(wishlistController.refreshWishlistData.value
                          .toString()),
                      future: wishlistController.fetchAllWishlist(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomLayoutWidget(
                              widget: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return const ShimmerWishlistItemWidget();
                                  }),
                              subWidget: Container());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return NotFoundScreenWidget(
                              title: 'Bạn chưa có danh sách\nmong ước nào',
                              subtitle:
                                  'Ấn nút Tạo ngay ở bên dưới để bắt đầu tạo danh sách mong ước!',
                              widget: Container(),
                              subWidget: Container());
                        } else {
                          final data = snapshot.data!;
                          return CustomLayoutWidget(
                              widget: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return WishlistItemWidget(
                                        model: data[index]);
                                  }),
                              subWidget: gapH100);
                        }
                      }))),
                  Obx(() => FutureBuilder(
                      key: Key(wishlistController
                          .refreshRegisterNotificationData.value
                          .toString()),
                      future: wishlistController
                          .fetchAllRegisterNotificationProductList(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomLayoutWidget(
                            widget: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 150,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return const ShimmerProductItemHorizalWidget();
                              },
                            ),
                            subWidget: const EndCustomWidget(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return NotFoundScreenWidget(
                              title:
                                  'Bạn chưa đăng ký\nnhận thông báo sản phẩm nào',
                              subtitle:
                                  'Với các sản phẩm tạm hết hàng mà bạn quan tâm, hãy ấn biểu tượng chuông để đăng khí nhận thông báo khi có hàng!',
                              widget: Container(),
                              subWidget: Container());
                        } else {
                          final data = snapshot.data!;
                          return CustomLayoutWidget(
                            widget: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 150,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItemHorizalWidget(
                                  model: data[index],
                                  compare: false,
                                );
                              },
                            ),
                            subWidget: const EndCustomWidget(),
                          );
                        }
                      }))),
                  // SingleChildScrollView()
                ]),
          ),
          floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: _showFab,
            builder: (context, value, child) {
              return value
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 70),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue,
                        shape: const CircleBorder(),
                        onPressed: () {
                          wishlistController.openCreateFormWishlish();
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        ));
  }
}
