import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapController extends GetxController {
  static MapController get instance => Get.find();

  var currentPosition = Position(
          longitude: 0.0,
          latitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0)
      .obs;

  updateRealtimeCurrentPositon(Position crrPosition) {
    currentPosition.value = crrPosition;
  }
}
