import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  var connectivityStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(
      ConnectivityResult connectivityResult) async {
    connectivityStatus.value = connectivityResult;
    if (connectivityStatus.value == ConnectivityResult.none) {
      Get.rawSnackbar(
          titleText: Text(
            'Không có kết nối mạng!',
            style: HAppStyle.label2Bold.copyWith(color: HAppColor.hRedColor),
          ),
          messageText: RichText(
              text: TextSpan(
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                  text: 'Hãy bật lại ',
                  children: [
                TextSpan(
                    text: 'Wifi',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hRedColor)),
                const TextSpan(text: ', hoặc '),
                TextSpan(
                    text: '4G',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hRedColor)),
                const TextSpan(text: ' để tiếp tục. '),
              ])),
          isDismissible: false,
          duration: const Duration(days: 1),
          icon: const Icon(
            EvaIcons.wifiOffOutline,
            color: Colors.white,
            size: 30,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
