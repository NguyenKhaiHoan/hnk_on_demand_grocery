class HFirebaseAuthException implements Exception {
  final String code;

  HFirebaseAuthException({required this.code});
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Địa chỉ email đã được đăng ký. Vui lòng sử dụng một địa chỉ email khác.';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ. Vui lòng nhập một địa chỉ email hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn một mật khẩu mạnh hơn.';
      case 'user-disabled':
        return 'Tài khoản người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ để được hỗ trợ.';
      case 'user-not-found':
        return 'Thông tin đăng nhập không hợp lệ. Người dùng không được tìm thấy.';
      case 'wrong-password':
        return 'Mật khẩu không đúng. Vui lòng kiểm tra mật khẩu và thử lại.';
      case 'invalid-verification-code':
        return 'Mã xác nhận không hợp lệ. Vui lòng nhập một mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác nhận không hợp lệ. Vui lòng yêu cầu một mã xác nhận mới.';
      case 'quota-exceeded':
        return 'Hạn ngạch đã vượt quá. Vui lòng thử lại sau.';
      case 'email-already-exists':
        return 'Địa chỉ email đã tồn tại. Vui lòng sử dụng một địa chỉ email khác.';
      case 'provider-already-linked':
        return 'Tài khoản đã được liên kết với một nhà cung cấp khác.';
      case 'requires-recent-login':
        return 'Thao tác này đòi hỏi xác thực gần đây và yêu cầu đăng nhập lại. Vui lòng đăng nhập lại.';
      case 'credential-already-in-use':
        return 'Chứng chỉ này đã được liên kết với một tài khoản người dùng khác.';
      case 'user-mismatch':
        return 'Thông tin đăng nhập không phù hợp với người dùng đã đăng nhập trước đó.';
      case 'account-exists-with-different-credential':
        return 'Một tài khoản đã tồn tại với cùng một email nhưng với thông tin đăng nhập khác nhau.';
      case 'operation-not-allowed':
        return 'Thao tác này không được phép. Liên hệ với hỗ trợ để được hỗ trợ.';
      case 'expired-action-code':
        return 'Mã hoạt động đã hết hạn. Vui lòng yêu cầu một mã hoạt động mới.';
      case 'invalid-action-code':
        return 'Mã hoạt động không hợp lệ. Vui lòng kiểm tra mã và thử lại.';
      case 'missing-action-code':
        return 'Mã hoạt động bị thiếu. Vui lòng cung cấp một mã hoạt động hợp lệ.';
      case 'user-token-expired':
        return 'Token người dùng đã hết hạn, yêu cầu xác thực lại. Vui lòng đăng nhập lại.';
      case 'invalid-credential':
        return 'Chứng chỉ cung cấp không đúng cách hoặc đã hết hạn.';
      case 'user-token-revoked':
        return 'Token người dùng đã bị thu hồi. Vui lòng đăng nhập lại.';
      case 'invalid-message-payload':
        return 'Dữ liệu xác nhận mẫu email không hợp lệ.';
      case 'invalid-sender':
        return 'Người gửi mẫu email không hợp lệ. Vui lòng xác minh địa chỉ email của người gửi.';
      case 'invalid-recipient-email':
        return 'Địa chỉ email người nhận không hợp lệ. Vui lòng cung cấp một địa chỉ email người nhận hợp lệ.';
      case 'missing-iframe-start':
        return 'Mẫu email thiếu thẻ bắt đầu iframe.';
      case 'missing-iframe-end':
        return 'Mẫu email thiếu thẻ kết thúc iframe.';
      case 'missing-iframe-src':
        return 'Mẫu email thiếu thuộc tính src của iframe.';
      case 'auth-domain-config-required':
        return 'Cấu hình authDomain là bắt buộc cho liên kết mã hành động kiểm tra liên kết.';
      case 'missing-app-credential':
        return 'Chứng chỉ ứng dụng bị thiếu. Vui lòng cung cấp chứng chỉ ứng dụng hợp lệ.';
      case 'invalid-app-credential':
        return 'Chứng chỉ ứng dụng không hợp lệ. Vui lòng cung cấp một chứng chỉ ứng dụng hợp lệ.';
      case 'session-cookie-expired':
        return 'Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.';
      case 'uid-already-exists':
        return 'ID người dùng đã được sử dụng bởi người dùng khác.';
      case 'invalid-cordova-configuration':
        return 'Cấu hình Cordova cung cấp không hợp lệ.';
      case 'app-deleted':
        return 'Phiên bản này của FirebaseApp đã bị xóa.';
      case 'user-token-mismatch':
        return 'Token người dùng cung cấp không phù hợp với ID người dùng đã xác thực.';
      case 'web-storage-unsupported':
        return 'Web storage không được hỗ trợ hoặc đã bị tắt.';
      case 'app-not-authorized':
        return 'Ứng dụng không được ủy quyền để sử dụng Xác thực Firebase với khóa API được cung cấp.';
      case 'keychain-error':
        return 'Đã xảy ra lỗi keychain. Vui lòng kiểm tra keychain và thử lại.';
      case 'internal-error':
        return 'Đã xảy ra lỗi xác thực nội bộ. Vui lòng thử lại sau.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Thông tin đăng nhập không hợp lệ.';
      default:
        return 'Đã xảy ra một lỗi xác thực không mong muốn. Vui lòng thử lại.';
    }
  }
}
