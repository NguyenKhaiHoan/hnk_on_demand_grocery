import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_address_model.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class AddressRepositoryTest extends GetxController {
  static AddressRepositoryTest get instance => Get.find();

  AddressRepositoryTest({required this.db});

  FirebaseFirestore db;

  Future<List<AddressModel>> getAllUserAddress(String userId) async {
    try {
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final addresses = await db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();
      return addresses.docs
          .map((snapshot) => AddressModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<StoreAddressModel>> getStoreAddress(String storeId) async {
    try {
      final addresses = await db
          .collection('Stores')
          .doc(storeId)
          .collection('Addresses')
          .get();
      return addresses.docs
          .map((snapshot) => StoreAddressModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> updateAddressField(
      String addressId, Map<String, dynamic> json, String userId) async {
    try {
      await db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .update(json);
    } catch (e) {
      throw 'Đã xảy ra sự cố. Không thể cập nhật lựa chọn địa chỉ của bạn. Vui lòng thử lại sau.';
    }
  }

  Future<String> addAndFindIdForNewAddress(
      AddressModel address, String userId) async {
    try {
      final currentAddress = await db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
