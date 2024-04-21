import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_demand_grocery/src/common_widgets/splash_screen_widget.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_auth_exceptions.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/on_boarding_screen.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/banner_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/services/firebase_notification_service.dart';
import 'package:on_demand_grocery/src/services/local_service.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  final deviceStorage = GetStorage();
  final db = FirebaseFirestore.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    screenRedirect();
  }

  void screenRedirect() async {
    final user = _auth.currentUser;
    FlutterNativeSplash.remove();
    if (user != null) {
      await checkUserRegistration(user);
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.toNamed(HAppRoutes.login)
          : Get.toNamed(HAppRoutes.onboarding);
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> changePasswordWithEmailAndPassword(
      String email, String oldPassword, String newPassword) async {
    try {
      var credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      return _auth.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) {
        _auth.currentUser!.updatePassword(newPassword);
      }).catchError((e) {
        throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
      });
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Mật khẩu hiện tại không đúng.';
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> sendPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> logOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.toNamed(HAppRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  Future<void> checkUserRegistration(User user) async {
    try {
      log('user không null: ${user.uid}');
      bool userIsRegistered = false;
      await db
          .collection('Users')
          .where('Id', isEqualTo: user.uid)
          .get()
          .then((value) {
        userIsRegistered = value.size > 0 ? true : false;
      });
      log('user trạng thái đã đăng ký: $userIsRegistered');

      if (userIsRegistered) {
        log('user đã đăng ký');
        if (user.emailVerified) {
          log('user đã xác thức');
          await HLocalService.initializeStorage(user.uid);
          Get.put(CategoryController());
          Get.put(BannerController());
          final userController = Get.put(UserController());
          await userController.fetchCurrentPosition();
          Get.toNamed(HAppRoutes.root);
        } else {
          log('user chưa xác thức');
          Get.toNamed(HAppRoutes.verify, arguments: {'email': user.email});
        }
      } else {
        deviceStorage.writeIfNull('isFirstTime', true);
        deviceStorage.read('isFirstTime') != true
            ? Get.toNamed(HAppRoutes.login)
            : Get.toNamed(HAppRoutes.onboarding);
      }
    } catch (e) {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.toNamed(HAppRoutes.login)
          : Get.toNamed(HAppRoutes.onboarding);
      HAppUtils.showSnackBarError(
          'Lỗi', 'Tài khoản người dùng chưa được đăng ký');
    }
  }
}
