import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_keys.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/delivery_person_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/notification_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:http/http.dart' as http;
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class HNotificationService {
  static String? fcmToken;

  static final HNotificationService _instance =
      HNotificationService._internal();

  factory HNotificationService() => _instance;

  HNotificationService._internal();

  final deliveryPersonController = Get.put(DeliveryPersonController());

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final userRepository = Get.put(UserRepository());
  final notificationController = Get.put(NotificationController());

  Future<void> init(BuildContext context) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await initLocalNotification();

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');
    await userRepository.updateSingleField({'CloudMessagingToken': fcmToken});

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          if (notificationData['deliveryPerson'] != null) {
            DeliveryPersonModel deliveryPersonData =
                DeliveryPersonModel.fromJson(
                    json.decode(notificationData['deliveryPerson']));

            HAppUtils.showSnackBarSuccess(
                message.notification!.title!, message.notification!.body!);
            showDialog(
              context: Get.overlayContext!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(message.notification!.title!),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.notification!.body!,
                          style: HAppStyle.paragraph2Regular
                              .copyWith(color: HAppColor.hGreyColorShade600),
                        ),
                        gapH10,
                        const Text(
                          'Thông tin người giao hàng:',
                          style: HAppStyle.paragraph1Bold,
                        ),
                        gapH8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            deliveryPersonData.image == '' ||
                                    deliveryPersonData.image == null
                                ? Image.asset(
                                    'assets/logos/logo.png',
                                    height: 60,
                                    width: 60,
                                  )
                                : ImageNetwork(
                                    image: deliveryPersonData.image!,
                                    height: 60,
                                    width: 60,
                                    borderRadius: BorderRadius.circular(100),
                                    onLoading:
                                        const CustomShimmerWidget.circular(
                                            width: 60, height: 60),
                                  ),
                            gapW10,
                            Text.rich(TextSpan(
                                text: deliveryPersonData.name,
                                style: HAppStyle.heading5Style,
                                children: [
                                  TextSpan(
                                      text:
                                          '\n${deliveryPersonData.phoneNumber}',
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hGreyColorShade600))
                                ])),
                          ],
                        )
                      ]),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Đã biết',
                        style: HAppStyle.label4Bold
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          if (notificationData['reject'] != null) {
            final orderController = OrderController.instance;
            String orderId = notificationData['order'];
            await FirebaseDatabase.instance
                .ref()
                .child('Orders/$orderId')
                .once()
                .then((value) {
              OrderModel orderData = OrderModel.fromJson(
                  jsonDecode(jsonEncode(value.snapshot.value)));

              if (notificationData['reject']
                  .toString()
                  .contains('Bị từ chối tất cả')) {
                showDialog(
                  context: Get.overlayContext!,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(message.notification!.title!),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.notification!.body!,
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600),
                            ),
                          ]),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await orderController.saveOrder(
                                order: orderData,
                                status: 'Hủy',
                                activeStep: orderData.activeStep);
                            await orderController.removeOrder(orderData.oderId);
                            Get.back();
                          },
                          child: Text(
                            'Hủy',
                            style: HAppStyle.label4Bold
                                .copyWith(color: HAppColor.hRedColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (notificationData['reject']
                  .toString()
                  .contains('Bị từ chối')) {
                showDialog(
                  context: Get.overlayContext!,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(message.notification!.title!),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.notification!.body!,
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600),
                            ),
                          ]),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Get.back();
                            await orderController.saveOrder(
                                order: orderData,
                                status: 'Hủy',
                                activeStep: orderData.activeStep);
                            await orderController.removeOrder(orderData.oderId);
                          },
                          child: Text(
                            'Hủy đơn hàng',
                            style: HAppStyle.label4Bold
                                .copyWith(color: HAppColor.hRedColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Tiếp tục đơn hàng',
                            style: HAppStyle.label4Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            });
          }
          if (notificationData['reject'] != null) {
            notificationController.refreshDataAllNotification.toggle();
            if (notificationData['type'] == 'product') {
              notificationController.refreshDataProduct.toggle();
            } else if (notificationData['type'] == 'order') {
              notificationController.refreshDataOrder.toggle();
            } else if (notificationData['type'] == 'store') {
              notificationController.refreshDataStore.toggle();
            }
          }
          showNotification(
              title: message.notification!.title!,
              body: message.notification!.body!,
              payload: '');
        }
        // HAppUtils.showSnackBarSuccess(
        //     message.notification!.title!, message.notification!.body!);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }

  static Future<void> sendNotificationToStore(List<ProductInCartModel> products,
      List<StoreOrderModel> stores, AddressModel userAddress) async {
    for (var store in stores) {
      try {
        final storeData =
            await StoreRepository.instance.getStoreInformation(store.storeId);
        final productOrderInStore =
            products.where((element) => element.storeId == store.storeId);
        int numberOfCart = 0;
        for (var product in productOrderInStore) {
          numberOfCart += product.quantity;
        }
        const postUrl = 'https://fcm.googleapis.com/fcm/send';

        String title = 'Có đơn mới';
        String body =
            'Có đơn mới được đặt với $numberOfCart sản phẩm từ người dùng: ${userAddress.name}';

        final data = {
          "to": storeData.cloudMessagingToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {'user': userAddress.toJson()}
        };

        final headers = {
          'content-type': 'application/json',
          'Authorization': 'key=${HAppKey.fcmKeyServer}'
        };

        await http
            .post(Uri.parse(postUrl),
                body: json.encode(data),
                encoding: Encoding.getByName('utf-8'),
                headers: headers)
            .then((value) {
          log('Đã gửi thông báo');
        }).timeout(const Duration(seconds: 60), onTimeout: () {
          log('Đã hết thời gian kết nối');
          throw TimeoutException('Đã hết thời gian kết nối');
        }).onError((error, stackTrace) {
          HAppUtils.showSnackBarError('Lỗi', error.toString());
          throw Exception(error);
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Mở thông báo');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  static Future showNotification(
      {required String title,
      required String body,
      required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.notification!.title}');
}
