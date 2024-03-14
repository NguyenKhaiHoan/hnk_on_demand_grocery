import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class HLocationService {
  static Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      showSnackBarError('Lỗi', 'Dịch vụ định vị bị vô hiệu hóa.');
      return Future.error('Dịch vụ định vị bị vô hiệu hóa.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBarError('Lỗi', 'Quyền truy cập vị trí bị từ chối.');
        return Future.error('Quyền truy cập vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBarError('Lỗi',
          'Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền.');
      return Future.error(
          'Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<List<String>> getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      return [
        place.street ?? '',
        place.subAdministrativeArea ?? '',
        place.administrativeArea ?? ''
      ];
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  static void showSnackBarError(String s, String t) {}
}
