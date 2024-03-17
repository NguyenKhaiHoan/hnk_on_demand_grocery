import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/check_box_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:tuple/tuple.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final productRepository = Get.put(ProductRepository());

  var listOfProduct = <ProductModel>[].obs;
  var nearbyProduct = <ProductModel>[].obs;

  var isLoadingNearby = false.obs;

  Future<void> addNearbyProducts(String storeId) async {
    isLoadingNearby.value = true;

    final products =
        await ProductRepository.instance.getProductsForStore(storeId);
    nearbyProduct.addAll(products);
    nearbyProduct.sort((a, b) => -a.uploadTime.compareTo(b.uploadTime));
    isLoadingNearby.value = false;
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

  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) {
        return [];
      }

      final products = await productRepository.getProductsByQuery(query);

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

  var tagsProductObs = <Tag>[].obs;

  filterProduct(List<ProductModel> list) {
    list = list
        .where((product) =>
            (tagsProductObs[0].active ? true : true) &&
            (tagsProductObs[1].active ? product.rating >= 4.0 : true) &&
            (tagsProductObs[2].active ? product.origin != 'Việt Nam' : true))
        .toList();
    return filterProductSort(list);
  }

  filterProductSort(List<ProductModel> list) {
    if (selectedValueSort.value == 'Mới nhất') {
      list.sort((a, b) => a.uploadTime.compareTo(b.uploadTime));
    } else if (selectedValueSort.value == 'A - Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (selectedValueSort.value == 'Z - A') {
      list.sort((a, b) => -a.name.compareTo(b.name));
    } else if (selectedValueSort.value == 'Thấp - Cao') {
      list.sort((a, b) => a.priceSale == 0
          ? (b.priceSale == 0
              ? a.price.compareTo(b.price)
              : a.price.compareTo(b.priceSale))
          : (b.priceSale == 0
              ? a.priceSale.compareTo(b.price)
              : a.priceSale.compareTo(b.priceSale)));
    } else if (selectedValueSort.value == 'Cao - Thấp') {
      list.sort((a, b) => a.priceSale == 0
          ? (b.priceSale == 0
              ? -a.price.compareTo(b.price)
              : -a.price.compareTo(b.priceSale))
          : (b.priceSale == 0
              ? -a.priceSale.compareTo(b.price)
              : -a.priceSale.compareTo(b.priceSale)));
    }
    return list;
  }
}
