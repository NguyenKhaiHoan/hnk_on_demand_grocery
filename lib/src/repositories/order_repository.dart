// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
// import 'package:on_demand_grocery/src/features/shop/models/banner_model.dart';
// import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';

// class OrderRepository extends GetxController {
//   static OrderRepository get instance => Get.find();

//   final _db = FirebaseFirestore.instance;

//   Future<List<OrderModel>> getAllUserOrder() async {
//     try {
//       final userId = AuthenticationRepository.instance.authUser!.uid;
//       if (userId.isEmpty) throw 'Không có thông tin người dùng';

//       final orders =
//           await _db.collection('Users').doc(userId).collection('Orders').get();
//       return orders.docs
//           .map((snapshot) => OrderModel.fromDocumentSnapshot(snapshot))
//           .toList();
//     } catch (e) {
//       throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
//     }
//   }

//   Future<void> addOrder(OrderModel order) async {
//     try {
//       final userId = AuthenticationRepository.instance.authUser?.uid;
//       await _db
//           .collection('Users')
//           .doc(userId)
//           .collection('Orders')
//           .add(order.toJon());
//     } catch (e) {
//       throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
//     }
//   }
// }
