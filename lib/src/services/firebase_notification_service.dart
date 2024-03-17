import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:on_demand_grocery/src/constants/app_keys.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:on_demand_grocery/src/utils/utils.dart';

class HNotificationService {
  static final FirebaseMessaging _fbMessaging = FirebaseMessaging.instance;

  static Future initializeFirebaseCloudMessaging() async {
    await _fbMessaging.requestPermission();
    getToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    _fbMessaging.subscribeToTopic('User');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}
  static Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {}

  static Future getToken() async {
    String? token = await _fbMessaging.getToken();
    await UserRepository.instance
        .updateSingleField({'CloudMessagingToken': token});
  }

  static sendNotificationToStore(List<ProductInCartModel> list) async {
    try {
      final store = await StoreRepository.instance
          .getStoreInformation(list.first.storeId);
      const postUrl = 'https://fcm.googleapis.com/fcm/send';
      final data = {
        "to": store.cloudMessagingToken,
        "notification": {
          "title": 'Có đơn mới',
          "body": '${list.length} Sản phẩm',
        },
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
          .timeout(const Duration(seconds: 60), onTimeout: () {
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

  static sendNotificationToNearbyDeliveryPersons(
      DeliveryPersonModel nearbyDeliveryPerson) async {
    try {
      const postUrl = 'https://fcm.googleapis.com/fcm/send';
      final data = {
        "to": nearbyDeliveryPerson.cloudMessagingToken,
        "notification": {
          "title": 'Có đơn mới',
          "body": 'Có đơn hàng mới được đặt ở gần đây',
        },
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
          .timeout(const Duration(seconds: 60), onTimeout: () {
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
