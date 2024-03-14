import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/repositories/address_repository.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  final addressController = Get.put(AddressController());
  final authenticationRepository = Get.put(AuthenticationRepository());

  var user = UserModel.empty().obs;
  var isLoading = false.obs;
  var isUploadImageLoading = false.obs;
  var streetAddress = ''.obs;
  var districtAddress = ''.obs;
  var cityAddress = ''.obs;
  var deliveryAddress = ''.obs;
  var currentPosition = Position(
          longitude: 0.0,
          latitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0)
      .obs;
  var isSetAddressDeliveryTo = false.obs;

  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
  }

  Future<void> fetchCurrentPosition() async {
    try {
      isSetAddressDeliveryTo.value = true;
      HAppUtils.loadingOverlaysAddress();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      await fetchUserRecord();

      List<AddressModel> addresses = [];
      addresses = await addressController.fetchAllUserAddresses();

      if (addresses.isEmpty) {
        currentPosition.value = await HLocationService.getGeoLocationPosition();
        currentPosition.refresh();
        List<String> listPartOfAddress =
            await HLocationService.getAddressFromLatLong(currentPosition.value);

        streetAddress.value = listPartOfAddress[0];
        districtAddress.value = listPartOfAddress[1];
        cityAddress.value = listPartOfAddress[2];
        deliveryAddress.value =
            '${streetAddress.value}, ${districtAddress.value}, ${cityAddress.value}';
        if (cityAddress.value == 'Hà Nội') {
          AddressModel tempAddress = AddressModel(
              id: '',
              name: user.value.name,
              phoneNumber: user.value.phoneNumber == ''
                  ? 'Số điện thoại còn trống'
                  : user.value.phoneNumber,
              district: districtAddress.value,
              ward: '',
              street: streetAddress.value,
              selectedAddress: true,
              latitude: currentPosition.value.latitude,
              longitude: currentPosition.value.longitude);
          final id = await AddressRepository.instance
              .addAndFindIdForNewAddress(tempAddress);

          tempAddress.id = id;
          await addressController.selectAddress(tempAddress);
        } else {
          isSetAddressDeliveryTo.value = false;
          HAppUtils.stopLoading();
          Get.offAllNamed(HAppRoutes.noDeliver);
          return;
        }
      } else {
        AddressModel selectedAddress = addresses.firstWhere(
            (address) => address.selectedAddress,
            orElse: () => addresses.first);
        deliveryAddress.value =
            '${selectedAddress.street}, ${selectedAddress.ward}, ${selectedAddress.district}, Hà Nội';
      }

      isSetAddressDeliveryTo.value = false;
      HAppUtils.stopLoading();
    } catch (e) {
      isSetAddressDeliveryTo.value = false;
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  Future<void> saveUserRecord(
      UserCredential? userCredential, String authenticationBy) async {
    try {
      await fetchUserRecord();
      if (user.value.id.isEmpty) {
        if (userCredential != null) {
          final user = UserModel(
              id: userCredential.user!.uid,
              name: userCredential.user!.displayName ?? '',
              email: userCredential.user!.email ?? '',
              phoneNumber: userCredential.user!.phoneNumber ?? '',
              profileImage: userCredential.user!.photoURL ?? '',
              creationDate:
                  DateFormat('EEEE, d-M-y', 'vi').format(DateTime.now()),
              authenticationBy: authenticationBy,
              listOfFavoriteProduct: [],
              listOfRegisterNotificationProduct: [],
              listOfFavoriteStore: []);

          await userRepository.saveUserRecord(user);
        }
      }
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      isLoading.value = false;
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> fetchUserRecord() async {
    try {
      isLoading.value = true;
      final user = await userRepository.getUserInformation();
      this.user(user);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      HAppUtils.showSnackBarError(
          'Lỗi', 'Không tìm thấy dữ liệu của người dùng');
      user(UserModel.empty());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadingUserRecord() async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      final user = await userRepository.getUserInformation();
      this.user(user);

      HAppUtils.stopLoading();
    } catch (e) {
      HAppUtils.showSnackBarError(
          'Lỗi', 'Không tìm thấy dữ liệu của người dùng');
      user(UserModel.empty());
    } finally {
      HAppUtils.stopLoading();
    }
  }

  void uploadUserProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        isUploadImageLoading.value = true;
        final imageUrl = await userRepository.uploadImage(
            'Users/${user.value.id}/Images/Profile', image);
        Map<String, dynamic> json = {'ProfileImage': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profileImage = imageUrl;
        user.refresh();

        HAppUtils.showSnackBarSuccess(
            'Thành công', 'Bạn đã thay đổi ảnh hồ sơ thành công.');

        isUploadImageLoading.value = false;
      }
    } catch (e) {
      isUploadImageLoading.value = false;
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
