import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/initialize_location_controller.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class PickerLocationScreen extends StatefulWidget {
  const PickerLocationScreen({super.key});

  @override
  State<PickerLocationScreen> createState() => _PickerLocationScreenState();
}

class _PickerLocationScreenState extends State<PickerLocationScreen> {
  final Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition? cameraPosition;
  final initializeLocationController = Get.put(InitializeLocationController());

  late LatLng defaultLatLng;
  late LatLng draggedLatlng;
  var draggedAddress = "".obs;

  @override
  void initState() {
    super.initState();
    defaultLatLng = LatLng(initializeLocationController.latitude.value,
        initializeLocationController.longitude.value);
    draggedLatlng = defaultLatLng;
    cameraPosition = CameraPosition(target: defaultLatLng, zoom: 14);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        getMap(),
        customPin(),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 80,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: hAppDefaultPaddingL,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HAppColor.hGreyColorShade300,
                            width: 1.5,
                          ),
                          color: HAppColor.hBackgroundColor),
                      child: const Center(
                        child: Icon(
                          EvaIcons.arrowBackOutline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: showDraggedAddress(),
        ),
      ]),
    ));
  }

  Widget showDraggedAddress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: HAppColor.hBluePrimaryColor,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: const [
                      BoxShadow(
                        color: HAppColor.hGreyColor,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ]),
                child: const Icon(
                  Icons.location_on,
                  color: HAppColor.hWhiteColor,
                ),
              ),
            )
          ],
        ),
        Obx(() => draggedAddress.value.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: hAppDefaultPadding),
                width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: HAppColor.hBackgroundColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                          color: HAppColor.hGreyColor,
                          blurRadius: 10,
                          offset: Offset(0, -5))
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: HAppColor.hBluePrimaryColor),
                        child: const Icon(
                          EvaIcons.pin,
                          color: HAppColor.hWhiteColor,
                          size: 15,
                        ),
                      ),
                      gapW12,
                      Expanded(
                          child: Text(
                        draggedAddress.value.isEmpty
                            ? "Lỗi, không tải được địa chỉ"
                            : draggedAddress.value,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: HAppStyle.paragraph2Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                      ))
                    ]),
              )
            : Container()),
        Container(
          margin: const EdgeInsets.all(hAppDefaultPadding),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: HAppColor.hBluePrimaryColor,
                fixedSize:
                    Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Text("Xác nhận",
                style: HAppStyle.label2Bold
                    .copyWith(color: HAppColor.hWhiteColor)),
          ),
        )
      ],
    );
  }

  // Widget showDraggedAddress() {
  //   return Container(
  //     width: HAppSize.deviceWidth,
  //     padding: hAppDefaultPaddingLR,
  //     decoration: const BoxDecoration(
  //         color: HAppColor.hBackgroundColor,
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //         boxShadow: [
  //           BoxShadow(
  //               color: HAppColor.hGreyColor,
  //               blurRadius: 10,
  //               offset: Offset(0, -5))
  //         ]),
  //     child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           gapH12,
  //           Text(
  //             'Địa chỉ:',
  //             style: HAppStyle.label2Bold
  //                 .copyWith(color: HAppColor.hBluePrimaryColor),
  //           ),
  //           gapH6,
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border.all(
  //                     color: HAppColor.hGreyColorShade300, width: 2)),
  //             child: Row(children: [
  //               const Icon(
  //                 EvaIcons.pin,
  //                 color: HAppColor.hBluePrimaryColor,
  //                 size: 20,
  //               ),
  //               gapW6,
  //               Expanded(
  //                   child: Obx(() => Text(
  //                         draggedAddress.value.isEmpty
  //                             ? "Vui lòng chọn địa chỉ"
  //                             : draggedAddress.value,
  //                         overflow: TextOverflow.ellipsis,
  //                         maxLines: 1,
  //                         style: HAppStyle.paragraph2Regular
  //                             .copyWith(color: HAppColor.hGreyColorShade600),
  //                       )))
  //             ]),
  //           ),
  //           gapH12,
  //           ElevatedButton(
  //             onPressed: () {},
  //             style: ElevatedButton.styleFrom(
  //                 backgroundColor: HAppColor.hBluePrimaryColor,
  //                 fixedSize:
  //                     Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(50))),
  //             child: Text("Tiếp tục",
  //                 style: HAppStyle.label2Bold
  //                     .copyWith(color: HAppColor.hWhiteColor)),
  //           ),
  //           gapH12,
  //         ]),
  //   );
  // }

  Widget getMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
            AddressController.instance.selectedAddress.value.latitude,
            AddressController.instance.selectedAddress.value.longitude),
        zoom: 14,
      ),
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onCameraIdle: () async {
        // HAppUtils.loadingOverlays();
        List<String> listPartOfAddress =
            await HLocationService.getAddressFromLatLng(
                LatLng(draggedLatlng.latitude, draggedLatlng.longitude));
        draggedAddress.value =
            '${listPartOfAddress[0]}, ${listPartOfAddress[1]}, ${listPartOfAddress[2]}, Hà Nội';
        // HAppUtils.stopLoading();
      },
      onCameraMove: (cameraPosition) {
        draggedLatlng = cameraPosition.target;
      },
      onMapCreated: (GoogleMapController controller) {
        if (!googleMapController.isCompleted) {
          googleMapController.complete(controller);
        }
      },
    );
  }

  Widget customPin() {
    return const Center(
      child: Icon(
        EvaIcons.pin,
        color: HAppColor.hBluePrimaryColor,
        size: 20,
      ),
    );
  }
}
