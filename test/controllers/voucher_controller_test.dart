import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';

import '../repositories/voucher_repository_test.dart';

class VoucherControllerTest extends GetxController {
  static VoucherControllerTest get instance => Get.find();

  var selectedVoucher = ''.obs;
  var checkVoucherText = 'Success'.obs;
  Rx<VoucherModel> useVoucher = VoucherModel.empty().obs;

  final voucherRepository = VoucherRepositoryTest.instance;

  void assignValueToUseVoucher(VoucherModel voucher) {
    if (voucher.id == '') {
      selectedVoucher.value = '';
    } else {
      checkVoucherText.value = 'Success';
      selectedVoucher.value = voucher.name;
    }
    useVoucher.value = voucher;
  }

  resetVoucher() {
    checkVoucherText.value = '';
    selectedVoucher.value = '';
    useVoucher.value = VoucherModel.empty();
  }

  Future<void> checkVoucherButton(
      VoucherModel model,
      String value,
      int totalCartPrice,
      List<ProductInCartModel> products,
      String userId) async {
    try {
      DateTime now = DateTime.now();

      var voucher =
          await voucherRepository.getVoucherInformationFromId(model.id);
      if (voucher.id == '') {
        checkVoucherText.value = 'Mã ưu dãi này không tồn tại.';
        return;
      }

      if (voucher.endDate.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        checkVoucherText.value = 'Mã ưu đãi này đã hết hạn sử dụng.';
        return;
      }

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
    } catch (e) {
      checkVoucherText.value = 'Không tìm được mã ưu đãi';
    }
  }
}
