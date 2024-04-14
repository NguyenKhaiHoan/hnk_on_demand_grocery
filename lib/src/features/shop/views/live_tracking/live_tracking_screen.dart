import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/delivery_person_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/initialize_location_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/map_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_process_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/chat_order.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final deliveryPersonController = Get.put(DeliveryPersonController());
  final orderController = Get.put(OrderController());

  final stepperData = Get.arguments['stepperData'];
  OrderModel orderData = Get.arguments['order'];

  int length = 0;

  var difference = 0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      length = orderData.storeOrders.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  var isDelivery = false.obs;

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15)));
  }

  var activeStep = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child('Orders/${orderData.oderId}')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                    color: HAppColor.hBluePrimaryColor),
              ),
            );
          }

          if (snapshot.hasError) {
            Get.back();
            return const SizedBox();
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            Get.back();
            return const SizedBox();
          }

          OrderModel order = OrderModel.fromJson(
              jsonDecode(jsonEncode(snapshot.data!.snapshot.value)));

          Future.delayed(Duration.zero).then((value) {
            difference.value = orderController.totalDifference(order);
          });

          if (length != order.storeOrders.length) {
            length = order.storeOrders.length;
            if (length != 0) {
              int totalPrice = 0;
              for (var cartProduct in order.orderProducts) {
                totalPrice += cartProduct.price! * cartProduct.quantity;
              }
              order.price = totalPrice;
            } else {
              orderController.saveOrder(
                  order: order,
                  status: 'Từ chối',
                  activeStep: activeStep.value);
            }
          }

          if (order.orderStatus != null &&
              reverseOrderStatus(order.orderStatus!) != activeStep.value) {
            activeStep.value = reverseOrderStatus(order.orderStatus!);
          }
          if (order.deliveryPerson != null) {
            deliveryPersonController.deliveryPerson.value =
                order.deliveryPerson!;
            print(order.deliveryPerson!.toString());
            FirebaseDatabase.instance
                .ref()
                .child('DeliveryPersons/${order.deliveryPerson!.id}')
                .onValue
                .listen((event) {
              if (event.snapshot.exists) {
                DeliveryProcessModel deliveryProcess =
                    DeliveryProcessModel.fromJson(
                        jsonDecode(jsonEncode(event.snapshot.value)));
                print(deliveryProcess.toString());
                print("${deliveryProcess.l[0]}, ${deliveryProcess.l[1]}");
                moveToPosition(
                    LatLng(deliveryProcess.l[0], deliveryProcess.l[1]));
              }
            });
          }

          return Stack(
            children: [
              SizedBox(
                height: HAppSize.deviceHeight * 0.5,
                width: HAppSize.deviceWidth,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            AddressController
                                .instance.selectedAddress.value.latitude,
                            AddressController
                                .instance.selectedAddress.value.longitude),
                        zoom: 14,
                      ),
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: (GoogleMapController controller) async {
                        if (!googleMapController.isCompleted) {
                          googleMapController.complete(controller);
                        }
                      },
                    ),
                    order.deliveryPerson != null
                        ? Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: deliveryMarker()))
                        : Container()
                  ],
                ),
              ),
              AppBar(
                titleSpacing: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: HAppColor.hTransparentColor,
                toolbarHeight: 80,
                title: Padding(
                  padding: hAppDefaultPaddingL,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          OrderController.instance.resetToggle.toString();
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
              ),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.5,
                  maxChildSize: 1.0 - (90 / HAppSize.deviceHeight),
                  builder: (context, scrollController) {
                    return Container(
                        decoration: const BoxDecoration(
                          color: HAppColor.hBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: hAppDefaultPaddingLR,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gapH24,
                                Text(
                                  'Đơn hàng #${order.oderId.substring(0, 15)}...',
                                  style: HAppStyle.heading4Style,
                                ),
                                gapH12,
                                Obx(
                                  () => EasyStepper(
                                    activeStep: activeStep.value,
                                    lineStyle: const LineStyle(
                                      lineLength: 150,
                                      lineSpace: 0,
                                      lineType: LineType.normal,
                                      defaultLineColor: HAppColor.hWhiteColor,
                                      finishedLineColor:
                                          HAppColor.hBluePrimaryColor,
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
                                          backgroundColor:
                                              HAppColor.hWhiteColor,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: activeStep >= 0
                                                ? HAppColor.hBluePrimaryColor
                                                : HAppColor.hWhiteColor,
                                          ),
                                        ),
                                        customTitle: Text(
                                          HAppUtils.orderStatus(0),
                                          textAlign: TextAlign.left,
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                      ),
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              HAppColor.hWhiteColor,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: activeStep >= 1
                                                ? HAppColor.hBluePrimaryColor
                                                : HAppColor.hWhiteColor,
                                          ),
                                        ),
                                        customTitle: Text(
                                          HAppUtils.orderStatus(1),
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                        topTitle: true,
                                      ),
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              HAppColor.hWhiteColor,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: activeStep >= 2
                                                ? HAppColor.hBluePrimaryColor
                                                : HAppColor.hWhiteColor,
                                          ),
                                        ),
                                        customTitle: Text(
                                          HAppUtils.orderStatus(2),
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                      ),
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              HAppColor.hWhiteColor,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: activeStep >= 3
                                                ? HAppColor.hBluePrimaryColor
                                                : HAppColor.hWhiteColor,
                                          ),
                                        ),
                                        customTitle: Text(
                                          HAppUtils.orderStatus(3),
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                        topTitle: true,
                                      ),
                                      EasyStep(
                                        customStep: CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              HAppColor.hWhiteColor,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: activeStep >= 4
                                                ? HAppColor.hBluePrimaryColor
                                                : HAppColor.hWhiteColor,
                                          ),
                                        ),
                                        customTitle: Text(
                                          HAppUtils.orderStatus(4),
                                          textAlign: TextAlign.right,
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                order.deliveryPerson != null
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            order.deliveryPerson!.image! != ''
                                                ? ImageNetwork(
                                                    image: order
                                                        .deliveryPerson!.image!,
                                                    height: 60,
                                                    width: 60,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    onLoading:
                                                        const CustomShimmerWidget
                                                            .circular(
                                                            width: 60,
                                                            height: 60),
                                                  )
                                                : Image.asset(
                                                    'assets/logos/logo.png',
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                            gapW10,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  order.deliveryPerson!.name!,
                                                  style:
                                                      HAppStyle.heading5Style,
                                                ),
                                                gapH4,
                                                Text(
                                                  order.deliveryPerson!
                                                      .phoneNumber!,
                                                  style: HAppStyle
                                                      .paragraph2Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600),
                                                )
                                              ],
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {},
                                              child: const Icon(
                                                EvaIcons.phoneOutline,
                                                size: 18,
                                              ),
                                            ),
                                            gapW10,
                                            GestureDetector(
                                              onTap: () => Get.to(
                                                  const ChatOrderRealtimeScreen(),
                                                  arguments: {
                                                    'orderId': order.oderId,
                                                    'anotherId':
                                                        order.orderUserId,
                                                    'otherId':
                                                        order.deliveryPerson!.id
                                                  }),
                                              child: const Icon(
                                                EvaIcons.messageSquareOutline,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                gapH12,
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              hAppDefaultPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(children: [
                                                Text(
                                                  'Hành động',
                                                  style: HAppStyle.heading4Style
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hDarkColor),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () => Get.back(),
                                                  child: const Icon(
                                                      EvaIcons.close),
                                                )
                                              ]),
                                              gapH6,
                                              Divider(
                                                color: HAppColor
                                                    .hGreyColorShade300,
                                              ),
                                              gapH12,
                                              for (int i = 0;
                                                  i < order.storeOrders.length;
                                                  i++)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  child: Row(children: [
                                                    Expanded(
                                                        child: Text(
                                                      '$i: ${order.storeOrders[i].name}',
                                                      style: HAppStyle
                                                          .heading5Style
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hDarkColor),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        EvaIcons.phoneOutline,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    gapW10,
                                                    GestureDetector(
                                                      onTap: () => Get.to(
                                                          const ChatOrderRealtimeScreen(),
                                                          arguments: {
                                                            'orderId':
                                                                order.oderId,
                                                            'anotherId': order
                                                                .orderUserId,
                                                            'otherId': order
                                                                .storeOrders[i]
                                                                .storeId
                                                          }),
                                                      child: const Icon(
                                                        EvaIcons
                                                            .messageSquareOutline,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: AnotherStepper(
                                    barThickness: 0.5,
                                    stepperList: stepperData,
                                    activeIndex: order.storeOrders
                                        .lastIndexWhere((element) =>
                                            element.isCheckFullProduct == 1),
                                    stepperDirection: Axis.vertical,
                                    iconWidth: 30,
                                    iconHeight: 30,
                                    verticalGap: 20,
                                  ),
                                ),
                                gapH6,
                                Text(
                                  'Nhấn vào các cửa hàng để thực hiện cách hành động: Gọi và Nhắn tin',
                                  style: HAppStyle.paragraph3Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                ),
                                gapH12,
                                ExpansionTile(
                                  childrenPadding: EdgeInsets.zero,
                                  initiallyExpanded: true,
                                  tilePadding: EdgeInsets.zero,
                                  shape: const Border(),
                                  title: Text(
                                      'Số lượng (${order.orderProducts.length})'),
                                  children: [
                                    ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: order.orderProducts.length,
                                        itemBuilder: (context, index) {
                                          return ProductItemHorizalOrderWidget(
                                              model:
                                                  order.orderProducts[index]);
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                gapH6),
                                  ],
                                ),
                                gapH12,
                                SectionLiveTracking(
                                    title: 'Thời gian đặt hàng',
                                    subtitle: DateFormat('EEEE, d-M-y', 'vi')
                                        .format(order.orderDate!)),
                                gapH12,
                                SectionLiveTracking(
                                    title: 'Phương thức thanh toán',
                                    subtitle: HAppUtils.getTitlePaymentMethod(
                                        order.paymentMethod)),
                                gapH12,
                                SectionLiveTracking(
                                    title: 'Tiền hàng',
                                    subtitle:
                                        HAppUtils.vietNamCurrencyFormatting(
                                            order.orderProducts.fold(
                                                0,
                                                (previousValue, element) =>
                                                    previousValue +
                                                    element.price! *
                                                        element.quantity))),
                                order.discount == 0
                                    ? gapH12
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: SectionLiveTracking(
                                            title: 'Áp dụng khuyến mãi',
                                            subtitle:
                                                '-${HAppUtils.vietNamCurrencyFormatting(order.discount)}'),
                                      ),
                                SectionLiveTracking(
                                    title: 'Phí giao hàng',
                                    subtitle:
                                        HAppUtils.vietNamCurrencyFormatting(
                                            order.deliveryCost)),
                                gapH12,
                                SectionLiveTracking(
                                    title: 'Phí dịch vụ',
                                    subtitle:
                                        HAppUtils.vietNamCurrencyFormatting(
                                            5000)),
                                gapH12,
                                SectionLiveTracking(
                                    title: 'Tổng cộng',
                                    subtitle:
                                        HAppUtils.vietNamCurrencyFormatting(
                                            order.price)),
                                order.replacedProducts != null
                                    ? Obx(() => Container(
                                          margin:
                                              const EdgeInsets.only(top: 12),
                                          child: SectionLiveTracking(
                                              title: difference.value > 0
                                                  ? 'Trả thêm'
                                                  : 'Hoàn lại',
                                              subtitle: HAppUtils
                                                  .vietNamCurrencyFormatting(
                                                      difference.value.abs())),
                                        ))
                                    : Container(),
                                if (order.orderStatus != null &&
                                    order.orderStatus! ==
                                        HAppUtils.orderStatus(4))
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      gapH24,
                                      const Text(
                                        'Đơn hàng đã được giao tới nơi',
                                        style: HAppStyle.heading4Style,
                                      ),
                                      gapH8,
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Nhấn "Đã nhận" để hoàn tất đơn hàng',
                                              style: HAppStyle.paragraph2Regular
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hGreyColorShade600),
                                            ),
                                            gapW6,
                                            GestureDetector(
                                              onTap: () => showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            content: const Text(
                                                                'Người giao hàng đã giao đơn hàng tới địa chỉ của bạn thành công, hãy nhấn "Đã nhận" để hoàn tất, còn nếu bạn chưa nhận được hàng, hãy nhấn ngay "Chưa nhận" để thông báo cho chúng tôi, chúng tôi sẽ xử lý cho bạn'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Get.back(),
                                                                child: Text(
                                                                  'Đã biết',
                                                                  style: HAppStyle
                                                                      .label4Bold
                                                                      .copyWith(
                                                                          color:
                                                                              HAppColor.hBluePrimaryColor),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                              child: const Icon(
                                                EvaIcons.infoOutline,
                                                size: 15,
                                                color:
                                                    HAppColor.hBluePrimaryColor,
                                              ),
                                            )
                                          ]),
                                      gapH12,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                    maximumSize: Size(
                                                        HAppSize.deviceWidth *
                                                            0.5,
                                                        50),
                                                    foregroundColor:
                                                        HAppColor.hRedColor,
                                                    side: const BorderSide(
                                                        color: HAppColor
                                                            .hRedColor)),
                                                child: Text(
                                                  "Chưa nhận",
                                                  style: HAppStyle.label2Bold
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hRedColor),
                                                )),
                                          ),
                                          gapW10,
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                orderController.saveOrder(
                                                    order: order,
                                                    status: 'Hoàn thành',
                                                    activeStep:
                                                        activeStep.value);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                maximumSize: Size(
                                                    HAppSize.deviceWidth * 0.5,
                                                    50),
                                                backgroundColor:
                                                    HAppColor.hBluePrimaryColor,
                                              ),
                                              child: Text(
                                                "Đã nhận",
                                                style: HAppStyle.label2Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hWhiteColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                if (order.orderStatus == null ||
                                    order.orderStatus ==
                                        HAppUtils.orderStatus(0) ||
                                    order.orderStatus ==
                                        HAppUtils.orderStatus(1))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          orderController.saveOrder(
                                              order: order,
                                              status: 'Hủy',
                                              activeStep: activeStep.value);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          minimumSize:
                                              Size(HAppSize.deviceWidth, 50),
                                          side: const BorderSide(
                                              color: HAppColor.hRedColor),
                                        ),
                                        child: Text(
                                          "Hủy đơn hàng",
                                          style: HAppStyle.label2Bold.copyWith(
                                              color: HAppColor.hRedColor),
                                        )),
                                  ),
                                gapH24,
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Widget deliveryMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: HAppColor.hWhiteColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(
          child: deliveryPersonController.deliveryPerson.value.image == '' ||
                  DeliveryPersonController
                          .instance.deliveryPerson.value.image ==
                      null
              ? Image.asset('assets/logos/logo.png')
              : ImageNetwork(
                  image: DeliveryPersonController
                      .instance.deliveryPerson.value.image!,
                  height: 40,
                  width: 40,
                  onLoading:
                      const CustomShimmerWidget.circular(width: 40, height: 40),
                )),
    );
  }

  final Completer<GoogleMapController> googleMapController = Completer();
  final initializeLocationController = Get.put(InitializeLocationController());

  int reverseOrderStatus(String statusText) {
    switch (statusText) {
      case 'Đơn đặt hàng thành công':
        return 0;
      case 'Cửa hàng xác nhận':
        return 1;
      case 'Người giao hàng xác nhận':
        return 2;
      case 'Người giao hàng đã lấy hàng':
        return 3;
      case 'Đơn giao tới nơi':
        return 4;
      default:
        return -1;
    }
  }
}

class SectionLiveTracking extends StatelessWidget {
  const SectionLiveTracking(
      {super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: HAppStyle.paragraph2Bold
                .copyWith(color: HAppColor.hGreyColorShade600),
          ),
        ),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              subtitle,
              style: HAppStyle.paragraph2Regular,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}
