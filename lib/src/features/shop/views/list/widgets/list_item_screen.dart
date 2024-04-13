import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class WishlistItemScreen extends StatefulWidget {
  const WishlistItemScreen({super.key});

  @override
  State<WishlistItemScreen> createState() => _WishlistItemScreenState();
}

class _WishlistItemScreenState extends State<WishlistItemScreen> {
  final productController = ProductController.instance;
  final rootController = RootController.instance;
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());

  final WishlistModel model = Get.arguments['model'];
  final List<ProductModel> list = Get.arguments['list'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: hAppDefaultPaddingR,
            child: CartCircle(),
          )
        ],
        title: Text(
            list.isEmpty ? model.title : "${model.title} (${list.length})"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Row(children: [
          gapW16,
          GestureDetector(
            onTap: () => Get.back(),
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
        ]),
      ),
      body: SingleChildScrollView(
        padding: hAppDefaultPaddingLR,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text.rich(TextSpan(
              style: HAppStyle.heading4Style,
              text: "Mô tả: ",
              children: [
                TextSpan(
                    text: model.description,
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hGreyColorShade600))
              ])),
          gapH10,
          GridView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              mainAxisExtent: 150,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProductItemHorizalWidget(
                model: list[index],
                compare: false,
              );
            },
          )
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
            hAppDefaultPadding, 10, hAppDefaultPadding, 10),
        height: 70,
        color: HAppColor.hTransparentColor,
        child: ElevatedButton(
          onPressed: () {
            if (list.isNotEmpty) {
              showDialog(
                context: Get.overlayContext!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thêm vào Giỏ hàng'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bạn có muốn thêm tất cả sản phẩm trong danh sách mong ước hiện tại vào Giỏ hàng không?',
                            style: HAppStyle.paragraph2Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
                          ),
                        ]),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          if (cartController.cartProducts.isNotEmpty) {
                            showDialog(
                              context: Get.overlayContext!,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Thêm vào danh sách mong ước'),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bạn đang có ${cartController.numberOfCart} sản phẩm trong giỏ hàng. Bạn muốn xóa tất cả và lưu lại các sản phẩm hiện có trong giỏ hàng vào danh sách mong ước không?',
                                          style: HAppStyle.paragraph2Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                      ]),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        for (var product
                                            in cartController.cartProducts) {
                                          print(
                                              'cartController.cartProducts: ${product.productName}');
                                        }
                                        Get.toNamed(HAppRoutes.wishlist,
                                            arguments: {
                                              'listProductCart':
                                                  cartController.cartProducts,
                                              'listProductWishList': list
                                            });
                                      },
                                      child: Text(
                                        'Có',
                                        style: HAppStyle.label4Bold.copyWith(
                                            color: HAppColor.hBluePrimaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        wishlistController.addToCart(list);
                                      },
                                      child: Text(
                                        'Không',
                                        style: HAppStyle.label4Bold.copyWith(
                                            color: HAppColor.hRedColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'Có',
                          style: HAppStyle.label4Bold
                              .copyWith(color: HAppColor.hBluePrimaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Không',
                          style: HAppStyle.label4Bold
                              .copyWith(color: HAppColor.hRedColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Get.toNamed(HAppRoutes.root);
              rootController.animateToScreen(1);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(HAppSize.deviceWidth - 48, 50),
            backgroundColor: HAppColor.hBluePrimaryColor,
          ),
          child: list.isNotEmpty
              ? Text("Chuyển tới Giỏ hàng",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor))
              : Text("Thêm vào Danh sách mong ước ngay",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor)),
        ),
      ),
    );
  }
}
