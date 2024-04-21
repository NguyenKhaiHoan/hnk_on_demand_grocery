import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/category_model.dart';

class CategoryRepositoryTest extends GetxController {
  static CategoryRepositoryTest get instance => Get.find();

  CategoryRepositoryTest({required this.db});

  FirebaseFirestore db;

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await db.collection('Categories').get();
      final list = snapshot.docs
          .map((document) => CategoryModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
