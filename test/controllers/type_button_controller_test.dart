import 'package:get/get.dart';

class TypeButtonControllerTest extends GetxController {
  static TypeButtonControllerTest get instance => Get.find();

  final _orderType = ''.obs;
  final _paymentMethodType = ''.obs;
  final _timeType = ''.obs;

  String get orderType => _orderType.value;
  String get paymentMethodType => _paymentMethodType.value;
  String get timeType => _timeType.value;

  void setType(String type, bool isOrder) {
    if (isOrder) {
      _orderType.value = type;
    } else {
      _paymentMethodType.value = type;
    }
  }

  void setTimeType(
    String type,
  ) {
    _timeType.value = type;
  }

  void resetType(bool isOrder) {
    _orderType.value = '';
    _paymentMethodType.value = '';
    _timeType.value = '';
  }
}
