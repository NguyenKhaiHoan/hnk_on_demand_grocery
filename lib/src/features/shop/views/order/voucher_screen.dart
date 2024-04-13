import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/voucher_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final cartController = Get.put(CartController());

  final voucherController = VoucherController.instance;

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
            Form(
                key: voucherController.checkVoucherFormKey,
                child: TextFormField(
                  controller: voucherController.checkVoucherController,
                  textAlignVertical: TextAlignVertical.center,
                  // validator: (value) => HAppUtils.validateEmptyField('Mã ưu đãi', value),
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
                      child: GestureDetector(
                          onTap: () {
                            voucherController.checkVoucher(
                                'Mã ưu đãi',
                                voucherController.checkVoucherController.text
                                    .trim(),
                                cartController.totalCartPrice.value,
                                cartController.cartProducts);
                          },
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: HAppColor.hBluePrimaryColor,
                            ),
                            child: Center(
                                child: Text(
                              "Áp dụng",
                              style: HAppStyle.label3Bold
                                  .copyWith(color: HAppColor.hWhiteColor),
                            )),
                          )),
                    ),
                  ),
                )),
            Obx(() => voucherController.checkVoucherText.value != ''
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      voucherController.checkVoucherText.value,
                      style: HAppStyle.paragraph2Regular
                          .copyWith(color: HAppColor.hRedColor),
                    ),
                  )
                : Container()),
            gapH24,
            const Text("Hoặc chọn các ưu đãi dưới đây"),
            gapH10,
            FutureBuilder(
                future: voucherController.fetchAllGroFastVouchers(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerVoucherCardWidget();
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
                    final vouchers = snapshot.data!;

                    return ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      shape: const Border(),
                      title: const Text(
                        "Từ GroFast",
                        style: HAppStyle.heading4Style,
                      ),
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var voucher = vouchers[index];
                              return Row(
                                children: [
                                  Obx(() => Radio(
                                        activeColor: HAppColor.hOrangeColor,
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
                                        value: voucher.name,
                                        groupValue: voucherController
                                            .selectedVoucher.value,
                                        onChanged: (value) {
                                          voucherController.checkVoucherButton(
                                              voucher,
                                              value as String,
                                              cartController
                                                  .totalCartPrice.value,
                                              cartController.cartProducts);
                                        },
                                      )),
                                  Expanded(
                                      child:
                                          VoucherCardWidget(voucher: voucher))
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => gapH12,
                            itemCount: vouchers.length),
                      ],
                    );
                  }
                })),
            gapH10,
            FutureBuilder(
                future: voucherController.fetchAllStoreVouchers(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerVoucherCardWidget();
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
                    final vouchers = snapshot.data!;
                    return ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      shape: const Border(),
                      title: const Text(
                        "Khác",
                        style: HAppStyle.heading4Style,
                      ),
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var voucher = vouchers[index];
                              return Row(
                                children: [
                                  Obx(() => Radio(
                                        activeColor: HAppColor.hOrangeColor,
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
                                        value: voucher.name,
                                        groupValue: voucherController
                                            .selectedVoucher.value,
                                        onChanged: (value) {
                                          voucherController.checkVoucherButton(
                                              voucher,
                                              value as String,
                                              cartController
                                                  .totalCartPrice.value,
                                              cartController.cartProducts);
                                        },
                                      )),
                                  Expanded(
                                      child:
                                          VoucherCardWidget(voucher: voucher))
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => gapH12,
                            itemCount: vouchers.length),
                      ],
                    );
                  }
                })),
            gapH12,
            Obx(() => voucherController.checkDataVoucher.value
                ? Row(
                    children: [
                      Radio(
                        activeColor: HAppColor.hOrangeColor,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        value: '',
                        groupValue: voucherController.selectedVoucher.value,
                        onChanged: (value) {
                          voucherController
                              .assignValueToUseVoucher(VoucherModel.empty());
                        },
                      ),
                      const Text('Không chọn mã ưu đãi')
                    ],
                  )
                : Container()),
            gapH24,
          ]),
        ),
      ),
    );
  }
}

class VoucherCardWidget extends StatefulWidget {
  const VoucherCardWidget({
    super.key,
    required this.voucher,
  });

  final VoucherModel voucher;

  @override
  State<VoucherCardWidget> createState() => _VoucherCardWidgetState();
}

class _VoucherCardWidgetState extends State<VoucherCardWidget> {
  var store = StoreModel.empty().obs;
  final storeRepository = Get.put(StoreRepository());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.voucher.storeId != null && widget.voucher.storeId != '') {
        store.value =
            await storeRepository.getStoreInformation(widget.voucher.storeId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CouponCard(
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
                widget.voucher.type == 'Flat'
                    ? NumberFormat.compact(locale: 'vi')
                        .format(widget.voucher.discountValue)
                    : '${widget.voucher.discountValue} %',
                textAlign: TextAlign.center,
                style: HAppStyle.heading3Style
                    .copyWith(color: HAppColor.hWhiteColor),
              ),
              Text(
                "Tất cả",
                style: HAppStyle.paragraph2Regular
                    .copyWith(color: HAppColor.hWhiteColor),
              ),
            ],
          ),
        ),
        secondChild: Container(
          padding: const EdgeInsets.all(10),
          color: HAppColor.hWhiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.voucher.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: HAppStyle.label2Bold,
              ),
              Row(
                children: [
                  widget.voucher.storeId != ''
                      ? Obx(() => store.value.storeImage == ''
                          ? const CustomShimmerWidget.circular(
                              width: 30, height: 30)
                          : ImageNetwork(
                              image: store.value.storeImage,
                              height: 30,
                              width: 30,
                              onLoading: const CustomShimmerWidget.circular(
                                  width: 30, height: 30),
                              borderRadius: BorderRadius.circular(100),
                            ))
                      : Container(),
                  widget.voucher.storeId != ''
                      ? Obx(() => Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              "Từ ${store.value.name}",
                              style: HAppStyle.paragraph3Regular,
                            ),
                          ))
                      : const Text(
                          "Từ GroFast",
                          style: HAppStyle.paragraph3Regular,
                        ),
                ],
              ),
              gapH4,
              widget.voucher.minAmount != null || widget.voucher.minAmount! > 0
                  ? Text(
                      "Điều kiện: Đơn hàng phải có giá trị trên ${HAppUtils.vietNamCurrencyFormatting(widget.voucher.minAmount!)}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hBluePrimaryColor),
                    )
                  : Container(),
              const Spacer(),
              Text(
                "HSD: ${DateFormat('dd/MM/yyyy').format(widget.voucher.endDate)}",
                style: HAppStyle.paragraph3Regular,
              ),
            ],
          ),
        ));
  }
}

class ShimmerVoucherCardWidget extends StatelessWidget {
  const ShimmerVoucherCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: CouponCard(
          height: 170,
          curveAxis: Axis.vertical,
          borderRadius: 10,
          firstChild: Container(
            padding: const EdgeInsets.all(10),
          ),
          secondChild: Container(
            padding: const EdgeInsets.all(10),
          )),
    );
  }
}
