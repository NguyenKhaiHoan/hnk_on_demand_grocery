import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
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
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/widgets/list_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>
    with AutomaticKeepAliveClientMixin<ListScreen> {
  @override
  bool get wantKeepAlive => true;
  final productController = Get.put(ProductController());
  final rootController = Get.put(RootController());
  final exploreController = Get.put(ExploreController());
  final storeController = Get.put(StoreController());
  final wishlistController = Get.put(WishlistController());

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
            title: const Text("Danh sách của tôi"),
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
                  Obx(() => productController.isFavoritedProducts.isNotEmpty
                      ? CustomLayoutWidget(
                          widget: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                productController.isFavoritedProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 150,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductItemHorizalWidget(
                                model: productController
                                    .isFavoritedProducts[index],
                                storeIcon: true,
                                list: productController.isFavoritedProducts,
                                compare: false,
                              );
                            },
                          ),
                          subWidget: const EndCustomWidget(),
                        )
                      : NotFoundScreenWidget(
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
                          subWidget: HorizontalListProductWithTitleWidget(
                            list: productController.topSellingProducts,
                            compare: false,
                            storeIcon: true,
                            title: 'Có thể bạn sẽ thích',
                          ),
                        )),
                  Obx(() => storeController.isFavoritedStores.isNotEmpty
                      ? CustomLayoutWidget(
                          widget: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: storeController.isFavoritedStores.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 200,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return StoreItemWidget(
                                  model:
                                      storeController.isFavoritedStores[index]);
                            },
                          ),
                          subWidget: const EndCustomWidget(),
                        )
                      : NotFoundScreenWidget(
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
                          subWidget: HorizontalListStoreWithTitleWidget(
                              list: listStore, title: 'Các cửa hàng nổi bật'))),
                  Obx(() => productController.wishlistList.isNotEmpty
                      ? CustomLayoutWidget(
                          widget: Obx(() => ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: productController
                                  .productInWishList.keys.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productController
                                                  .productInWishList.keys
                                                  .elementAt(index),
                                              style: HAppStyle.heading4Style,
                                            ),
                                            gapH4,
                                            Text(
                                              productController
                                                  .findSubtitleWishList(
                                                      productController
                                                          .productInWishList
                                                          .keys
                                                          .elementAt(index)),
                                              style: HAppStyle.paragraph3Regular
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hGreyColorShade600),
                                            ),
                                            productController
                                                    .productInWishList.values
                                                    .elementAt(index)
                                                    .isNotEmpty
                                                ? Column(
                                                    children: [
                                                      gapH10,
                                                      ProductListStackWidget(
                                                        maxItems: 8,
                                                        items: productController
                                                            .productInWishList
                                                            .values
                                                            .elementAt(index)
                                                            .map((product) =>
                                                                product.imgPath)
                                                            .toList(),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        )),
                                        GestureDetector(
                                          onTap: () => Get.toNamed(
                                              HAppRoutes.wishlistItem,
                                              arguments: {
                                                'title': productController
                                                    .productInWishList.keys
                                                    .elementAt(index),
                                                'subtitle': productController
                                                    .findSubtitleWishList(
                                                        productController
                                                            .productInWishList
                                                            .keys
                                                            .elementAt(index)),
                                                'list': productController
                                                    .productInWishList.values
                                                    .elementAt(index)
                                              }),
                                          child: Text(
                                            'Xem tất cả',
                                            style: HAppStyle.paragraph3Regular
                                                .copyWith(
                                                    color: HAppColor
                                                        .hBluePrimaryColor),
                                          ),
                                        )
                                      ],
                                    ),
                                    gapH4,
                                    Divider(
                                      color: HAppColor.hGreyColorShade300,
                                    )
                                  ],
                                );
                              })),
                          subWidget: Container())
                      : NotFoundScreenWidget(
                          title: 'Bạn chưa có danh sách\nmong ước nào',
                          subtitle:
                              'Ấn nút Tạo ngay ở bên dưới để bắt đầu tạo danh sách mong ước!',
                          widget: Container(),
                          subWidget: Container())),
                  Obx(() => productController
                          .registerNotificationProducts.isNotEmpty
                      ? CustomLayoutWidget(
                          widget: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productController
                                .registerNotificationProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 150,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductItemHorizalWidget(
                                model: productController
                                    .registerNotificationProducts[index],
                                storeIcon: true,
                                list: productController
                                    .registerNotificationProducts,
                                compare: false,
                              );
                            },
                          ),
                          subWidget: const EndCustomWidget())
                      : NotFoundScreenWidget(
                          title:
                              'Bạn chưa đăng ký\nnhận thông báo sản phẩm nào',
                          subtitle:
                              'Với các sản phẩm tạm hết hàng mà bạn quan tâm, hãy ấn biểu tượng chuông để đăng khí nhận thông báo khi có hàng!',
                          widget: Container(),
                          subWidget: Container())),
                ]),
          ),
          floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: _showFab,
            builder: (context, value, child) {
              return value
                  ? FloatingActionButton(
                      backgroundColor: Colors.blue,
                      shape: const CircleBorder(),
                      onPressed: () {
                        openCreateFormWishlish();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : Container();
            },
          ),
        ));
  }

  Future openCreateFormWishlish() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: HAppColor.hBackgroundColor,
            title: const Text('Tạo danh sách mong ước'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: wishlistController.titleController,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: HAppColor.hBluePrimaryColor, width: 2.0),
                  ),
                  hintStyle: HAppStyle.paragraph1Bold
                      .copyWith(color: HAppColor.hGreyColor),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(9),
                  hintText: "Nhập tiêu đề",
                ),
              ),
              gapH10,
              TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: wishlistController.subtitleController,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: HAppColor.hBluePrimaryColor, width: 2.0),
                  ),
                  hintStyle: HAppStyle.paragraph1Bold
                      .copyWith(color: HAppColor.hGreyColor),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(9),
                  hintText: "Nhập mô tả",
                ),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                    var wishlist = Wishlist(
                        title: wishlistController.titleController.text,
                        subTitle: wishlistController.subtitleController.text,
                        isChecked: false);
                    productController.wishlistList.addIf(
                        !productController.wishlistList.contains(wishlist),
                        wishlist);
                    productController.addMapProductInWishList();
                  },
                  child: Text('Tạo',
                      style: HAppStyle.label3Bold
                          .copyWith(color: HAppColor.hDarkColor)))
            ],
          ));
}
