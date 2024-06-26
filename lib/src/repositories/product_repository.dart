import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/services/firebase_storage_service.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  var db = FirebaseFirestore.instance;

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
    } catch (e) {
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> getProductsRegistration() async {
    try {
      List<ProductModel> products = [];
      List<String> productIds = [];
      final snapshot = await db
          .collection('Users')
          .doc(UserController.instance.user.value.id)
          .collection('RegisteredProducts')
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        productIds.add(data['ProductId']);
      }
      products = await getProductsFromListIds(productIds);
      return products;
    } catch (e) {
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại';
    }
  }

  Future<List<ProductModel>> fetchProductsByName(
      List<String> productNames) async {
    try {
      List<ProductModel> products = [];
      if (productNames.isNotEmpty) {
        final productsRef = FirebaseFirestore.instance.collection('Products');

        for (String name in productNames) {
          final querySnapshot = await productsRef
              .where("Name", isGreaterThanOrEqualTo: name)
              .where("Name", isLessThanOrEqualTo: "$name\uf7ff")
              .orderBy('Name')
              .limit(3)
              .get();

          for (var doc in querySnapshot.docs) {
            final product = ProductModel.fromDocumentSnapshot(doc);
            products.add(product);
          }
        }
      }
      return products;
    } catch (e) {
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại ';
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
    } catch (e) {
      throw 'Đã có sự cố xảy ra. Xin vui lòng thử lại';
    }
  }

  Future<void> updateSingleField(
      String productId, Map<String, dynamic> json) async {
    try {
      await db.collection('Products').doc(productId).update(json);
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<ProductModel>> getSearchAllProducts(String text) async {
    try {
      final snapshot = await db
          .collection("Products")
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
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
