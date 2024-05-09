import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_auth_exceptions.dart';
import 'package:on_demand_grocery/src/exceptions/firebase_exception.dart';

class AuthenticationRepositoryTest extends GetxController {
  static AuthenticationRepositoryTest get instance => Get.find();
  FirebaseAuth auth;

  User? get authUser => auth.currentUser;

  AuthenticationRepositoryTest({required this.auth});

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
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
      return await auth.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) async {
        await auth.currentUser!.updatePassword(newPassword);
      }).catchError((e) => throw HFirebaseAuthException(code: e.code).message);
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await userAccount?.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

  //     return await auth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     throw HFirebaseAuthException(code: e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw HFirebaseException(code: e.code).message;
  //   } catch (e) {
  //     throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
  //   }
  // }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
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
      await auth.currentUser!.sendEmailVerification();
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
      await auth.sendPasswordResetEmail(email: email);
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
    } on FirebaseAuthException catch (e) {
      throw HFirebaseAuthException(code: e.code).message;
    } on FirebaseException catch (e) {
      throw HFirebaseException(code: e.code).message;
    } catch (e) {
      throw 'Đã xảy ra sự cố. Xin vui lòng thử lại sau.';
    }
  }
}
