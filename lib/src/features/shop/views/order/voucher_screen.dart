import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:toastification/toastification.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Áp dụng mã ưu đãi"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Padding(
          padding: hAppDefaultPaddingL,
          child: Row(children: [
            GestureDetector(
              onTap: () {
                Get.back();
                productController.bigCValue!.value = false;
                productController.groFastvalue!.value = false;
                productController.voucherAppliedSubText.clear();
                productController.voucherAppliedTextAppear!.value = false;
              },
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: hAppDefaultPaddingLR,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
                "Hãy nhập mã ưu đãi vào ô dưới đây để nhận được nhiều giảm giá hấp dẫn"),
            gapH24,
            const Text(
              "Nhập mã ưu đãi",
              style: HAppStyle.heading4Style,
            ),
            gapH16,
            TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintStyle: HAppStyle.paragraph2Bold
                    .copyWith(color: HAppColor.hGreyColor),
                isCollapsed: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        width: 2, color: HAppColor.hBluePrimaryColor)),
                contentPadding: const EdgeInsets.all(9),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        width: 0.8, color: HAppColor.hGreyColor)),
                hintText: "Nhập mã ưu đãi. Ví dụ: FREE, ...",
                prefixIcon: const Icon(
                  Icons.discount_outlined,
                  size: 25,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: HAppColor.hBluePrimaryColor,
                    ),
                    child: Center(
                        child: Text(
                      "Áp dụng",
                      style: HAppStyle.label3Bold
                          .copyWith(color: HAppColor.hWhiteColor),
                    )),
                  ),
                ),
              ),
            ),
            gapH24,
            const Text("Hoặc chọn các ưu đãi dưới đây"),
            gapH10,
            ExpansionTile(
              initiallyExpanded: true,
              tilePadding: EdgeInsets.zero,
              shape: const Border(),
              title: const Text(
                "Từ GroFast",
                style: HAppStyle.heading4Style,
              ),
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index2) {
                    return Row(
                      children: [
                        Checkbox(
                            activeColor: HAppColor.hOrangeColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: productController.groFastvalue!.value,
                            onChanged: (bool? value) {
                              if (productController.productMoney.value >=
                                  200000) {
                                productController.groFastvalue!.value = value!;
                                productController.groFastvalue!.value == true
                                    ? productController.voucherAppliedSubText
                                        .add("Giảm 100k cho khách hàng mới")
                                    : productController.voucherAppliedSubText
                                        .remove("Giảm 100k cho khách hàng mới");
                                productController
                                    .voucherAppliedTextAppear!.value = value;
                                productController.displayVoucherAppliedText();
                              } else {
                                HAppUtils.showToastError(
                                    Text(
                                      'Áp dụng mã ưu đãi không thành công!',
                                      style: HAppStyle.label2Bold
                                          .copyWith(color: HAppColor.hRedColor),
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            style: HAppStyle.paragraph2Regular
                                                .copyWith(
                                                    color: HAppColor
                                                        .hGreyColorShade600),
                                            text:
                                                'Đơn hàng của bạn có giá trị tiền hàng nhỏ hơn ',
                                            children: [
                                          TextSpan(
                                              text: '200.000₫.',
                                              style: HAppStyle.paragraph2Regular
                                                  .copyWith(
                                                      color:
                                                          HAppColor.hRedColor)),
                                          const TextSpan(
                                              text:
                                                  ' Hãy tiếp tục mua sắm để có thể nhận ưu đãi nhé.')
                                        ])),
                                    3,
                                    context,
                                    const ToastificationCallbacks());
                              }
                              setState(() {});
                            }),
                        Expanded(
                            child: CouponCard(
                                height: 170,
                                curveAxis: Axis.vertical,
                                borderRadius: 10,
                                firstChild: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: HAppColor.hOrangeColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "100k",
                                        textAlign: TextAlign.center,
                                        style: HAppStyle.heading2Style.copyWith(
                                            color: HAppColor.hWhiteColor),
                                      ),
                                      Text(
                                        "Tất cả",
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor.hWhiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                                secondChild: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: HAppColor.hWhiteColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Giảm 100k cho khách hàng mới",
                                        style: HAppStyle.label2Bold,
                                      ),
                                      const Text(
                                        "Từ GroFast",
                                        style: HAppStyle.paragraph3Regular,
                                      ),
                                      gapH4,
                                      Text(
                                        "Điều kiện: Đơn hàng phải có giá trị trên 200.000₫",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor),
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "HSD: 12.12.2024",
                                        style: HAppStyle.paragraph3Regular,
                                      ),
                                    ],
                                  ),
                                )))
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => gapH12,
                ),
              ],
            ),
            gapH6,
            ExpansionTile(
              initiallyExpanded: true,
              tilePadding: EdgeInsets.zero,
              shape: const Border(),
              title: const Text(
                "Khác",
                style: HAppStyle.heading4Style,
              ),
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index2) {
                    return Row(
                      children: [
                        Checkbox(
                            activeColor: HAppColor.hOrangeColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: productController.bigCValue!.value,
                            onChanged: (bool? value) {
                              if (productController.checkBigCVoucher()) {
                                productController.bigCValue!.value = value!;
                                productController.bigCValue!.value == true
                                    ? productController.voucherAppliedSubText
                                        .add("Giảm 10% cho mặt hàng Trái cây")
                                    : productController.voucherAppliedSubText
                                        .remove(
                                            "Giảm 10% cho mặt hàng Trái cây");
                                productController
                                    .voucherAppliedTextAppear!.value = value;
                                productController.displayVoucherAppliedText();
                              } else {
                                HAppUtils.showToastError(
                                    Text(
                                      'Áp dụng mã ưu đãi không thành công!',
                                      style: HAppStyle.label2Bold
                                          .copyWith(color: HAppColor.hRedColor),
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            style: HAppStyle.paragraph2Regular
                                                .copyWith(
                                                    color: HAppColor
                                                        .hGreyColorShade600),
                                            text:
                                                'Đơn hàng của bạn không có sản phẩm thuộc danh mục ',
                                            children: [
                                          TextSpan(
                                              text: 'Trái cây',
                                              style: HAppStyle.paragraph2Regular
                                                  .copyWith(
                                                      color:
                                                          HAppColor.hRedColor)),
                                          const TextSpan(text: ' trong '),
                                          TextSpan(
                                              text: 'Big C',
                                              style: HAppStyle.paragraph2Regular
                                                  .copyWith(
                                                      color:
                                                          HAppColor.hRedColor)),
                                          const TextSpan(text: '.'),
                                        ])),
                                    3,
                                    context,
                                    const ToastificationCallbacks());
                              }
                              setState(() {});
                            }),
                        Expanded(
                            child: CouponCard(
                                height: 170,
                                curveAxis: Axis.vertical,
                                borderRadius: 10,
                                firstChild: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: HAppColor.hOrangeColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "10%",
                                        textAlign: TextAlign.center,
                                        style: HAppStyle.heading2Style.copyWith(
                                            color: HAppColor.hWhiteColor),
                                      ),
                                      Text(
                                        "Trái cây",
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor.hWhiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                                secondChild: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: HAppColor.hWhiteColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Giảm 10% cho mặt hàng Trái cây",
                                        style: HAppStyle.label2Bold,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Từ ",
                                            style: HAppStyle.paragraph3Regular,
                                          ),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        listStore[0].imgStore),
                                                    fit: BoxFit.fill)),
                                          ),
                                          Text(
                                            " ${listStore[0].name}",
                                            style: HAppStyle.paragraph3Regular,
                                          ),
                                        ],
                                      ),
                                      gapH4,
                                      Text(
                                        "Điều kiện: Đơn hàng có các sản phẩm thuộc danh mục Trái cây trong Big C",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: HAppStyle.paragraph3Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor),
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "HSD: 12.12.2024",
                                        style: HAppStyle.paragraph3Regular,
                                      ),
                                    ],
                                  ),
                                )))
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => gapH12,
                ),
              ],
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
            productController.voucherAppliedTextAppear!.value
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
                : Container(),
            ElevatedButton(
              onPressed: () {
                if (productController.bigCValue!.value ||
                    productController.groFastvalue!.value) {
                  productController.applied.value = true;
                  productController.sumProductMoney();
                  Get.back();
                } else {
                  productController.bigCValue!.value = false;
                  productController.groFastvalue!.value = false;
                  productController.voucherAppliedSubText.clear();
                  productController.voucherAppliedTextAppear!.value = false;
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                backgroundColor: HAppColor.hBluePrimaryColor,
              ),
              child: Text(
                "Áp dụng",
                style:
                    HAppStyle.label2Bold.copyWith(color: HAppColor.hWhiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
