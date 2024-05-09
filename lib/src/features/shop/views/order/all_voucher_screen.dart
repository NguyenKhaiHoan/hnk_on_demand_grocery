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

class AllVoucherScreen extends StatefulWidget {
  const AllVoucherScreen({super.key});

  @override
  State<AllVoucherScreen> createState() => _AllVoucherScreenState();
}

class _AllVoucherScreenState extends State<AllVoucherScreen> {
  final cartController = Get.put(CartController());

  final voucherController = VoucherController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tất cả ưu đãi"),
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
                              return VoucherCardWidget(voucher: voucher);
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
                              return VoucherCardWidget(voucher: voucher);
                            },
                            separatorBuilder: (context, index) => gapH12,
                            itemCount: vouchers.length),
                      ],
                    );
                  }
                })),
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
