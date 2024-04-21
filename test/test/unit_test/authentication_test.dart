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

    group('Login', () {
      test('Login', () async {
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

      test('Login with wrong credentials throws exception', () {
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
    });

    group('Sign up', () {
      test('Sign up', () async {
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

      test('Sign up with email already in use throws exception', () async {
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
    });
  });
}
