import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';

class StoreRepository extends GetxController {
  static StoreRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<StoreModel> getStoreInformation(String storeId) async {
    try {
      final documentSnapshot = await db.collection('Stores').doc(storeId).get();
      if (documentSnapshot.exists) {
        return StoreModel.fromDocumentSnapshot(documentSnapshot);
      } else {
        return StoreModel.empty();
      }
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      print(e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau. ${e.toString()}';
    }
  }

  Future<List<StoreModel>> getAllStores() async {
    try {
      final snapshot = await db.collection('Stores').get();
      final list = snapshot.docs
          .map((document) => StoreModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<StoreModel>> getFamousStore() async {
    try {
      final snapshot = await db
          .collection('Stores')
          .where('IsFamous', isEqualTo: true)
          .get();
      final list = snapshot.docs
          .map((document) => StoreModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
