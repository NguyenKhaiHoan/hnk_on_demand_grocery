import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();
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
      HAppUtils.showLostMobileDataConnection('Mất kết nối dữ liệu',
          'Hãy kiểm tra kết nối Wifi hoặc dữ liệu di động để tiếp tục truy cập ứng dụng.');
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      // if (connectivityResult == ConnectivityResult.wifi) {
      //   HAppUtils.showConnectedToMobileData('Đã kết nối qua Wifi',
      //       'Giờ đây, bạn có thể tiếp tục truy cập đầy đủ và trải nghiệm ứng dụng.');
      // } else if (connectivityResult == ConnectivityResult.mobile) {
      //   HAppUtils.showConnectedToMobileData('Đã kết nối qua dữ liệu di động',
      //       'Giờ đây, bạn có thể tiếp tục truy cập đầy đủ và trải nghiệm ứng dụng.');
      // }
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
