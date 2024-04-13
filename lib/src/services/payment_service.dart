import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:on_demand_grocery/src/constants/app_keys.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class HPaymentService {
  static Map<String, dynamic>? paymentIntent;

  static Future<bool> makePayment(int price) async {
    bool status = false;
    try {
      paymentIntent = await createPaymentIntent(price);
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "VND", testEnv: true);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.light,
        merchantDisplayName: 'GroFast',
        googlePay: gpay,
      ));

      status = await displayPaymentSheet(status);
    } catch (e) {
      print(e.toString());
      HAppUtils.showSnackBarError("Lỗi", "Lỗi khi thực hiện thanh toán: $e");
    }
    return status;
  }

  static Future<Map<String, dynamic>> createPaymentIntent(int price) async {
    try {
      Map<String, dynamic> body = {
        "amount": price.toString(),
        "currency": "VND",
      };

      http.Response response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorization": "Bearer ${HAppKey.stripeSecretKey}",
            "Content-Type": "application/x-www-form-urlencoded"
          });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        HAppUtils.showSnackBarError("Lỗi", "Không thể tạo thanh toán");
        throw 'Không thể tạo thanh toán';
      }
    } catch (e) {
      print(e.toString());
      HAppUtils.showSnackBarError("Lỗi", "Lỗi khi tạo thanh toán: $e");
      rethrow;
    }
  }

  static Future<bool> displayPaymentSheet(bool status) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      status = true;
    } catch (e) {
      status = false;
      HAppUtils.showSnackBarError(
          "Lỗi", "Không thể mở trang tính thanh toán: $e");
    }
    return status;
  }
}
