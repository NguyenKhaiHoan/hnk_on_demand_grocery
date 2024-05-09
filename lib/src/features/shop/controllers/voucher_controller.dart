import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/repositories/voucher_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class VoucherController extends GetxController {
  static VoucherController get instance => Get.find();

  final voucherRepository = Get.put(VoucherRepository());
  var checkVoucherController = TextEditingController();

  var selectedVoucher = ''.obs;
  var checkVoucherText = ''.obs;
  Rx<VoucherModel> useVoucher = VoucherModel.empty().obs;

  GlobalKey<FormState> checkVoucherFormKey = GlobalKey<FormState>();

  var checkDataVoucher = false.obs;

  Future<List<VoucherModel>> fetchAllStoreVouchers() async {
    try {
      final vouchers = await voucherRepository.getAllStoreVoucher();
      if (vouchers.isNotEmpty) {
        vouchers.sort((VoucherModel a, VoucherModel b) =>
            (a.endDate.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch)
                .compareTo(b.endDate.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch));
        checkDataVoucher.value = true;
      }
      return vouchers;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  Future<List<VoucherModel>> fetchAllGroFastVouchers() async {
    try {
      final vouchers = await voucherRepository.getAllGroFastVoucher();
      if (vouchers.isNotEmpty) {
        vouchers.sort((VoucherModel a, VoucherModel b) =>
            (a.endDate.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch)
                .compareTo(b.endDate.millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch));
        checkDataVoucher.value = true;
      }
      return vouchers;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  void assignValueToUseVoucher(VoucherModel voucher) {
    if (voucher.id == '') {
      selectedVoucher.value = '';
    } else {
      checkVoucherText.value = '';
      selectedVoucher.value = voucher.name;
    }
    useVoucher.value = voucher;
  }

  resetVoucher() {
    checkVoucherText.value = '';
    selectedVoucher.value = '';
    useVoucher.value = VoucherModel.empty();
    checkVoucherController.clear();
    checkDataVoucher.value = false;
  }

  // final cartController = CartController.instance;

  checkVoucher(String fieldName, String? value, int totalCartPrice,
      List<ProductInCartModel> products) async {
    try {
      DateTime now = DateTime.now();

      if (value == null || value.isEmpty) {
        checkVoucherText.value = '$fieldName chưa được điền.';
        return;
      }

      var voucher = await voucherRepository.getVoucherInformation(value);
      if (voucher.id == '') {
        checkVoucherText.value = 'Mã ưu dãi này không tồn tại.';
        return;
      }

      if (voucher.endDate.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        checkVoucherText.value = 'Mã ưu đãi này đã hết hạn sử dụng';
        return;
      }

      final userId = UserController.instance.user.value.id;
      if (voucher.usedById.contains(userId)) {
        checkVoucherText.value = 'Mã ưu đãi này đã được sử dụng.';
        return;
      }

      if (voucher.minAmount == null || voucher.minAmount == 0) {
        voucher.minAmount = 0;
      }

      if (voucher.storeId == '') {
        if (totalCartPrice < voucher.minAmount!) {
          checkVoucherText.value =
              'Mã ưu đãi này không được áp dụng do không đủ điểu kiện.';
          return;
        }
      } else {
        int totalPriceInStore = products
            .where((element) => element.storeId == voucher.storeId!)
            .fold(
                0,
                (previousValue, element) =>
                    previousValue + element.price! * element.quantity);
        if (totalPriceInStore < voucher.minAmount!) {
          checkVoucherText.value =
              'Mã ưu đãi này không được áp dụng do không đủ điểu kiện.';
          return;
        }
      }

      assignValueToUseVoucher(voucher);
      HAppUtils.showSnackBarSuccess(
          'Thành công', 'Bạn đã áp dụng mã ưu đãi thành công');
    } catch (e) {
      HAppUtils.showSnackBarError(
          'Lỗi', 'Không tìm được mã ưu đãi: ${e.toString()}');
      checkVoucherText.value = 'Không tìm được mã ưu đãi';
    }
  }

  checkVoucherButton(VoucherModel model, String value, int totalCartPrice,
      List<ProductInCartModel> products) async {
    try {
      DateTime now = DateTime.now();

      var voucher =
          await voucherRepository.getVoucherInformationFromId(model.id);
      if (voucher.id == '') {
        checkVoucherText.value = 'Mã ưu dãi này không tồn tại.';
        return;
      }

      if (voucher.endDate.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        checkVoucherText.value = 'Mã ưu đãi này đã hết hạn sử dụng';
        return;
      }

      final userId = UserController.instance.user.value.id;
      if (voucher.usedById.contains(userId)) {
        checkVoucherText.value = 'Mã ưu đãi này đã được sử dụng.';
        return;
      }

      if (voucher.minAmount == null || voucher.minAmount == 0) {
        voucher.minAmount = 0;
      }

      if (voucher.storeId == '') {
        if (totalCartPrice < voucher.minAmount!) {
          checkVoucherText.value =
              'Mã ưu đãi này không được áp dụng do không đủ điểu kiện.';
          return;
        }
      } else {
        int totalPriceInStore = products
            .where((element) => element.storeId == voucher.storeId!)
            .fold(
                0,
                (previousValue, element) =>
                    previousValue + element.price! * element.quantity);
        if (totalPriceInStore < voucher.minAmount!) {
          checkVoucherText.value =
              'Mã ưu đãi này không được áp dụng do không đủ điểu kiện.';
          return;
        }
      }

      selectedVoucher.value = value;
      assignValueToUseVoucher(voucher);
      print(voucher.toJson().toString());
      HAppUtils.showSnackBarSuccess(
          'Thành công', 'Bạn đã áp dụng mã ưu đãi thành công');
    } catch (e) {
      HAppUtils.showSnackBarError(
          'Lỗi', 'Không tìm được mã ưu đãi: ${e.toString()}');
      checkVoucherText.value = 'Không tìm được mã ưu đãi';
    }
  }
}
