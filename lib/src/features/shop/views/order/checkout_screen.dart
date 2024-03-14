import 'dart:math';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/date_delivery_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/recent_oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/widgets/voucher_widget.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selected = 'Tiền mặt';
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final dateDeliveryController = Get.put(DateDeliveryController());
  final orderController = OrderController.instance;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Row(
          children: [
            gapW12,
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
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: hAppDefaultPaddingLR,
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Thông tin giao hàng",
                      style: HAppStyle.heading4Style,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(HAppRoutes.deliveryInfomation),
                      child: Text(
                        "Sửa",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => FutureBuilder(
                          key: Key(
                              addressController.toggleRefresh.value.toString()),
                          future: addressController.fetchAllUserAddresses(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: AddressCheckoutWidget(
                                    model: AddressModel.empty(),
                                  ));
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              if (snapshot.data!.isEmpty) {}
                              return const Text(
                                  'Địa chỉ giao hàng trống, hãy thêm địa chỉ giao hàng.');
                            } else {
                              final addresses = snapshot.data!;
                              return AddressCheckoutWidget(
                                  model: addresses.firstWhere(
                                      (address) => address.selectedAddress,
                                      orElse: () => addresses.first));
                            }
                          }))),
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH4,
                      Obx(() => Text(dateDeliveryController.date.value)),
                    ],
                  ),
                )
              ],
            ),
            gapH24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phương thức thanh toán",
                  style: HAppStyle.heading4Style,
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Cash',
                        groupValue: selected,
                        activeColor: HAppColor.hBluePrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                        title: const Text(
                          "Trả tiền khi nhận hàng",
                          style: HAppStyle.paragraph2Regular,
                        ),
                      ),
                      RadioListTile<String>(
                        activeColor: HAppColor.hBluePrimaryColor,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Momo',
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                        title: const Text(
                          "Ví điện tử Momo",
                          style: HAppStyle.paragraph2Regular,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            gapH24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Chi tiết đơn hàng",
                      style: HAppStyle.heading4Style,
                    ),
                  ],
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                'Tiền hàng (${cartController.cartProducts.length} sản phẩm)',
                                style: HAppStyle.label2Bold,
                              )),
                          Obx(() => Text(HAppUtils.vietNamCurrencyFormatting(
                              cartController.groFastvalue!.value
                                  ? cartController.totalCartPrice.value
                                  : cartController.totalCartPrice.value +
                                      100000))),
                        ],
                      ),
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH6,
                      Row(children: [
                        Expanded(
                          child: ProductListStackWidget(
                            maxItems: 8,
                            items: List<String>.from(cartController.cartProducts
                                .map((product) => product.image)
                                .toList()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        )
                      ]),
                      gapH16,
                      Obx(() => cartController.groFastvalue!.value
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Áp dụng khuyến mãi',
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hGreyColorShade600)),
                                    const Text('-100.000₫'),
                                  ],
                                ),
                                gapH10,
                              ],
                            )
                          : Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phí giao hàng',
                            style: HAppStyle.paragraph2Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
                          ),
                          const Text('0₫'),
                        ],
                      ),
                      gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giảm giá phí giao hàng',
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600)),
                          const Text('0₫'),
                        ],
                      ),
                      gapH10,
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng', style: HAppStyle.label2Bold),
                          Text(
                              HAppUtils.vietNamCurrencyFormatting(
                                  cartController.totalCartPrice.value),
                              style: HAppStyle.label2Bold.copyWith(
                                  color: HAppColor.hBluePrimaryColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                gapH24
              ],
            ),
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
            VoucherWidget(),
            gapH24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Tổng cộng:\n",
                    children: [
                      TextSpan(
                        text: cartController.totalCartPrice.value != 0
                            ? HAppUtils.vietNamCurrencyFormatting(
                                cartController.totalCartPrice.value)
                            : "0₫",
                        style: HAppStyle.heading4Style
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (addressController.selectedAddress.value.phoneNumber ==
                        'Số điện thoại còn trống') {
                      print(
                          addressController.selectedAddress.value.phoneNumber);
                      HAppUtils.showSnackBarWarning('Hoàn thành đầy đủ địa chỉ',
                          'Có vẻ bạn chưa nhập số điện thoại. Hãy nhập số điện thoại để hoàn tất đặt hàng');
                    } else {
                      Get.toNamed(HAppRoutes.complete);
                      cartController.clearCart();
                      // orderController.listOder.add(OrderModel(
                      //     orderId: generateId(6),
                      //     active: 'Đang chờ',
                      //     date: dateDeliveryController.date.value,
                      //     listProduct: cartController.cartProducts,
                      //     price: DummyData.vietNamCurrencyFormatting(
                      //         productController.productMoney.value)));
                      // productController.removeAllProductInCart();
                      // productController.refreshAllList();
                      // productController.addMapProductInCart();
                      // productController.productMoney.value = 0;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(HAppSize.deviceWidth * 0.45, 50),
                    backgroundColor: HAppColor.hBluePrimaryColor,
                  ),
                  child: Text(
                    "Đặt hàng",
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

class AddressCheckoutWidget extends StatelessWidget {
  const AddressCheckoutWidget({
    super.key,
    required this.model,
  });

  final AddressModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.name,
          style: HAppStyle.label2Bold,
        ),
        gapH8,
        Row(
          children: [
            gapW8,
            const Icon(
              EvaIcons.phoneOutline,
              size: 20,
            ),
            gapW8,
            Text(
                model.phoneNumber == ''
                    ? 'Số điện thoại còn trống'
                    : model.phoneNumber,
                style: HAppStyle.paragraph2Regular.copyWith(
                    overflow: TextOverflow.ellipsis,
                    color: model.phoneNumber == ''
                        ? HAppColor.hDarkColor
                        : HAppColor.hRedColor))
          ],
        ),
        gapH8,
        Row(
          children: [
            gapW6,
            const Icon(EvaIcons.homeOutline),
            gapW8,
            Expanded(
              child: Text(
                model.toString(),
                style: HAppStyle.paragraph2Regular,
              ),
            )
          ],
        ),
      ],
    );
  }
}
