import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class VoucherRepositoryTest extends GetxController {
  static VoucherRepositoryTest get instance => Get.find();

  VoucherRepositoryTest({required this.db});

  FirebaseFirestore db;

  Future<List<VoucherModel>> getAllStoreVoucher(String userId) async {
    try {
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final storeVouchers = await db
          .collection('Vouchers')
          .where('StoreId', isNotEqualTo: '')
          .where('IsActive', isEqualTo: true)
          .get();

      final unusedVouchers = storeVouchers.docs.where((voucher) =>
          (voucher.data()['UsedById'] == null ||
              !voucher.data()['UsedById'].contains(userId)));
      return unusedVouchers
          .map((snapshot) => VoucherModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<List<VoucherModel>> getAllGroFastVoucher(String userId) async {
    try {
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final groFastVouchers = await db
          .collection('Vouchers')
          .where('StoreId', isEqualTo: '')
          .where('IsActive', isEqualTo: true)
          .get();

      final unusedVouchers = groFastVouchers.docs.where((voucher) =>
          (voucher.data()['UsedById'] == null ||
              !voucher.data()['UsedById'].contains(userId)));

      return unusedVouchers
          .map((snapshot) => VoucherModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      HAppUtils.showSnackBarError("Lỗi", e.toString());
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<VoucherModel> getVoucherInformation(String name) async {
    try {
      final documentSnapshot =
          await db.collection('Vouchers').where('Name', isEqualTo: name).get();
      if (documentSnapshot.docs.isEmpty) {
        return VoucherModel.empty();
      } else {
        return VoucherModel.fromDocumentSnapshot(documentSnapshot.docs.first);
      }
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<VoucherModel> getVoucherInformationFromId(String id) async {
    try {
      final documentSnapshot = await db.collection('Vouchers').doc(id).get();
      if (!documentSnapshot.exists) {
        return VoucherModel.empty();
      } else {
        return VoucherModel.fromDocumentSnapshot(documentSnapshot);
      }
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> updateVoucher(VoucherModel voucher) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      var list = voucher.usedById;
      list.addIf(!list.contains(userId), userId);
      await db
          .collection('Vouchers')
          .doc(voucher.id)
          .update({'UsedById': list});
    } catch (e) {
      throw 'Đã xảy ra sự cố. Không thể cập nhật được mã ưu đãi. Vui lòng thử lại sau.';
    }
  }
}
