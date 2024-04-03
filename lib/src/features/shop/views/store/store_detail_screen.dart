import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_with_title_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/all_store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_location_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/gesture_detector_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_bottom_appbar.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:readmore/readmore.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({super.key});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  StoreModel model = Get.arguments['model'];
  String address = Get.arguments['address'];

  final allStoreController = AllStoreController.instance;
  final productController = ProductController.instance;
  final storeController = StoreController.instance;
  final categoryController = CategoryController.instance;

  final double coverHeight = 250;
  final double infoHeight = 200;

  var storeLocation = StoreLocationModel.empty().obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      storeLocation.value =
          await HLocationService.getLocationOneStore(model.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: GestureDetectorScreen(
          screen: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: Obx(() => AppBar(
                      backgroundColor: allStoreController.showAppBar.value
                          ? HAppColor.hBackgroundColor
                          : HAppColor.hTransparentColor,
                      elevation: 0,
                      toolbarHeight: 80,
                      leadingWidth: 80,
                      leading: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: hAppDefaultPadding),
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              allStoreController.showAppBar.value = false;
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: HAppColor.hGreyColorShade300,
                                    width: 1.5,
                                  ),
                                  color: HAppColor.hBackgroundColor),
                              child: const Center(
                                child: Icon(
                                  EvaIcons.arrowBackOutline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: AnimatedOpacity(
                        opacity: allStoreController.showAppBar.value ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: NetworkImage(model.storeImage),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        GestureDetector(
                          onTap: () => Get.toNamed(
                              HAppRoutes.searchProductInStore,
                              arguments: {
                                'storeId': model.id,
                              }),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: HAppColor.hGreyColorShade300,
                                  width: 1.5,
                                ),
                                color: HAppColor.hBackgroundColor),
                            child: const Center(
                              child: Icon(
                                EvaIcons.searchOutline,
                              ),
                            ),
                          ),
                        ),
                        gapW10,
                        Padding(
                          padding: hAppDefaultPaddingR,
                          child: CartCircle(),
                        )
                      ],
                    ))),
            body: NestedScrollView(
              controller: allStoreController.scrollController,
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                allStoreController.scrollController.addListener(() {
                  if (allStoreController.scrollController.offset >= 300) {
                    allStoreController.showAppBar.value = true;
                  } else {
                    allStoreController.showAppBar.value = false;
                  }
                });
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: true,
                    expandedHeight: 310,
                    flexibleSpace: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 110),
                              child: ImageNetwork(
                                image: model.storeImageBackground,
                                height: coverHeight,
                                width: HAppSize.deviceWidth,
                                duration: 500,
                                curve: Curves.easeIn,
                                onPointer: true,
                                debugPrint: false,
                                fullScreen: false,
                                fitAndroidIos: BoxFit.cover,
                                fitWeb: BoxFitWeb.cover,
                                borderRadius: BorderRadius.circular(0),
                                onLoading: const CircularProgressIndicator(
                                  color: HAppColor.hBluePrimaryColor,
                                ),
                                onError: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Positioned(
                                top: coverHeight - infoHeight / 2,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: HAppSize.deviceWidth -
                                      hAppDefaultPadding * 2,
                                  height: infoHeight,
                                  decoration: BoxDecoration(
                                    color: HAppColor.hBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          model.storeImage),
                                                      fit: BoxFit.fill)),
                                            ),
                                            gapW10,
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  model.name,
                                                  style:
                                                      HAppStyle.heading4Style,
                                                ),
                                                gapH4,
                                                ReadMoreText(
                                                  '${CategoryController.instance.listOfCategory.where((category) => model.listOfCategoryId.contains(category.id)).map((e) => e.name).join(', ').substring(0, 100)}...',
                                                  style: HAppStyle
                                                      .paragraph2Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600),
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText:
                                                      'Hiển thị thêm',
                                                  trimExpandedText: ' Rút gọn',
                                                  moreStyle: HAppStyle
                                                      .label3Bold
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hBluePrimaryColor),
                                                  lessStyle: HAppStyle
                                                      .label3Bold
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hBluePrimaryColor),
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      EvaIcons.star,
                                                      color: HAppColor
                                                          .hOrangeColor,
                                                      size: 20,
                                                    ),
                                                    gapW2,
                                                    Text.rich(
                                                      TextSpan(
                                                        style: HAppStyle
                                                            .paragraph2Bold,
                                                        text: model.rating
                                                            .toStringAsFixed(1),
                                                        children: [
                                                          TextSpan(
                                                            text: '/5',
                                                            style: HAppStyle
                                                                .paragraph2Regular
                                                                .copyWith(
                                                                    color: HAppColor
                                                                        .hGreyColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                gapH8,
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      EvaIcons.clockOutline,
                                                      size: 20,
                                                      color:
                                                          HAppColor.hDarkColor,
                                                    ),
                                                    gapW6,
                                                    Text('7:00 AM - 7:00 PM',
                                                        style: HAppStyle
                                                            .paragraph2Regular
                                                            .copyWith(
                                                                color: HAppColor
                                                                    .hGreyColorShade600)),
                                                    Text(' ┃ ',
                                                        style: HAppStyle
                                                            .paragraph2Regular
                                                            .copyWith(
                                                                color: HAppColor
                                                                    .hGreyColorShade300)),
                                                    const Icon(
                                                      EneftyIcons
                                                          .location_outline,
                                                      size: 18,
                                                      color:
                                                          HAppColor.hDarkColor,
                                                    ),
                                                    gapW4,
                                                    Obx(
                                                      () => storeLocation
                                                                  .value ==
                                                              StoreLocationModel
                                                                  .empty()
                                                          ? CustomShimmerWidget
                                                              .rectangular(
                                                              height: 12,
                                                              width: 30,
                                                            )
                                                          : Text(
                                                              '${HAppUtils.metersToKilometers(storeLocation.value.distance)} Km',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: HAppStyle
                                                                  .paragraph2Regular
                                                                  .copyWith(
                                                                color: HAppColor
                                                                    .hGreyColorShade600,
                                                              )),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () => WishlistController
                                                  .instance
                                                  .addOrRemoveStoreInFavoriteList(
                                                      model.id),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: HAppColor
                                                          .hGreyColorShade300,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: HAppColor
                                                        .hBackgroundColor),
                                                child: Center(
                                                    child: Obx(
                                                  () => !UserController
                                                          .instance
                                                          .user
                                                          .value
                                                          .listOfFavoriteStore!
                                                          .contains(model.id)
                                                      ? const Icon(
                                                          EvaIcons.heartOutline,
                                                          color: HAppColor
                                                              .hGreyColor,
                                                        )
                                                      : const Icon(
                                                          EvaIcons.heart,
                                                          color: HAppColor
                                                              .hRedColor,
                                                        ),
                                                )),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                )),
                          ],
                        ),
                      ],
                    ),
                    bottom: StoreBottomAppBar(),
                  )
                ];
              },
              body: TabBarView(
                  controller: allStoreController.tabController,
                  children: [
                    // SingleChildScrollView(),
                    SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapH12,
                              for (int i = 0;
                                  i < model.listOfCategoryId.length + 2;
                                  i++)
                                FutureBuilder(
                                  future:
                                      productController.fetchProductsByQuery(
                                          storeController
                                              .getProductCategoryForStore(i),
                                          model.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          child:
                                              const ShimmerHorizontalListProductWithTitleWidget());
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
                                      return Container();
                                    } else {
                                      final products = snapshot.data!;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child:
                                            HorizontalListProductWithTitleWidget(
                                                function: () => Get.toNamed(
                                                        HAppRoutes
                                                            .showMoreProductInStore,
                                                        arguments: {
                                                          'id': i,
                                                          'store': model
                                                        }),
                                                list: products,
                                                compare: false,
                                                storeIcon: false,
                                                title: i == 0
                                                    ? 'Bán chạy'
                                                    : i == 1
                                                        ? 'Giảm giá'
                                                        : categoryController
                                                            .listOfCategory[
                                                                int.parse(model
                                                                        .listOfCategoryId[
                                                                    i - 2])]
                                                            .name),
                                      );
                                    }
                                  },
                                ),
                              gapH24,
                            ]),
                      ),
                    ),
                    const SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                          children: [
                            gapH12,
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: hAppDefaultPaddingLR,
                        child: Column(
                          children: [
                            gapH12,
                            ReadMoreText(
                              model.description,
                              trimLength: 100,
                              trimLines: 2,
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Hiển thị thêm',
                              trimExpandedText: ' Rút gọn',
                              moreStyle: HAppStyle.label3Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                              lessStyle: HAppStyle.label3Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            ),
                            gapH20,
                            Image.asset('assets/images/other/location.jpg'),
                            gapH10,
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(EvaIcons.pinOutline),
                              title: const Text("Địa chỉ"),
                              subtitle: Text(address,
                                  style: TextStyle(
                                      color: HAppColor.hGreyColorShade600)),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(EvaIcons.phoneOutline),
                              title: const Text("Số điện thoại"),
                              subtitle: Text(
                                model.phoneNumber,
                                style: TextStyle(
                                    color: HAppColor.hGreyColorShade600),
                              ),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(EvaIcons.clockOutline),
                              subtitle: Text(
                                  "Mở cửa từ 7:00 AM đến tận 9:00 PM các ngày trong tuần (từ Chủ Nhật)",
                                  style: TextStyle(
                                      color: HAppColor.hGreyColorShade600)),
                              title: const Text("Giờ hoạt động"),
                            ),
                            gapH24,
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
