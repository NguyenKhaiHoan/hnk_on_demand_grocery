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
      HAppUtils.showSnackBarError(
          'Mất kết nối', 'Hãy kết nối lại dữ liệu di động');
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
