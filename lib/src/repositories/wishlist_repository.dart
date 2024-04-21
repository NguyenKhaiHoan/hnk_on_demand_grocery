import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';

class WishlistRepository extends GetxController {
  static WishlistRepository get instance => Get.find();

  final db = FirebaseFirestore.instance;

  Future<List<WishlistModel>> getAllUserWishlist() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Không có thông tin người dùng';

      final wishlists = await db
          .collection('Users')
          .doc(userId)
          .collection('Wishlists')
          .orderBy('UploadTime', descending: true)
          .get();
      return wishlists.docs
          .map((snapshot) => WishlistModel.fromDocumentSnapshot(snapshot))
          .toList();
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> updateWishlistField(
      String wishlistId, Map<String, dynamic> json) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await db
          .collection('Users')
          .doc(userId)
          .collection('Wishlists')
          .doc(wishlistId)
          .update(json);
    } catch (e) {
      throw 'Đã xảy ra sự cố. Không thể cập nhật lựa chọn địa chỉ của bạn. Vui lòng thử lại sau.';
    }
  }

  Future<String> addAndFindIdForNewWishlist(WishlistModel wishlist) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentWishlist = await db
          .collection('Users')
          .doc(userId)
          .collection('Wishlists')
          .add(wishlist.toJson());
      return currentWishlist.id;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
