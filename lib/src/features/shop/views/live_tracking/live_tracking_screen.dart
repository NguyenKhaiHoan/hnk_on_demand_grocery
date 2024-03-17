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
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class LiveTrackingScreen extends StatefulWidget {
  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(20.980724334716797, 105.7970962524414),
    zoom: 14,
  );
  Completer<GoogleMapController> googleMapController = Completer();
  GoogleMapController? mapController;

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
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            googleMapController.complete(controller);
            mapController = controller;
            Position crrPositon =
                await HLocationService.getGeoLocationPosition();
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
    );
  }
}
