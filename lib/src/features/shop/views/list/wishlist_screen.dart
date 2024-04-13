import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/no_found_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/widgets/wishlist_item_widget.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final wishlistController = Get.put(WishlistController());
  final productController = ProductController.instance;

  final ProductModel? model = Get.arguments['model'];
  final List<ProductInCartModel>? listProductCart =
      Get.arguments['listProductCart'];
  final List<ProductModel>? listProductWishList =
      Get.arguments['listProductWishList'];

  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách mong ước"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 50,
        leading: Padding(
          padding: hAppDefaultPaddingL,
          child: GestureDetector(
            onTap: () {
              if (listProductWishList != null) {
                wishlistController.checkAddWishList(
                    listProductWishList!, check);
              }
              if (model != null) {
                Get.back();
              }
            },
            child: const Icon(
              EvaIcons.close,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: hAppDefaultPaddingLR,
          child: Obx(() => FutureBuilder(
              key: Key(
                  'Wishlist${wishlistController.refreshWishlistData.value.toString()}'),
              future: wishlistController.fetchAllWishlist(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                    child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Container();
                } else {
                  final data = snapshot.data!;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final wishlist = data[index];
                        RxBool isAdded = false.obs;
                        if (model != null) {
                          if (wishlist.listIds.contains(model!.id)) {
                            isAdded.value = true;
                          } else {
                            isAdded.value = false;
                          }
                        }
                        if (listProductCart != null) {
                          isAdded.value = true;
                          int index = 0;
                          for (var model in listProductCart!) {
                            if (!wishlist.listIds.contains(model.productId)) {
                              isAdded.value = false;
                              break;
                            }
                            if (index == listProductCart!.length) {
                              check = true;
                            }
                            index++;
                          }
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      wishlist.title,
                                      style: HAppStyle.heading4Style,
                                    ),
                                    gapH4,
                                    Text(
                                      wishlist.description,
                                      style: HAppStyle.paragraph3Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hGreyColorShade600),
                                    ),
                                    FutureBuilder(
                                        key: Key(
                                            'WishlistItem${WishlistController.instance.refreshWishlistItemData.value.toString()}'),
                                        future: ProductRepository.instance
                                            .getProductsFromListIds(
                                                wishlist.listIds),
                                        builder: ((context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CustomShimmerWidget
                                                .rectangular(height: 60);
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
                                            final data = snapshot.data!;
                                            return Column(
                                              children: [
                                                gapH10,
                                                ProductListStackWidget(
                                                  maxItems: 8,
                                                  items: data,
                                                ),
                                              ],
                                            );
                                          }
                                        })),
                                  ],
                                )),
                                Checkbox(
                                    activeColor: HAppColor.hBluePrimaryColor,
                                    value: isAdded.value,
                                    onChanged: (val) {
                                      setState(() {
                                        wishlistController.refreshWishlistData
                                            .toggle();
                                        isAdded.value = val!;
                                        if (model != null) {
                                          if (wishlist.listIds
                                              .contains(model!.id)) {
                                            isAdded.value = true;
                                            wishlist.listIds.remove(model!.id);
                                          } else {
                                            isAdded.value = false;
                                            wishlist.listIds.add(model!.id);
                                          }
                                          wishlistController
                                              .addOrRemoveProductInWishlist(
                                                  wishlist.id,
                                                  wishlist.listIds);
                                        }
                                        if (listProductCart != null) {
                                          print('Vào đây');
                                          if (!isAdded.value) {
                                            wishlist.listIds.clear();
                                          } else {
                                            wishlist.listIds.assignAll(
                                                listProductCart!
                                                    .map((e) => e.productId)
                                                    .toList());
                                            check = true;
                                          }
                                          wishlistController
                                              .addOrRemoveProductInWishlist(
                                                  wishlist.id,
                                                  wishlist.listIds);
                                        }
                                      });
                                    })
                              ],
                            ),
                            gapH4,
                            Divider(
                              color: HAppColor.hGreyColorShade300,
                            )
                          ],
                        );
                      });
                }
              }))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HAppColor.hBluePrimaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          wishlistController.openCreateFormWishlish();
        },
        child: const Icon(
          EvaIcons.plus,
          color: HAppColor.hWhiteColor,
        ),
      ),
    );
  }
}
