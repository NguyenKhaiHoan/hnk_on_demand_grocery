import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_address_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class HLocationService {
  static Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      HAppUtils.showSnackBarError('Lỗi', 'Dịch vụ định vị bị vô hiệu hóa.');
      return Future.error('Dịch vụ định vị bị vô hiệu hóa.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        HAppUtils.showSnackBarError('Lỗi', 'Quyền truy cập vị trí bị từ chối.');
        return Future.error('Quyền truy cập vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      HAppUtils.showSnackBarError('Lỗi',
          'Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền.');
      return Future.error(
          'Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<List<String>> getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      return [
        place.street ?? '',
        place.subAdministrativeArea ?? '',
        place.administrativeArea ?? ''
      ];
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  static Future<void> getNearbyStoresAndProducts() async {
    final storeController = Get.put(StoreController());
    final productController = Get.put(ProductController());
    storeController.allNearbyStores.clear();
    productController.nearbyProduct.clear();
    final currentPosition = AddressController.instance.selectedAddress.value;
    Geofire.initialize('Stores');
    try {
      Geofire.queryAtLocation(
              currentPosition.latitude, currentPosition.longitude, 3)!
          .listen((map) {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];
          switch (callBack) {
            case Geofire.onKeyEntered:
              storeController.addNearbyStores(map['key']);
              break;
            case Geofire.onGeoQueryReady:
              break;
          }
        }
      }).onError((error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }
}
