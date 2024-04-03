import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/check_box_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final productRepository = Get.put(ProductRepository());

  var listOfProduct = <ProductModel>[].obs;
  var nearbyProduct = <ProductModel>[].obs;

  var isLoadingNearby = false.obs;

  Future<void> addNearbyProducts(String storeId) async {
    isLoadingNearby.value = true;
    if (StoreController.instance.allNearbyStoreId.contains(storeId)) {
      final products = await productRepository.getProductsForStore(storeId);
      nearbyProduct.addAll(products);
    }
    isLoadingNearby.value = false;
  }

  List<ProductModel> sortProductByUploadTime() {
    nearbyProduct.sort((a, b) => -a.uploadTime.compareTo(b.uploadTime));
    return nearbyProduct;
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
    return filterProductSort(baseQuery);
  }

  getProductCategory(int index, Query query) {
    switch (index) {
      case 0:
        query = query
            .where('CountBuyed', isGreaterThanOrEqualTo: 100)
            .orderBy('CountBuyed', descending: true);
        break;
      case 1:
        query = query
            .where('SalePersent', isNotEqualTo: 0)
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
        query = query
            .where('CategoryId', isEqualTo: (index - 2).toString())
            .orderBy('CategoryId');
        break;
      default:
        query = query;
        break;
    }
    return filterProductSort(query);
  }

  filterProduct(Query query, int index) {
    if (tagsProductObs[0].active) {
      final listIds =
          nearbyProduct.map((product) => product.id).take(10).toList();
      query = query.where(FieldPath.documentId, whereIn: listIds);
    }
    if (tagsProductObs[1].active) {
      query = query
          .where('Rating', isGreaterThanOrEqualTo: 4.0)
          .orderBy('Rating', descending: true);
    }
    if (tagsProductObs[2].active) {
      query = query.where('Origin', isNotEqualTo: 'Việt Nam').orderBy('Origin');
    }
    return getProductCategory(index, query);
  }

  filterProductSort(Query query) {
    if (selectedValueSort.value == 'Mới nhất') {
      query = query.orderBy('UploadTime', descending: true);
    } else if (selectedValueSort.value == 'A - Z') {
      query = query.orderBy('Name');
    } else if (selectedValueSort.value == 'Z - A') {
      query = query.orderBy('Name', descending: true);
    } else if (selectedValueSort.value == 'Thấp - Cao') {
      query = query.orderBy('PriceSale');
    } else if (selectedValueSort.value == 'Cao - Thấp') {
      query = query.orderBy('PriceSale', descending: true);
    }
    print(query.parameters.toString());
    return query.limit(10);
  }
}
