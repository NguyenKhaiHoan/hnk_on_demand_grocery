import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final wishlistController = Get.put(WishlistController());
  final productController = Get.put(ProductController());

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
          child: Column(
            children: [
              Obx(() => ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: productController.productInWishList.keys.length,
                  itemBuilder: (context, index) {
                    if (model.wishlistName.contains(productController
                        .productInWishList.keys
                        .elementAt(index))) {
                      productController.wishlistList[index].isChecked = true;
                    } else {
                      productController.wishlistList[index].isChecked = false;
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
                                  productController.productInWishList.keys
                                      .elementAt(index),
                                  style: HAppStyle.heading4Style,
                                ),
                                gapH4,
                                Text(
                                  productController.findSubtitleWishList(
                                      productController.productInWishList.keys
                                          .elementAt(index)),
                                  style: HAppStyle.paragraph3Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                ),
                                productController.productInWishList.values
                                        .elementAt(index)
                                        .isNotEmpty
                                    ? Column(
                                        children: [
                                          gapH10,
                                          ProductListStackWidget(
                                            maxItems: 8,
                                            items: productController
                                                .productInWishList.values
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
                            Checkbox(
                                activeColor: HAppColor.hBluePrimaryColor,
                                value: productController
                                    .wishlistList[index].isChecked,
                                onChanged: (val) {
                                  setState(() {
                                    productController
                                        .wishlistList[index].isChecked = val!;
                                    if (productController
                                        .wishlistList[index].isChecked) {
                                      if (!model.wishlistName.contains(
                                          productController
                                              .productInWishList.keys
                                              .elementAt(index))) {
                                        model.wishlistName += productController
                                            .productInWishList.keys
                                            .elementAt(index);
                                      }
                                    } else {
                                      if (model.wishlistName.contains(
                                          productController
                                              .productInWishList.keys
                                              .elementAt(index))) {
                                        String substr = productController
                                            .productInWishList.keys
                                            .elementAt(index);
                                        String replacement = "";
                                        model.wishlistName = model.wishlistName
                                            .replaceAll(substr, replacement);
                                      }
                                    }
                                    productController.listProducts.refresh();
                                    productController.addMapProductInWishList();
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
                  }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HAppColor.hBluePrimaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          openCreateFormWishlish();
        },
        child: const Icon(
          EvaIcons.plus,
          color: HAppColor.hWhiteColor,
        ),
      ),
    );
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
