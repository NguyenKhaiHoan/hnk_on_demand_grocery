import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/services/firebase_storage_service.dart';

class ProductRepositoryTest extends GetxController {
  static ProductRepositoryTest get instance => Get.find();

  ProductRepositoryTest({required this.db});

  FirebaseFirestore db;

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await db
          .collection('Products')
          .orderBy('UploadTime', descending: true)
          .limit(30)
          .get();
      final list = snapshot.docs
          .map((document) => ProductModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<ProductModel>> getTopSellingProducts() async {
    try {
      final snapshot = await db
          .collection('Products')
          .where('CountBuyed', isGreaterThanOrEqualTo: 100)
          .orderBy('CountBuyed', descending: true)
          .orderBy('UploadTime', descending: true)
          .limit(10)
          .get();
      final list = snapshot.docs
          .map((document) => ProductModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<ProductModel>> getSearchProducts(
      String text, String storeId) async {
    try {
      final snapshot = await db
          .collection("Products")
          .where(
            'StoreId',
            isEqualTo: storeId,
          )
          .where("Name", isGreaterThanOrEqualTo: text)
          .where("Name", isLessThanOrEqualTo: "$text\uf7ff")
          .orderBy('Name')
          .orderBy("UploadTime", descending: true)
          .limit(10)
          .get();
      final list = snapshot.docs
          .map((document) => ProductModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<ProductModel>> getTopSaleProducts() async {
    try {
      final snapshot = await db
          .collection('Products')
          .where('SalePersent', isGreaterThan: 0)
          .orderBy('SalePersent', descending: true)
          .orderBy('UploadTime', descending: true)
          .limit(10)
          .get();
      final list = snapshot.docs
          .map((document) => ProductModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<ProductModel>> getProductsForStore(String storeId) async {
    try {
      final snapshot = await db
          .collection('Products')
          .where('StoreId', isEqualTo: storeId)
          .orderBy('UploadTime', descending: true)
          .limit(10)
          .get();
      final list = snapshot.docs
          .map((document) => ProductModel.fromDocumentSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<ProductModel> getProductInformation(String productId) async {
    try {
      final documentSnapshot =
          await db.collection('Products').doc(productId).get();
      if (documentSnapshot.exists) {
        return ProductModel.fromDocumentSnapshot(documentSnapshot);
      } else {
        return ProductModel.empty();
      }
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      final storage = Get.put(HFirebaseStorageService());
      for (var product in products) {
        final image = await storage.getImageData(product.image);
        final url = await storage.uploadImageData(
            'Products/Images', image, product.image.toString());
        product.image = url;
        await db.collection('Products').doc(product.id).set(product.toJson());
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<ProductModel>> getProductsByQuery(
      Query query, String? storeId) async {
    try {
      QuerySnapshot querySnapshot;
      if (storeId != null) {
        querySnapshot = await query
            .where(
              'StoreId',
              isEqualTo: storeId,
            )
            .limit(10)
            .get();
      } else {
        querySnapshot = await query.limit(10).get();
      }
      final List<ProductModel> products = querySnapshot.docs
          .map((document) => ProductModel.fromQuerySnapshot(document))
          .toList();
      return products;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      print(e.toString());
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getProductsFromListIds(
      List<String> listIds) async {
    try {
      List<ProductModel> products = [];
      if (listIds.isNotEmpty) {
        final snapshot = await db
            .collection('Products')
            .where(FieldPath.documentId, whereIn: listIds)
            .get();
        products.addAll(snapshot.docs
            .map((document) => ProductModel.fromDocumentSnapshot(document))
            .toList());
      }
      return products;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại';
    }
  }

  getStoresFromListIds(List<String> listIds) async {
    try {
      List<StoreModel> stores = [];
      if (listIds.isNotEmpty) {
        final snapshot = await db
            .collection('Stores')
            .where(FieldPath.documentId, whereIn: listIds)
            .get();
        stores.addAll(snapshot.docs
            .map((document) => StoreModel.fromDocumentSnapshot(document))
            .toList());
      }
      return stores;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại';
    }
  }

  Future<void> updateSingleField(
      String productId, Map<String, dynamic> json) async {
    try {
      await db.collection('Products').doc(productId).update(json);
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
