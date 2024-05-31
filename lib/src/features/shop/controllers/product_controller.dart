import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final productRepository = Get.put(ProductRepository());

  var listOfProduct = <ProductModel>[].obs;
  var nearbyProduct = <ProductModel>[].obs;

  var isLoadingNearby = false.obs;

  Future<void> addNearbyProducts(String storeId) async {
    if (StoreController.instance.allNearbyStoreId.contains(storeId)) {
      final products = await productRepository.getProductsForStore(storeId);
      nearbyProduct.addAll(products);
    }
  }

  List<ProductModel> sortProductByUploadTime() {
    if (nearbyProduct.isNotEmpty) {
      nearbyProduct.sort((a, b) => -a.uploadTime.compareTo(b.uploadTime));
      return nearbyProduct;
    }
    return [];
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchAllProducts();
    super.onInit();
  }

  void fetchAllProducts() async {
    try {
      isLoading.value = true;

      final products = await productRepository.getAllProducts();

      listOfProduct.assignAll(products);
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllProductsForStore(String storeId) async {
    try {
      final products = await productRepository.getProductsForStore(storeId);
      return products;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsByQuery(
      Query? query, String? storeId) async {
    try {
      if (query == null) {
        return [];
      }

      final products =
          await productRepository.getProductsByQuery(query, storeId);

      return products;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsByQueryExceptId(
      ProductInCartModel model) async {
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await FirebaseFirestore.instance
          .collection("Products")
          .where(
            'StoreId',
            isEqualTo: model.storeId,
          )
          .where("Name", isGreaterThanOrEqualTo: model.productName)
          .where("Name", isLessThanOrEqualTo: "${model.productName}\uf7ff")
          .orderBy('Name')
          .orderBy("UploadTime", descending: true)
          .limit(10)
          .get();

      final List<ProductModel> products = querySnapshot.docs
          .map((document) => ProductModel.fromQuerySnapshot(document))
          .toList();

      products.removeWhere((element) => element.id == model.productId);

      products.sort((a, b) {
        if (model.replacementProduct != null &&
            a.id == model.replacementProduct!.id &&
            b.id != model.replacementProduct!.id) {
          return -1;
        } else if (model.replacementProduct != null &&
            b.id == model.replacementProduct!.id &&
            a.id != model.replacementProduct!.id) {
          return 1;
        } else {
          return (a.priceSale).compareTo(b.priceSale);
        }
      });

      return products;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  // var comparePriceProducts = <ProductModel>[].obs;

  // void getComparePriceProduct(ProductModel model) {
  //   if (comparePriceProducts.isNotEmpty) {
  //     comparePriceProducts.clear();
  //   }
  //   comparePriceProducts.value = listProducts
  //       .where((product) => product.name == model.name && product != model)
  //       .toList();
  // }

  var selectedValueSort = 'Mới nhất'.obs;

  var tagsProductObs = tagsProduct.obs;

  getFutureQuery(int index) {
    Query baseQuery = FirebaseFirestore.instance.collection('Products');
    return getProductCategory(index, baseQuery);
  }

  getProductCategory(int index, Query query) {
    Query baseQuery = query;
    switch (index) {
      case 0:
        query = baseQuery
            .where('CountBuyed', isGreaterThanOrEqualTo: 100)
            .orderBy('CountBuyed', descending: true);
        break;
      case 1:
        query = baseQuery
            .where('SalePersent', isGreaterThan: 0)
            .orderBy('SalePersent', descending: true);
        break;
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
        if (index >= 2) {
          query =
              baseQuery.where('CategoryId', isEqualTo: (index - 2).toString());
          print((index - 2).toString());
        }
        break;
      default:
        // query = baseQuery;
        break;
    }
    print('Vào get');
    print(query.parameters.toString());
    return filterProductSort(query);
  }

  // filterProduct(Query query, int index) {
  //   Query baseQuery = query;
  //   if (tagsProductObs[0].active) {
  //     if (nearbyProduct.isNotEmpty) {
  //       final listIds =
  //           nearbyProduct.map((product) => product.id).take(10).toList();
  //       query = baseQuery.where(FieldPath.documentId, whereIn: listIds);
  //     }
  //   }
  //   if (tagsProductObs[1].active) {
  //     query = query
  //         .where('Rating', isGreaterThanOrEqualTo: 4.0)
  //         .orderBy('Rating', descending: true);
  //   }
  //   if (tagsProductObs[2].active) {
  //     query =
  //         baseQuery.where('Origin', isNotEqualTo: 'Việt Nam').orderBy('Origin');
  //   }
  //   print('Vào filter');
  //   print(query.parameters.toString());
  //   return getProductCategory(index, query);
  // }

  filterProductSort(Query query) {
    Query baseQuery = query;
    if (selectedValueSort.value == 'Mới nhất') {
      query = baseQuery.orderBy('UploadTime', descending: true);
    } else if (selectedValueSort.value == 'A - Z') {
      query = baseQuery.orderBy('Name');
    } else if (selectedValueSort.value == 'Z - A') {
      query = baseQuery.orderBy('Name', descending: true);
    } else if (selectedValueSort.value == 'Thấp - Cao') {
      query = baseQuery.orderBy('PriceSale');
    } else if (selectedValueSort.value == 'Cao - Thấp') {
      query = baseQuery.orderBy('PriceSale', descending: true);
    }
    print('Vào filter sort');
    print(query.parameters.toString());
    return query.limit(10);
  }
}
