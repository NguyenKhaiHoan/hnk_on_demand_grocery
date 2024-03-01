import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_demand_grocery/src/common_widgets/splash_screen_widget.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_auth_exceptions.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/on_boarding_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/root_screen.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  final deviceStorage = GetStorage();

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    screenRedirect();
  }

  void screenRedirect() async {
    final user = _auth.currentUser;
    FlutterNativeSplash.remove();
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(const SplashScreen(widget: RootScreen()));
      } else {
        Get.offAllNamed(HAppRoutes.verify, arguments: {'email': user.email});
      }
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(const SplashScreen(widget: LoginScreen()))
          : Get.offAll(SplashScreen(widget: OnboardingScreen()));
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
        print(e.toString());
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
      Get.offAllNamed(HAppRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
