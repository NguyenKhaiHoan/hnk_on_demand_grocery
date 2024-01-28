import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selected = 'Tiền mặt';
  final orderController = Get.put(ProductController());

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
                    Text(
                      "Sửa",
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hBluePrimaryColor),
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
                      const Text(
                        "Nguyễn Khải Hoàn",
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
                          Text("0388586955",
                              style: HAppStyle.paragraph2Regular
                                  .copyWith(overflow: TextOverflow.ellipsis))
                        ],
                      ),
                      gapH8,
                      const Row(
                        children: [
                          gapW6,
                          Icon(EvaIcons.homeOutline),
                          gapW8,
                          Expanded(
                            child: Text(
                              "Số nhà 25, Ngõ 143, Đường Chiến Thắng, Xã Tân Triều, Huyện Thanh Trì, Hà Nội",
                              style: HAppStyle.paragraph2Regular,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH4,
                      const Text(
                        "Thứ 5, 25 - 1 - 2024",
                      )
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
                          Text(
                            'Tiền hàng (${orderController.isInCart.length} sản phẩm)',
                            style: HAppStyle.label2Bold,
                          ),
                          Text('${orderController.productMoney.value}.000₫'),
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
                            items: orderController.isInCart
                                .map((product) => product.imgPath)
                                .toList(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phí giao hàng',
                            style: HAppStyle.paragraph2Regular
                                .copyWith(color: HAppColor.hGreyColor),
                          ),
                          const Text('100.000₫'),
                        ],
                      ),
                      gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giảm giá phí giao hàng',
                              style: HAppStyle.paragraph2Regular
                                  .copyWith(color: HAppColor.hGreyColor)),
                          const Text('-50.000₫'),
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
                              '${orderController.productMoney.value + 50}.000₫',
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
            GestureDetector(
              onTap: () =>
                  Get.toNamed(HAppRoutes.voucher, preventDuplicates: false),
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
                        orderController.voucherAppliedTextAppear!.value
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  orderController.voucherAppliedText.value,
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
                Text.rich(
                  TextSpan(
                    text: "Tổng cộng:\n",
                    children: [
                      TextSpan(
                        text: orderController.productMoney.value != 0
                            ? "${orderController.productMoney.value + 50}.000₫"
                            : "0₫",
                        style: HAppStyle.heading4Style
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
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
