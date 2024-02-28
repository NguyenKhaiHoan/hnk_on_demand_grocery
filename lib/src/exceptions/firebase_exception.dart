class HFirebaseException implements Exception {
  final String code;

  HFirebaseException({required this.code});
  String get message {
    switch (code) {
      case 'unknown':
        return 'Đã xảy ra một lỗi Firebase không xác định. Vui lòng thử lại.';
      case 'invalid-custom-token':
        return 'Định dạng token tùy chỉnh không chính xác. Vui lòng kiểm tra token tùy chỉnh của bạn.';
      case 'custom-token-mismatch':
        return 'Token tùy chỉnh tương ứng với một đối tượng khác.';
      case 'user-disabled':
        return 'Tài khoản người dùng đã bị vô hiệu hóa.';
      case 'user-not-found':
        return 'Không tìm thấy người dùng với địa chỉ email hoặc UID đã cho.';
      case 'invalid-email':
        return 'Địa chỉ email cung cấp không hợp lệ. Vui lòng nhập một địa chỉ email hợp lệ.';
      case 'email-already-in-use':
        return 'Địa chỉ email đã được đăng ký. Vui lòng sử dụng một địa chỉ email khác.';
      case 'wrong-password':
        return 'Mật khẩu không đúng. Vui lòng kiểm tra mật khẩu và thử lại.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn một mật khẩu mạnh hơn.';
      case 'provider-already-linked':
        return 'Tài khoản đã được liên kết với một nhà cung cấp khác.';
      case 'operation-not-allowed':
        return 'Thao tác này không được phép. Liên hệ với hỗ trợ để được hỗ trợ.';
      case 'invalid-credential':
        return 'Chứng chỉ cung cấp bị lỗi hoặc đã hết hạn.';
      case 'invalid-verification-code':
        return 'Mã xác nhận không hợp lệ. Vui lòng nhập một mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác nhận không hợp lệ. Vui lòng yêu cầu một mã xác nhận mới.';
      case 'captcha-check-failed':
        return 'Phản hồi reCAPTCHA không hợp lệ. Vui lòng thử lại.';
      case 'app-not-authorized':
        return 'Ứng dụng không được ủy quyền để sử dụng Xác thực Firebase với khóa API được cung cấp.';
      case 'keychain-error':
        return 'Đã xảy ra lỗi keychain. Vui lòng kiểm tra keychain và thử lại.';
      case 'internal-error':
        return 'Đã xảy ra lỗi xác thực nội bộ. Vui lòng thử lại sau.';
      case 'invalid-app-credential':
        return 'Chứng chỉ ứng dụng không hợp lệ. Vui lòng cung cấp một chứng chỉ ứng dụng hợp lệ.';
      case 'user-mismatch':
        return 'Thông tin đăng nhập không phù hợp với người dùng đã đăng nhập trước đó.';
      case 'requires-recent-login':
        return 'Thao tác này đòi hỏi xác thực gần đây và yêu cầu đăng nhập lại. Vui lòng đăng nhập lại.';
      case 'quota-exceeded':
        return 'Hạn ngạch đã vượt quá. Vui lòng thử lại sau.';
      case 'account-exists-with-different-credential':
        return 'Một tài khoản đã tồn tại với cùng một email nhưng với thông tin đăng nhập khác nhau.';
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
      case 'session-cookie-expired':
        return 'Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.';
      case 'uid-already-exists':
        return 'ID người dùng đã được sử dụng bởi người dùng khác.';
      case 'web-storage-unsupported':
        return 'Lưu trữ web không được hỗ trợ hoặc đã bị tắt.';
      case 'app-deleted':
        return 'Phiên bản này của FirebaseApp đã bị xóa.';
      case 'user-token-mismatch':
        return 'Token người dùng cung cấp không phù hợp với ID người dùng đã xác thực.';
      case 'invalid-message-payload':
        return 'Dữ liệu xác nhận mẫu email không hợp lệ.';
      case 'invalid-sender':
        return 'Người gửi mẫu email không hợp lệ. Vui lòng xác minh địa chỉ email của người gửi.';
      case 'invalid-recipient-email':
        return 'Địa chỉ email người nhận không hợp lệ. Vui lòng cung cấp một địa chỉ email người nhận hợp lệ.';
      case 'missing-action-code':
        return 'Mã hành động bị thiếu. Vui lòng cung cấp một mã hành động hợp lệ.';
      case 'user-token-expired':
        return 'Token người dùng đã hết hạn, yêu cầu xác thực lại. Vui lòng đăng nhập lại.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Thông tin đăng nhập không hợp lệ.';
      case 'expired-action-code':
        return 'Mã hành động đã hết hạn. Vui lòng yêu cầu một mã hành động mới.';
      case 'invalid-action-code':
        return 'Mã hành động không hợp lệ. Vui lòng kiểm tra mã và thử lại.';
      case 'credential-already-in-use':
        return 'Chứng chỉ này đã được liên kết với một tài khoản người dùng khác.';
      default:
        return 'Đã xảy ra một lỗi Firebase không mong đợi. Vui lòng thử lại.';
    }
  }
}
