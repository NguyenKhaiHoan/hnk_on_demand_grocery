import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistItemScreen extends StatefulWidget {
  const WishlistItemScreen({super.key});

  @override
  State<WishlistItemScreen> createState() => _WishlistItemScreenState();
}

class _WishlistItemScreenState extends State<WishlistItemScreen> {
  final productController = Get.put(ProductController());
  final rootController = Get.put(RootController());

  final String title = Get.arguments['title'];
  final String subtitle = Get.arguments['subtitle'];
  final RxList<ProductModel> list = Get.arguments['list'];

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
        title: Obx(() =>
            list.isNotEmpty ? Text("${title} (${list.length})") : Text(title)),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Row(children: [
          gapW24,
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
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
                    text: subtitle,
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hGreyColorShade600))
              ])),
          gapH10,
          Obx(
            () => GridView.builder(
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
                  storeIcon: true,
                  list: list,
                  compare: false,
                );
              },
            ),
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
              for (var model in list) {
                productController.addProductInCart(model);
                if (model.quantity == 0) {
                  model.quantity++;
                  productController.refreshList(productController.isInCart);
                  productController.refreshAllList();
                }
              }
              list.refresh();
            } else {
              Get.offAllNamed(HAppRoutes.root);
              rootController.animateToScreen(1);
            }
            setState(() {});
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
