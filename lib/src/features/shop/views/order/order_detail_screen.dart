import 'package:another_stepper/another_stepper.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/delivery_person_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/review_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/live_tracking/live_tracking_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/review/write_review_screen.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({super.key});

  final orderController = OrderController.instance;
  final OrderModel order = Get.arguments['order'];
  final reviewController = Get.put(ReviewController());

  var difference = 0.obs;

  @override
  Widget build(BuildContext context) {
    final stepperData = orderController.listStepData(order);
    Future.delayed(Duration.zero).then((value) {
      difference.value = orderController.totalDifference(order);
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: HAppColor.hBackgroundColor,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Padding(
          padding: hAppDefaultPaddingL,
          child: Row(
            children: [
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
            ],
          ),
        ),
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: Padding(
        padding: hAppDefaultPaddingLR,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đơn hàng #${order.oderId.substring(0, 15)}...',
                style: HAppStyle.heading4Style,
              ),
              gapH12,
              EasyStepper(
                activeStep: order.activeStep,
                lineStyle: const LineStyle(
                  lineLength: 150,
                  lineSpace: 0,
                  lineType: LineType.normal,
                  defaultLineColor: HAppColor.hWhiteColor,
                  finishedLineColor: HAppColor.hBluePrimaryColor,
                  lineThickness: 1.5,
                ),
                activeStepTextColor: HAppColor.hDarkColor,
                finishedStepTextColor: HAppColor.hDarkColor,
                internalPadding: 0,
                showLoadingAnimation: false,
                stepRadius: 8,
                showStepBorder: false,
                steps: [
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: HAppColor.hWhiteColor,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: order.activeStep >= 0
                            ? HAppColor.hBluePrimaryColor
                            : HAppColor.hWhiteColor,
                      ),
                    ),
                    customTitle: Text(
                      HAppUtils.orderStatus(0),
                      textAlign: TextAlign.left,
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: HAppColor.hWhiteColor,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: order.activeStep >= 1
                            ? HAppColor.hBluePrimaryColor
                            : HAppColor.hWhiteColor,
                      ),
                    ),
                    customTitle: Text(
                      HAppUtils.orderStatus(1),
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                    topTitle: true,
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: HAppColor.hWhiteColor,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: order.activeStep >= 2
                            ? HAppColor.hBluePrimaryColor
                            : HAppColor.hWhiteColor,
                      ),
                    ),
                    customTitle: Text(
                      HAppUtils.orderStatus(2),
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: HAppColor.hWhiteColor,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: order.activeStep >= 3
                            ? HAppColor.hBluePrimaryColor
                            : HAppColor.hWhiteColor,
                      ),
                    ),
                    customTitle: Text(
                      HAppUtils.orderStatus(3),
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                    topTitle: true,
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: HAppColor.hWhiteColor,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: order.activeStep >= 4
                            ? HAppColor.hBluePrimaryColor
                            : HAppColor.hWhiteColor,
                      ),
                    ),
                    customTitle: Text(
                      HAppUtils.orderStatus(4),
                      textAlign: TextAlign.right,
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                  ),
                ],
              ),
              order.deliveryPerson != null
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          order.deliveryPerson!.image! != ''
                              ? ImageNetwork(
                                  image: order.deliveryPerson!.image!,
                                  height: 60,
                                  width: 60,
                                  borderRadius: BorderRadius.circular(100),
                                  onLoading: const CustomShimmerWidget.circular(
                                      width: 60, height: 60),
                                )
                              : Image.asset(
                                  'assets/logos/logo.png',
                                  height: 60,
                                  width: 60,
                                ),
                          gapW10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.deliveryPerson!.name!,
                                style: HAppStyle.heading5Style,
                              ),
                              gapH4,
                              Text(
                                order.deliveryPerson!.phoneNumber!,
                                style: HAppStyle.paragraph2Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600),
                              )
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  : Container(),
              AnotherStepper(
                barThickness: 0.5,
                stepperList: stepperData,
                activeIndex: order.storeOrders.lastIndexWhere(
                    (element) => element.isCheckFullProduct == 1),
                stepperDirection: Axis.vertical,
                iconWidth: 30,
                iconHeight: 30,
                verticalGap: 20,
              ),
              gapH12,
              ExpansionTile(
                childrenPadding: EdgeInsets.zero,
                initiallyExpanded: true,
                tilePadding: EdgeInsets.zero,
                shape: const Border(),
                title: Text('Số lượng (${order.orderProducts.length})'),
                children: [
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: order.orderProducts.length,
                      itemBuilder: (context, index) {
                        return PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text('Đánh giá'),
                              onTap: () async {
                                final productId =
                                    order.orderProducts[index].productId;
                                final orderId = order.oderId;
                                bool check = await reviewController
                                    .checkUserReviewProductInOrder(
                                        productId, orderId);
                                if (!check &&
                                    order.orderStatus == 'Hoàn thành') {
                                  showModalBottomSheet(
                                      context: Get.overlayContext!,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          HAppColor.hBackgroundColor,
                                      isDismissible: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enableDrag: false,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              top: hAppDefaultPadding,
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: WriteReviewWidget(
                                            productId: productId,
                                            orderId: orderId,
                                          ),
                                        );
                                      });
                                } else {
                                  HAppUtils.showSnackBarWarning(
                                      "Không thể đánh giá",
                                      'Có vẻ bạn đã đánh giá rồi hoặc chưa hoàn tất đặt hàng sản phẩm này nên không thể đánh giá');
                                }
                              },
                            ),
                            PopupMenuItem(
                              child: const Text('Xem sản phẩm'),
                              onTap: () async {
                                final productId =
                                    order.orderProducts[index].productId;
                                final product = await ProductRepository.instance
                                    .getProductInformation(productId);
                                final store = await StoreRepository.instance
                                    .getStoreInformation(
                                        order.orderProducts[index].storeId);
                                Get.toNamed(
                                  HAppRoutes.productDetail,
                                  arguments: {
                                    'product': product,
                                    'store': store,
                                  },
                                  preventDuplicates: false,
                                );
                              },
                            )
                          ],
                          child: ProductItemHorizalOrderWidget(
                              model: order.orderProducts[index]),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          gapH6),
                ],
              ),
              gapH12,
              SectionLiveTracking(
                  title: 'Thời gian đặt hàng',
                  subtitle:
                      DateFormat('EEEE, d-M-y', 'vi').format(order.orderDate!)),
              gapH12,
              SectionLiveTracking(
                  title: 'Phương thức thanh toán',
                  subtitle:
                      HAppUtils.getTitlePaymentMethod(order.paymentMethod)),
              gapH12,
              SectionLiveTracking(
                  title: 'Tiền hàng',
                  subtitle: HAppUtils.vietNamCurrencyFormatting(
                      order.orderProducts.fold(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              element.price! * element.quantity))),
              gapH12,
              order.discount != 0
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: SectionLiveTracking(
                          title: 'Áp dụng khuyến mãi',
                          subtitle:
                              '-${HAppUtils.vietNamCurrencyFormatting(order.discount)}'),
                    )
                  : Container(),
              SectionLiveTracking(
                  title: 'Phí giao hàng',
                  subtitle:
                      HAppUtils.vietNamCurrencyFormatting(order.deliveryCost)),
              gapH12,
              SectionLiveTracking(
                  title: 'Phí dịch vụ',
                  subtitle: HAppUtils.vietNamCurrencyFormatting(5000)),
              gapH12,
              SectionLiveTracking(
                  title: 'Tổng cộng',
                  subtitle: HAppUtils.vietNamCurrencyFormatting(order.price)),
              order.replacedProducts != null
                  ? Obx(() => Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: SectionLiveTracking(
                            title:
                                difference.value > 0 ? 'Trả thêm' : 'Hoàn lại',
                            subtitle: HAppUtils.vietNamCurrencyFormatting(
                                difference.value.abs())),
                      ))
                  : Container(),
              gapH24,
              Text.rich(
                TextSpan(
                    text: 'Trạng thái cuối cùng của đơn hàng: ',
                    style: HAppStyle.label3Bold,
                    children: [
                      TextSpan(
                          text: order.orderStatus,
                          style: HAppStyle.heading5Style.copyWith(
                              color: order.orderStatus == 'Hoàn thành'
                                  ? HAppColor.hBluePrimaryColor
                                  : order.orderStatus == 'Từ chối'
                                      ? HAppColor.hOrangeColor
                                      : HAppColor.hRedColor))
                    ]),
              ),
              gapH24,
            ],
          ),
        ),
      ),
    );
  }
}
