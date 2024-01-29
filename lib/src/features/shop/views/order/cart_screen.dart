import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/check_box_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/widgets/product_cart.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final productController = Get.put(ProductController());
  bool? check1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              PopupMenuButton(
                  color: HAppColor.hBackgroundColor,
                  surfaceTintColor: HAppColor.hBackgroundColor,
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(productController.allChooseBool.value &&
                                  productController.isInCart.isNotEmpty
                              ? "Bỏ chọn tất cả"
                              : "Chọn tất cả"),
                          onTap: () {
                            productController.changeAllChoose();
                            productController.sumProductMoney();
                            setState(() {});
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("Xóa tất cả"),
                          onTap: () {
                            productController.removeAllProductInCart();
                            productController.refreshAllList();
                            productController.addMapProductInCart();
                            productController.productMoney.value = 0;
                            setState(() {});
                          },
                        ),
                      ],
                  child: const Icon(EvaIcons.moreVerticalOutline)),
              gapW24
            ],
          )
        ],
        title: const Text("Giỏ hàng"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 100,
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
              child: Center(
                child: Icon(
                  EvaIcons.arrowBackOutline,
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: hAppDefaultPaddingLR,
          child: Column(children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Lựa chọn khi hết hàng",
                  style: HAppStyle.heading4Style,
                ),
                gapW6,
                Icon(
                  EvaIcons.infoOutline,
                  size: 15,
                  color: HAppColor.hBluePrimaryColor,
                ),
              ],
            ),
            gapH16,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1.5, color: HAppColor.hGreyColorShade300)),
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: const Row(
                children: [
                  Icon(
                    EvaIcons.flip2Outline,
                    size: 15,
                    color: HAppColor.hBluePrimaryColor,
                  ),
                  gapW10,
                  Expanded(
                    child: Text(
                      "Tôi muốn chọn sản phẩm thay thế (tự chọn)",
                      style: HAppStyle.label2Bold,
                    ),
                  )
                ],
              ),
            ),
            gapH12,
            Obx(
              () => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: productController.productInCart.keys.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      shape: const Border(),
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                    productController.findImgStore(
                                        productController.productInCart.keys
                                            .elementAt(index))),
                                fit: BoxFit.fill)),
                      ),
                      title: Row(children: [
                        Column(
                          children: [
                            Text(productController.productInCart.keys
                                .elementAt(index)),
                            Text(
                                "${productController.productInCart.values.elementAt(index).length} sản phẩm"),
                          ],
                        ),
                        const Spacer(),
                        Checkbox(
                            activeColor: HAppColor.hBluePrimaryColor,
                            value: chooseList[index].value,
                            onChanged: (bool? value) {
                              setState(() {
                                chooseList[index].value = value;

                                if (chooseList[index].value == false) {
                                  productController.allChooseBool.value = false;
                                } else {
                                  final allChose = chooseList
                                      .every((element) => element.value!);
                                  productController.allChooseBool.value =
                                      allChose;
                                }
                              });
                              productController.sumProductMoney();
                            })
                      ]),
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productController.productInCart.values
                              .elementAt(index)
                              .length,
                          itemBuilder: (context, index2) {
                            return ProductCartWidget(
                              model: productController.productInCart.values
                                  .elementAt(index)
                                  .elementAt(index2),
                              list: productController.productInCart.values
                                  .elementAt(index),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              gapH12,
                        )
                      ],
                    );
                  }),
            ),
            gapH24,
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
            hAppDefaultPadding, 20, hAppDefaultPadding, 16),
        decoration: BoxDecoration(
          color: HAppColor.hBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(HAppRoutes.voucher),
              child: Row(
                children: [
                  const Icon(
                    Icons.discount_outlined,
                    color: HAppColor.hBluePrimaryColor,
                  ),
                  gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Áp dụng mã ưu đãi",
                            style: HAppStyle.paragraph1Bold),
                        Obx(
                          () => productController
                                      .voucherAppliedTextAppear!.value &&
                                  productController.applied.value
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    productController.voucherAppliedText.value,
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                      color: HAppColor.hBluePrimaryColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                  ),
                                )
                              : Text("Bạn đang có 2 mã ưu đãi.",
                                  style: HAppStyle.paragraph3Regular.copyWith(
                                      color: HAppColor.hRedColor,
                                      decoration: TextDecoration.none)),
                        )
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )
                ],
              ),
            ),
            gapH24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text.rich(
                    TextSpan(
                      text: "Tiền hàng:\n",
                      children: [
                        TextSpan(
                          text: productController.productMoney.value != 0
                              ? "${productController.productMoney.value}.000₫"
                              : "0₫",
                          style: HAppStyle.heading4Style
                              .copyWith(color: HAppColor.hBluePrimaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (productController.isInCart.isNotEmpty) {
                      Get.toNamed(HAppRoutes.checkout);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(HAppSize.deviceWidth * 0.45, 50),
                    backgroundColor: HAppColor.hBluePrimaryColor,
                  ),
                  child: Text(
                    "Thanh toán",
                    style: HAppStyle.label2Bold
                        .copyWith(color: HAppColor.hWhiteColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
