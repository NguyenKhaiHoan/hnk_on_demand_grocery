// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:on_demand_grocery/src/constants/app_keys.dart';
// import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
// import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
// import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
// import 'package:on_demand_grocery/src/repositories/store_repository.dart';
// import 'package:on_demand_grocery/src/repositories/user_repository.dart';
// import 'package:http/http.dart' as http;
// import 'package:on_demand_grocery/src/utils/utils.dart';

// class HNotificationService {
//   static final FirebaseMessaging _fbMessaging = FirebaseMessaging.instance;

//   static Future initializeFirebaseCloudMessaging() async {
//     await _fbMessaging.requestPermission();

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

//     getToken();
//     _fbMessaging.subscribeToTopic('USER');
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {}
//   static Future<void> _firebaseMessagingForegroundHandler(
//       RemoteMessage message) async {}

//   static Future getToken() async {
//     String? token = await _fbMessaging.getToken();
//     await UserRepository.instance
//         .updateSingleField({'CloudMessagingToken': token});
//   }

//   static sendNotificationToStore(
//       List<ProductInCartModel> products, List<StoreOrderModel> stores) async {
//     for (var store in stores) {
//       try {
//         final storeData =
//             await StoreRepository.instance.getStoreInformation(store.storeId);
//         final productOrderInStore =
//             products.where((element) => element.storeId == store.storeId);
//         int numberOfCart = 0;
//         for (var product in productOrderInStore) {
//           numberOfCart += product.quantity;
//         }
//         const postUrl = 'https://fcm.googleapis.com/fcm/send';
//         final data = {
//           "to": storeData.cloudMessagingToken,
//           "notification": {
//             "title": 'Có đơn mới',
//             "body": '$numberOfCart Sản phẩm',
//           },
//         };

//         final headers = {
//           'content-type': 'application/json',
//           'Authorization': 'key=${HAppKey.fcmKeyServer}'
//         };

//         await http
//             .post(Uri.parse(postUrl),
//                 body: json.encode(data),
//                 encoding: Encoding.getByName('utf-8'),
//                 headers: headers)
//             .then((value) {
//           log('Đã gửi thông báo');
//         }).timeout(const Duration(seconds: 60), onTimeout: () {
//           log('Đã hết thời gian kết nối');
//           throw TimeoutException('Đã hết thời gian kết nối');
//         }).onError((error, stackTrace) {
//           HAppUtils.showSnackBarError('Lỗi', error.toString());
//           throw Exception(error);
//         });
//       } catch (e) {
//         throw Exception(e);
//       }
//     }
//   }
// }
