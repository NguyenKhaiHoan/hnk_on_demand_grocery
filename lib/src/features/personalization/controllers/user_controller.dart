import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  var user = UserModel.empty().obs;
  var isLoading = false.obs;
  var isUploadImageLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
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
              authenticationBy: authenticationBy);

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
      user(UserModel.empty());
    } finally {
      isLoading.value = false;
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
