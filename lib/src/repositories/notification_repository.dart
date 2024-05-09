import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/notification_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<List<NotificationModel>> getAllNotification() async {
    try {
      print('vào get AAAAAAAAAAAAAAAAa');
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final notifications = await db
          .collection('Notifications')
          .doc(userId)
          .collection('UserNotification')
          .get();

      return notifications.docs
          .map((snapshot) => NotificationModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<NotificationModel>> getProductNotification() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final notifications = await db
          .collection('Notifications')
          .doc(userId)
          .collection('UserNotification')
          .where('Type', isEqualTo: 'product')
          .get();

      return notifications.docs
          .map((snapshot) => NotificationModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<NotificationModel>> getStoreNotification() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final notifications = await db
          .collection('Notifications')
          .doc(userId)
          .collection('UserNotification')
          .where('Type', isEqualTo: 'store')
          .get();

      return notifications.docs
          .map((snapshot) => NotificationModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<NotificationModel>> getOrderNotification() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final notifications = await db
          .collection('Notifications')
          .doc(userId)
          .collection('UserNotification')
          .where('Type', isEqualTo: 'order')
          .get();

      return notifications.docs
          .map((snapshot) => NotificationModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  // Future<void> updateNotification(NotificationModel notification) async {
  //   try {
  //     final userId = AuthenticationRepository.instance.authUser!.uid;
  //     await db
  //         .collection('Notifications')
  //         .doc(userId)
  //         .collection('UserNotification')
  //         .doc(notification.id)
  //         .update({'IsSeen': list});
  //   } catch (e) {
  //     throw 'Đã xảy ra sự cố. Không thể cập nhật được mã ưu đãi. Vui lòng thử lại sau.';
  //   }
  // }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await db
          .collection('Notifications')
          .doc(userId)
          .collection('UserNotification')
          .add(notification.toJson());
    } catch (e) {
      throw 'Đã xảy ra sự cố. Không thể cập nhật được mã ưu đãi. Vui lòng thử lại sau: ${e.toString()}';
    }
  }
}
