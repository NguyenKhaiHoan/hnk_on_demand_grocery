import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/authentication_repository_test.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('Account test', () {
    late AuthenticationRepositoryTest authenticationRepositoryTest;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUserCredential mockUserCredential;
    setUpAll(() async {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      authenticationRepositoryTest =
          AuthenticationRepositoryTest(auth: mockFirebaseAuth);
    });

    late String email;
    late String password;

    setUp(() {
      email = "email@gmail.com";
      password = "Password1234!";
    });

    group('Sign up', () {
      test('1.1 Sign up when entering your registered email', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expectLater(
          authenticationRepositoryTest.registerWithEmailAndPassword(
              email, password),
          throwsA(
              'Địa chỉ email đã được đăng ký. Vui lòng sử dụng một địa chỉ email khác.'),
        );
      });

      test('1.2 Sign up in by entering a valid email and password', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password),
        ).thenAnswer((realInvocation) =>
            Future<MockUserCredential>.value(mockUserCredential));

        expect(
            await authenticationRepositoryTest.registerWithEmailAndPassword(
                email, password),
            mockUserCredential);
      });
    });

    group('Login', () {
      test('2.1 Log in by entering a invalid email and password', () {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expectLater(
          authenticationRepositoryTest.loginWithEmailAndPassword(
              email, password),
          throwsA(
              'Thông tin đăng nhập không hợp lệ. Người dùng không được tìm thấy.'),
        );
      });

      test('2.2 Log in by entering a valid email and password', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password),
        ).thenAnswer((realInvocation) =>
            Future<MockUserCredential>.value(mockUserCredential));

        expect(
            await authenticationRepositoryTest.loginWithEmailAndPassword(
                email, password),
            mockUserCredential);
      });
    });
  });
}
