import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/notification_model.dart';
import 'package:on_demand_grocery/src/repositories/notification_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static NotificationController get instance => Get.find();

  final notificationRepository = Get.put(NotificationRepository());
  late TabController tabController;
  var refreshDataAllNotification = false.obs;
  var refreshDataProduct = false.obs;
  var refreshDataOrder = false.obs;
  var refreshDataStore = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 4);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<List<NotificationModel>> fetchAllNotification() async {
    try {
      print('vào đây AAAAAAAAAAAAAAAAAAAAAAA');
      final notifications = await notificationRepository.getAllNotification();
      if (notifications.isNotEmpty) {
        notifications.sort((NotificationModel a, NotificationModel b) =>
            (a.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch)
                .compareTo(b.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch));
      }
      return notifications;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future<List<NotificationModel>> fetchProductNotification() async {
    try {
      final notifications =
          await notificationRepository.getProductNotification();
      if (notifications.isNotEmpty) {
        notifications.sort((NotificationModel a, NotificationModel b) =>
            (a.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch)
                .compareTo(b.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch));
      }
      return notifications;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future<List<NotificationModel>> fetchOrderNotification() async {
    try {
      final notifications = await notificationRepository.getOrderNotification();
      if (notifications.isNotEmpty) {
        notifications.sort((NotificationModel a, NotificationModel b) =>
            (a.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch)
                .compareTo(b.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch));
      }
      return notifications;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future<List<NotificationModel>> fetchStoreNotification() async {
    try {
      final notifications = await notificationRepository.getStoreNotification();
      if (notifications.isNotEmpty) {
        notifications.sort((NotificationModel a, NotificationModel b) =>
            (a.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch)
                .compareTo(b.time.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch));
      }
      return notifications;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }
}
