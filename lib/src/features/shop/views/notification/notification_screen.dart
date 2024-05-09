import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';

import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/notification_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/notification_model.dart';
import 'package:on_demand_grocery/src/repositories/notification_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              leadingWidth: 80,
              leading: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: hAppDefaultPadding),
                  child: GestureDetector(
                    child: const Icon(EvaIcons.arrowIosBackOutline),
                    onTap: () => Get.back(),
                  ),
                ),
              ),
              title: const Text("Thông báo"),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    final currentLocale = Get.locale;
                    print('Current locale: $currentLocale');
                  },
                  child: Text(
                    'Đã đọc',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hBluePrimaryColor),
                  ),
                ),
                gapW16
              ],
              bottom: const TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelStyle: HAppStyle.label3Bold,
                isScrollable: true,
                indicatorColor: HAppColor.hBluePrimaryColor,
                labelColor: HAppColor.hBluePrimaryColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Tất cả thông báo'),
                  Tab(text: 'Đơn hàng'),
                  Tab(text: 'Cửa hàng yêu thích'),
                  Tab(text: 'Chờ có hàng')
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: hAppDefaultPaddingLR,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH12,
                        Obx(
                          () => FutureBuilder(
                            key: Key(notificationController
                                .refreshDataAllNotification.value
                                .toString()),
                            future:
                                notificationController.fetchAllNotification(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: HAppColor.hBluePrimaryColor),
                                );
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
                                final list = snapshot.data!;

                                return ListView.separated(
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      NotificationWidget(
                                          notification: list[index]),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          gapH12,
                                );
                              }
                            },
                          ),
                        ),
                        gapH24,
                      ]),
                ),
                SingleChildScrollView(
                  padding: hAppDefaultPaddingLR,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH12,
                        Obx(
                          () => FutureBuilder(
                            key: Key(notificationController
                                .refreshDataOrder.value
                                .toString()),
                            future:
                                notificationController.fetchOrderNotification(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: HAppColor.hBluePrimaryColor),
                                );
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
                                final list = snapshot.data!;

                                return ListView.separated(
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      NotificationWidget(
                                          notification: list[index]),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          gapH12,
                                );
                              }
                            },
                          ),
                        ),
                        gapH24,
                      ]),
                ),
                SingleChildScrollView(
                  padding: hAppDefaultPaddingLR,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH12,
                        Obx(
                          () => FutureBuilder(
                            key: Key(notificationController
                                .refreshDataStore.value
                                .toString()),
                            future:
                                notificationController.fetchStoreNotification(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: HAppColor.hBluePrimaryColor),
                                );
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
                                final list = snapshot.data!;

                                return ListView.separated(
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      NotificationWidget(
                                          notification: list[index]),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          gapH12,
                                );
                              }
                            },
                          ),
                        ),
                        gapH24,
                      ]),
                ),
                SingleChildScrollView(
                  padding: hAppDefaultPaddingLR,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH12,
                        Obx(
                          () => FutureBuilder(
                            key: Key(notificationController
                                .refreshDataProduct.value
                                .toString()),
                            future: notificationController
                                .fetchProductNotification(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: HAppColor.hBluePrimaryColor),
                                );
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
                                final list = snapshot.data!;

                                return ListView.separated(
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      NotificationWidget(
                                          notification: list[index]),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          gapH12,
                                );
                              }
                            },
                          ),
                        ),
                        gapH24,
                      ]),
                ),
              ],
            )));
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: HAppSize.deviceWidth,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: HAppColor.hGreyColorShade300),
            child: Center(
                child: notification.type == 'product'
                    ? const Icon(Icons.production_quantity_limits_rounded)
                    : notification.type == 'order'
                        ? const Icon(EvaIcons.shoppingBagOutline)
                        : const Icon(Icons.storefront_outlined)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: HAppStyle.label2Bold),
                  Text(GetTimeAgo.parse(notification.time, locale: 'vi'),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600))
                ],
              ),
            ),
          ),
          const Icon(Icons.more_horiz)
        ],
      ),
    );
  }
}
