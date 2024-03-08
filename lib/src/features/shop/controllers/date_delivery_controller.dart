import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateDeliveryController extends GetxController {
  static DateDeliveryController get instance => Get.find();

  var currentDateSelectedIndex = 0.obs;
  var selectedDate = DateTime.now().add(const Duration(days: 0)).obs;
  var date =
      DateFormat('EEEE, d-M-y', 'vi').format(DateTime.now()).toString().obs;
}
