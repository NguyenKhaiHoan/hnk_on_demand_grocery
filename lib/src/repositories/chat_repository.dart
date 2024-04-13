import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/banner_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_model.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ChatModel>> getAllChats(String userId) async {
    try {
      final snapshot = await _db
          .collection('Chats')
          .where('UserId', isEqualTo: userId)
          .get();
      final list = snapshot.docs
          .map((document) => ChatModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
