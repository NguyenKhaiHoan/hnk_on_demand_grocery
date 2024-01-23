import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  TextEditingController phoneNumberController = TextEditingController();

  var phoneNumber = "".obs;
  var verificationId = "".obs;
  var smsOtp = "".obs;
}
