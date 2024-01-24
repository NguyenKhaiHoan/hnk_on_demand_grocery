import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/cart/views/product_cart.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final listStore1 = bigcstore.take(2).toList();
  final listStore2 = bigcstore.take(1).toList();

  String _selected = 'Tiền mặt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thanh toán"),
        centerTitle: true,
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
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
                    Text(
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
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nguyễn Khải Hoàn",
                        style: HAppStyle.label2Bold,
                      ),
                      gapH8,
                      Row(
                        children: [
                          gapW8,
                          Icon(
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
                      Row(
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
                      Text(
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
                Text(
                  "Phương thức thanh toán",
                  style: HAppStyle.heading4Style,
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Cash',
                        groupValue: _selected,
                        activeColor: HAppColor.hBluePrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            _selected = value!;
                          });
                        },
                        title: Text("Trả tiền khi nhận hàng"),
                      ),
                      RadioListTile<String>(
                        activeColor: HAppColor.hBluePrimaryColor,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Momo',
                        groupValue: _selected,
                        onChanged: (value) {
                          setState(() {
                            _selected = value!;
                          });
                        },
                        title: Text("Ví điện tử Momo"),
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
                Row(
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
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tiền hàng (3 sản phẩm)'),
                          Text('1.500.000₫'),
                        ],
                      ),
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH6,
                      Row(children: [
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 70.0,
                                  width: 70.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://th.bing.com/th/id/OIP.A1JjNu8jIRxaTJHbD_EtFwHaIJ?rs=1&pid=ImgDetMain'),
                                          fit: BoxFit.cover)),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => gapW10,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        )
                      ]),
                      gapH16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phí giao hàng'),
                          Text('100.000₫'),
                        ],
                      ),
                      gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giảm giá phí giao hàng'),
                          Text('-50.000₫'),
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
                          Text('Tổng cộng', style: HAppStyle.label2Bold),
                          Text('1.550.000₫',
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
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.discount_outlined,
                  color: HAppColor.hBluePrimaryColor,
                ),
                gapW12,
                Text(
                  "Áp dụng mã giảm giá",
                  style: HAppStyle.label2Bold,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                )
              ],
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
                        text: "1.550.000₫",
                        style: HAppStyle.heading4Style
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Đặt hàng",
                    style: HAppStyle.label2Bold
                        .copyWith(color: HAppColor.hWhiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(HAppSize.deviceWidth * 0.45, 40),
                    backgroundColor: HAppColor.hBluePrimaryColor,
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
