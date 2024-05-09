import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/oder_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<List<OrderModel>> getAllUserOrder() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw 'Không có thông tin người dùng';
      }
      final orders = await db
          .collection('Orders')
          .where('OrderUserId', isEqualTo: userId)
          .limit(10)
          .get();
      return orders.docs
          .map((snapshot) => OrderModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      print(e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<String> addAndFindIdNewOrder(OrderModel order) async {
    try {
      final currentOrder = await db.collection('Orders').add(order.toJson());
      return currentOrder.id;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> updateOrderField(
      String orderId, Map<String, dynamic> json) async {
    try {
      await db.collection('Orders').doc(orderId).update(json);
    } catch (e) {
      throw 'Đã xảy ra sự cố. Không thể cập nhật lựa chọn địa chỉ của bạn. Vui lòng thử lại sau.';
    }
  }
}
