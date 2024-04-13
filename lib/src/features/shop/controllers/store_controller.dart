import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_location_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class StoreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static StoreController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  var listOfStore = <StoreModel>[].obs;
  var listOfFamousStore = <StoreModel>[].obs;

  final storeRepository = Get.put(StoreRepository());

  var isLoading = false.obs;

  Future<void> fetchStores() async {
    try {
      isLoading.value = true;
      final stores = await storeRepository.getAllStores();
      listOfStore.assignAll(stores);
      listOfFamousStore
          .assignAll(stores.where((e) => e.isFamous == true).toList());
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  var isLoadingNearby = false.obs;

  var allNearbyStoreId = <String>[].obs;
  var allNearbyStoreLocation = <StoreLocationModel>[].obs;

  addNearbyStore(String id) {
    allNearbyStoreId.addIf(!allNearbyStoreId.contains(id), id);
  }

  removeNearbyStore(String id) {
    int index = allNearbyStoreId.indexWhere((nearbyId) => nearbyId == id);
    allNearbyStoreId.removeAt(index);
  }

  getProductCategoryForStore(int index) {
    Query baseQuery = FirebaseFirestore.instance.collection('Products');
    Query query = baseQuery;
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
        query = query.where('CategoryId', isEqualTo: (index - 2).toString());
        // .orderBy('CategoryId');
        break;
      default:
        query = query;
        break;
    }
    return query.limit(10);
  }

  final TextEditingController controller = TextEditingController();

  var showSuffixIcon = false.obs;
  var showFilter = false.obs;

  StoreLocationModel convertStoreModelToStoreLocationModel(String storeId) {
    final index = Get.put(StoreController())
        .allNearbyStoreLocation
        .indexWhere((element) => element.storeId == storeId);
    if (index >= 0) {
      return StoreController.instance.allNearbyStoreLocation[index];
    }
    return StoreLocationModel(
        storeId: '', latitude: 0, longitude: 0, distance: 0);
  }
}
