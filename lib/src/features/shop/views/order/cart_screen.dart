import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/widgets/product_cart.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/widgets/voucher_widget.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final productController = ProductController.instance;
  final cartController = Get.put(CartController());
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
                            child: const Text("Xóa tất cả"),
                            onTap: () {
                              cartController.clearCart();
                              cartController.updateCart();
                              HAppUtils.showSnackBarSuccess('Xóa khỏi giỏ hàng',
                                  'Bạn đã xóa thành công tất cả sản phẩm trong giỏ hàng');
                            },
                          ),
                        ],
                    child: const Icon(EvaIcons.moreVerticalOutline)),
                gapW12
              ],
            )
          ],
          title: Obx(() => cartController.cartProducts.isNotEmpty
              ? Text("Giỏ hàng (${cartController.numberOfCart})")
              : const Text("Giỏ hàng")),
          centerTitle: true,
          toolbarHeight: 80,
          leadingWidth: 100,
          leading: Row(
            children: [
              gapW12,
              GestureDetector(
                onTap: () {
                  if (cartController.isReorder.value) {
                    showDialog(
                      context: Get.overlayContext!,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Hủy đặt lại đơn hàng'),
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bạn chắc chắn muốn hủy đặt lại đơn hàng không?',
                                  style: HAppStyle.paragraph2Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                ),
                              ]),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cartController.isReorder.value = false;
                                cartController.loadCartData();
                                Get.back();
                                Get.back();
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
                    Get.back();
                  }
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
              )
            ],
          ),
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
              Obx(() {
                if (cartController.cartProducts.isEmpty) {
                  return Container();
                }
                return SingleChildScrollView(
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartController.productInCartMap.keys.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: StoreRepository.instance
                                .getStoreInformation(cartController
                                    .productInCartMap.keys
                                    .elementAt(index)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }

                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                      'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data == null) {
                                return Container();
                              } else {
                                final store = snapshot.data!;
                                return ExpansionTile(
                                  childrenPadding: EdgeInsets.zero,
                                  initiallyExpanded: true,
                                  tilePadding: EdgeInsets.zero,
                                  shape: const Border(),
                                  leading: ImageNetwork(
                                    height: 40,
                                    width: 40,
                                    image: store.storeImage,
                                    onLoading:
                                        const CustomShimmerWidget.circular(
                                            width: 40, height: 40),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(store.name),
                                        GestureDetector(
                                          onTap: () => cartController
                                              .showModalBottomSheetStoreOrder(
                                                  context,
                                                  cartController.storeOrderMap[
                                                      store.id]!),
                                          child: Row(children: [
                                            Icon(
                                              EvaIcons.edit2Outline,
                                              size: 10,
                                              color:
                                                  HAppColor.hGreyColorShade600,
                                            ),
                                            gapW4,
                                            Text(
                                              'Thêm ghi chú',
                                              style: HAppStyle.paragraph2Regular
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hGreyColorShade600),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Obx(() {
                                      RxBool check = cartController
                                          .storeOrderMap[store.id]!
                                          .checkChooseInCart
                                          .obs;
                                      return Checkbox(
                                          activeColor:
                                              HAppColor.hBluePrimaryColor,
                                          value: check.value,
                                          onChanged: (value) {
                                            check.value = value!;
                                            cartController
                                                .storeOrderMap[store.id]!
                                                .checkChooseInCart = value;
                                            cartController.updateCart();
                                          });
                                    })
                                  ]),
                                  children: [
                                    ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: cartController
                                            .productInCartMap.values
                                            .elementAt(index)
                                            .length,
                                        itemBuilder: (context, index2) {
                                          return ProductCartWidget(
                                              model: cartController
                                                  .productInCartMap.values
                                                  .elementAt(index)
                                                  .elementAt(index2));
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                gapH12),
                                    // Text(cartController.productInCartMap.values
                                    //     .elementAt(index)
                                    //     .toString()),
                                    gapH12,
                                  ],
                                );
                              }
                            });
                      }),
                );
                // return SingleChildScrollView(
                //   child: ListView.separated(
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: cartController.cartProducts.length,
                //       itemBuilder: (context, index) {
                //         return ProductCartWidget(
                //             model: cartController.cartProducts[index]);
                //       },
                //       separatorBuilder: (BuildContext context, int index) =>
                //           gapH12),
                // );
              }),
              gapH24,
            ]),
          ),
        ),
        bottomNavigationBar: Obx(() => cartController.cartProducts.isNotEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(
                    hAppDefaultPadding, 20, hAppDefaultPadding, 16),
                decoration: BoxDecoration(
                  color: HAppColor.hBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -15),
                      blurRadius: 20,
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text.rich(
                              TextSpan(
                                text: "Tổng cộng:\n",
                                children: [
                                  TextSpan(
                                    text: cartController.totalCartPrice.value !=
                                            0
                                        ? HAppUtils.vietNamCurrencyFormatting(
                                            cartController.totalCartPrice.value)
                                        : "0₫",
                                    style: HAppStyle.heading4Style.copyWith(
                                        color: HAppColor.hBluePrimaryColor),
                                  ),
                                ],
                              ),
                            )),
                        ElevatedButton(
                          onPressed: () {
                            if (cartController.cartProducts.isNotEmpty &&
                                cartController.numberOfCart.value != 0) {
                              Get.toNamed(HAppRoutes.checkout);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(HAppSize.deviceWidth * 0.45, 50),
                            backgroundColor: HAppColor.hBluePrimaryColor,
                          ),
                          child: cartController.cartProducts.isNotEmpty
                              ? Text(
                                  "Thanh toán (${cartController.numberOfCart.value})",
                                  style: HAppStyle.label2Bold
                                      .copyWith(color: HAppColor.hWhiteColor))
                              : Text("Thanh toán",
                                  style: HAppStyle.label2Bold
                                      .copyWith(color: HAppColor.hWhiteColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              )));
  }
}
