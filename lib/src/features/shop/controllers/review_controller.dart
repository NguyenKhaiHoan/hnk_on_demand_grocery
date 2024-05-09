import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/review_model.dart';
import 'package:on_demand_grocery/src/repositories/review_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  var productImages = <XFile>[].obs;
  var rating = 0.0.obs;
  final reviewTextController = TextEditingController();
  var userReviewedProduct = false.obs;

  final reviewRepository = Get.put(ReviewRepository());

  void uploadReviewImage(
      String productId, String reviewId, List<XFile> images) async {
    try {
      if (images.isNotEmpty) {
        final imageUrl = await reviewRepository.uploadImage(
            'Reviews/$productId/Images', images);
        Map<String, dynamic> json = {'Images': imageUrl};
        await reviewRepository.updateReview(productId, reviewId, json);
        HAppUtils.showSnackBarSuccess(
            'Thành công', 'Bạn đã thay đổi ảnh hồ sơ thành công.');
      }
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  void pickReviewImage() async {
    final images = await ImagePicker()
        .pickMultiImage(imageQuality: 70, maxHeight: 512, maxWidth: 512);
    if (images.isNotEmpty) {
      for (var image in images) {
        productImages.add(image);
      }
    } else {
      HAppUtils.showSnackBarWarning("Cảnh báo", 'Bạn chưa chọn ảnh nào');
    }
  }

  Future<void> writeReview(String productId, String orderId) async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (rating.value <= 0) {
        HAppUtils.stopLoading();
        HAppUtils.showSnackBarWarning('Bạn chưa chọn xếp hạng',
            'Hãy chọn xếp hạng để gửi đánh giá, điều này là bắt buộc');
        return;
      }

      final userId = UserController.instance.user.value.id;

      final review = ReviewModel(
          id: '',
          rating: rating.value,
          images: [],
          review: reviewTextController.text.trim(),
          userId: userId,
          orderId: orderId,
          uploadTime: DateTime.now());

      final id =
          await reviewRepository.addAndFindIdForNewReview(productId, review);

      if (productImages.isNotEmpty) {
        uploadReviewImage(productId, id, productImages);
      }

      resetReview();
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarSuccess(
          'Thành công', 'Bạn đã gửi đánh giá thành công');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', 'Thêm địa chỉ mới không thành công');
    }
  }

  resetReview() {
    productImages.value = [];
    userReviewedProduct.value = false;
    rating.value = -1.0;
  }

  Future<bool> checkUserReviewProductInOrder(
      String productId, String orderId) async {
    try {
      var check = await reviewRepository.checkUserReviewProductInOrder(
          productId, orderId);
      return check;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return false;
    }
  }

  Future<List<ReviewModel>> fetchAllProductReview(String productId) async {
    try {
      final reviews = await reviewRepository.getAllProductReviews(productId);
      return reviews;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }
}
