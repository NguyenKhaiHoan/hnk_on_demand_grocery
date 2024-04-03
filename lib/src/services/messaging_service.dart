import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_keys.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/delivery_person_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
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

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');
    await userRepository.updateSingleField({'CloudMessagingToken': fcmToken});

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          if (notificationData['deliveryPerson'] == null) {
            log('Null không có gì');
          }

          DeliveryPersonModel deliveryPersonData = DeliveryPersonModel.fromJson(
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
                                  onLoading: const CustomShimmerWidget.circular(
                                      width: 60, height: 60),
                                ),
                          gapW10,
                          Text.rich(TextSpan(
                              text: deliveryPersonData.name,
                              style: HAppStyle.heading5Style,
                              children: [
                                TextSpan(
                                    text: '\n${deliveryPersonData.phoneNumber}',
                                    style: HAppStyle.paragraph2Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600))
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

  static sendNotificationToStore(List<ProductInCartModel> products,
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
        final data = {
          "to": storeData.cloudMessagingToken,
          "notification": {
            "title": 'Có đơn mới',
            "body":
                'Có đơn mới được đặt với $numberOfCart sản phẩm từ người dùng: ${userAddress.name}',
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
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.notification!.title}');
}
