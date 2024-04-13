// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:on_demand_grocery/src/constants/app_colors.dart';
// import 'package:on_demand_grocery/src/constants/app_sizes.dart';

// class SelectDeliveryAddressScreen extends StatefulWidget {
//   const SelectDeliveryAddressScreen({super.key});

//   @override
//   State<SelectDeliveryAddressScreen> createState() =>
//       _SelectDeliveryAddressScreenState();
// }

// class _SelectDeliveryAddressScreenState
//     extends State<SelectDeliveryAddressScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: HAppColor.hBackgroundColor,
//         toolbarHeight: 80,
//         leading: Padding(
//           padding: hAppDefaultPaddingL,
//           child: GestureDetector(
//             onTap: () {
//               Get.back();
//             },
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: HAppColor.hGreyColorShade300,
//                     width: 1.5,
//                   ),
//                   color: HAppColor.hBackgroundColor),
//               child: const Center(
//                 child: Icon(
//                   EvaIcons.arrowBackOutline,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
