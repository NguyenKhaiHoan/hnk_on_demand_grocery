import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/district_ward_model.dart';
import 'package:on_demand_grocery/src/repositories/address_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class AddressController extends GetxController {
  var listDropdownButtonWard = <String>[].obs;

  static AddressController get instance => Get.find();

  final addressRepository = Get.put(AddressRepository());
  var selectedAddress = AddressModel.empty().obs;
  var isSelectAddressLoading = false.obs;

  var toggleRefresh = true.obs;
  GlobalKey<FormState> addAddressFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  var city = ''.obs;
  var district = ''.obs;
  var ward = ''.obs;
  var isDefault = true.obs;

  List<DistrictModel> hanoiData = <DistrictModel>[].obs;

  @override
  void onInit() {
    readHaNoiDataJson();
    super.onInit();
  }

  Future<void> readHaNoiDataJson() async {
    final String response =
        await rootBundle.loadString('assets/json/hanoi_data.json');
    final data = await json.decode(response);

    var list = data['data'] as List<dynamic>;
    hanoiData = list.map((e) => DistrictModel.fromJson(e)).toList();
  }

  Future<List<AddressModel>> fetchAllUserAddresses() async {
    try {
      final addresses = await addressRepository.getAllUserAddress();
      selectedAddress.value = addresses.firstWhere(
        (address) => address.selectedAddress,
        orElse: () => AddressModel.empty(),
      );
      return addresses;
    } catch (e) {
      HAppUtils.showSnackBarError('Không tìm thấy địa chỉ', e.toString());
      return [];
    }
  }

  Future<void> selectAddress(AddressModel newSelectedAddress) async {
    try {
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
            selectedAddress.value.id, false);
      }
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;
      await addressRepository.updateSelectedField(
          selectedAddress.value.id, true);

      toggleRefresh.toggle();
    } catch (e) {
      HAppUtils.showSnackBarError(
          'Lỗi không thể lựa chọn địa chỉ', e.toString());
    }
  }

  Future<void> addAddress() async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (!addAddressFormKey.currentState!.validate() ||
          city.value == '' ||
          district.value == '' ||
          ward.value == '') {
        HAppUtils.stopLoading();
        HAppUtils.showSnackBarWarning('Chọn địa chỉ',
            'Bạn chưa điền đầy đủ địa chỉ. Hãy chọn đầy đủ Thành phố, Quận/Huyện, Phường/Xã và Số nhà, đường, ngõ.');
        return;
      }

      final address = AddressModel(
        id: '',
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        city: city.value,
        district: district.value,
        ward: ward.value,
        street: streetController.text.trim(),
        selectedAddress: true,
      );

      final id =
          await AddressRepository.instance.addAndFindIdForNewAddress(address);
      address.id = id;
      await selectAddress(address);

      HAppUtils.stopLoading();
      HAppUtils.showSnackBarSuccess(
          'Thành công', 'Bạn đã thêm địa chỉ giao hàng mới thành công');

      toggleRefresh.toggle();

      resetFormAddAddress();

      Navigator.of(Get.context!).pop();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', 'Thêm địa chỉ mới không thành công');
    }
  }

  void resetFormAddAddress() {
    nameController.clear();
    phoneController.clear();
    streetController.clear();
    city.value = '';
    district.value = '';
    ward.value = '';
    addAddressFormKey.currentState?.reset();
  }
}
