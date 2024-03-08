import 'dart:async';
import 'dart:math';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class LiveTrackingScreen extends StatefulWidget {
  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  Completer<GoogleMapController> googleMapController = Completer();
  GoogleMapController? mapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(25, 155),
    zoom: 14,
  );

  // final List<Marker> _marker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          // markers: Set<Marker>.of(_marker),
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            googleMapController.complete(controller);
            mapController = controller;
            Position crrPositon = await getCurretnLocation();
            LatLng crrLatLng = LatLng(
              crrPositon.latitude,
              crrPositon.longitude,
            );
            CameraPosition cameraPosition = CameraPosition(
              target: crrLatLng,
              zoom: 14,
            );
            mapController!
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          },
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: getCurrentPosition,
      //   label: const Text('Vị trí hiện tại'),
      //   icon: const Icon(Icons.my_location),
      // ),
    );
  }

  getCurretnLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getCurretnLocation();
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    log(currentPosition.toString() as num);
    return currentPosition;
  }
}
