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

  final ProductModel model = Get.arguments['model'];

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
            onTap: () => Get.back(),
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
              key: Key(wishlistController.refreshWishlistData.value.toString()),
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
                        if (wishlist.listIds.contains(model.id)) {
                          isAdded.value = true;
                        } else {
                          isAdded.value = false;
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
                                        key: Key(WishlistController.instance
                                            .refreshWishlistItemData.value
                                            .toString()),
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
                                                  items: data
                                                      .map((product) =>
                                                          product.image)
                                                      .toList(),
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
                                        isAdded.value = val!;
                                        if (wishlist.listIds
                                            .contains(model.id)) {
                                          isAdded.value = true;
                                          wishlist.listIds.remove(model.id);
                                        } else {
                                          isAdded.value = false;
                                          wishlist.listIds.add(model.id);
                                        }
                                        wishlistController
                                            .addOrRemoveProductInWishlist(
                                                wishlist.id, wishlist.listIds);
                                      });
                                    }),
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
          // child: ListView.builder(
          //     padding: EdgeInsets.zero,
          //     shrinkWrap: true,
          //     itemCount: productController.productInWishList.keys.length,
          //     itemBuilder: (context, index) {
          //       bool isAdded = false;
          //       if (model.wishlistName.contains(productController
          //           .productInWishList.keys
          //           .elementAt(index))) {
          //         productController.wishlistList[index].isChecked = true;
          //       } else {
          //         productController.wishlistList[index].isChecked = false;
          //       }
          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Expanded(
          //                   child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     productController.productInWishList.keys
          //                         .elementAt(index),
          //                     style: HAppStyle.heading4Style,
          //                   ),
          //                   gapH4,
          //                   Text(
          //                     productController.findSubtitleWishList(
          //                         productController.productInWishList.keys
          //                             .elementAt(index)),
          //                     style: HAppStyle.paragraph3Regular.copyWith(
          //                         color: HAppColor.hGreyColorShade600),
          //                   ),
          //                   productController.productInWishList.values
          //                           .elementAt(index)
          //                           .isNotEmpty
          //                       ? Column(
          //                           children: [
          //                             gapH10,
          //                             ProductListStackWidget(
          //                               maxItems: 8,
          //                               items: productController
          //                                   .productInWishList.values
          //                                   .elementAt(index)
          //                                   .map((product) => product.imgPath)
          //                                   .toList(),
          //                             ),
          //                           ],
          //                         )
          //                       : Container(),
          //                 ],
          //               )),
          //               Checkbox(
          //                   activeColor: HAppColor.hBluePrimaryColor,
          //                   value:
          //                       productController.wishlistList[index].isChecked,
          //                   onChanged: (val) {
          //                     setState(() {
          //                       productController
          //                           .wishlistList[index].isChecked = val!;
          //                       if (productController
          //                           .wishlistList[index].isChecked) {
          //                         if (!model.wishlistName.contains(
          //                             productController.productInWishList.keys
          //                                 .elementAt(index))) {
          //                           model.wishlistName += productController
          //                               .productInWishList.keys
          //                               .elementAt(index);
          //                         }
          //                       } else {
          //                         if (model.wishlistName.contains(
          //                             productController.productInWishList.keys
          //                                 .elementAt(index))) {
          //                           String substr = productController
          //                               .productInWishList.keys
          //                               .elementAt(index);
          //                           String replacement = "";
          //                           model.wishlistName = model.wishlistName
          //                               .replaceAll(substr, replacement);
          //                         }
          //                       }
          //                       productController.listProducts.refresh();
          //                       productController.addMapProductInWishList();
          //                     });
          //                   }),
          //             ],
          //           ),
          //           gapH4,
          //           Divider(
          //             color: HAppColor.hGreyColorShade300,
          //           )
          //         ],
          //       );
          //     }),
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
