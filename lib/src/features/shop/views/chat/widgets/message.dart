// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:image_network/image_network.dart';

// import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
// import 'package:on_demand_grocery/src/constants/app_colors.dart';
// import 'package:on_demand_grocery/src/constants/app_sizes.dart';
// import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
// import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
// import 'package:on_demand_grocery/src/utils/utils.dart';

// class MessageProduct extends StatelessWidget {
//   const MessageProduct({
//     super.key,
//     required this.model,
//   });

//   final ProductModel model;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.only(bottom: hAppDefaultPadding),
//         padding: const EdgeInsets.symmetric(vertical: hAppDefaultPadding / 2),
//         child: Row(
//           children: <Widget>[
//             Stack(
//               children: [
//                 ImageNetwork(
//                   image: model.image,
//                   height: 80,
//                   width: 80,
//                   duration: 500,
//                   curve: Curves.easeIn,
//                   onPointer: true,
//                   debugPrint: false,
//                   fullScreen: false,
//                   fitAndroidIos: BoxFit.cover,
//                   fitWeb: BoxFitWeb.cover,
//                   borderRadius: BorderRadius.circular(10),
//                   onLoading:
//                       CustomShimmerWidget.rectangular(width: 80, height: 80),
//                   onError: const Icon(
//                     Icons.error,
//                     color: Colors.red,
//                   ),
//                 ),
//                 model.salePersent != 0
//                     ? Positioned(
//                         bottom: 5,
//                         left: 5,
//                         child: Container(
//                           padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: HAppColor.hOrangeColor),
//                           child: Text('${model.salePersent}%',
//                               style: HAppStyle.label4Bold
//                                   .copyWith(color: HAppColor.hWhiteColor)),
//                         ),
//                       )
//                     : Container()
//               ],
//             ),
//             gapW10,
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Expanded(
//                           child: Text(
//                         model.name,
//                         maxLines: 2,
//                         style: HAppStyle.label2Bold,
//                       )),
//                     ],
//                   ),
//                   gapH4,
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(
//                             EvaIcons.star,
//                             color: HAppColor.hOrangeColor,
//                             size: 16,
//                           ),
//                           gapW2,
//                           Text.rich(
//                             TextSpan(
//                               style: HAppStyle.paragraph2Bold,
//                               text: "4.3",
//                               children: [
//                                 TextSpan(
//                                   text: '/5',
//                                   style: HAppStyle.paragraph3Regular.copyWith(
//                                       color: HAppColor.hGreyColorShade600),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       gapW10,
//                       Text.rich(
//                         TextSpan(
//                           style: HAppStyle.paragraph2Bold,
//                           text: '${model.countBuyed} ',
//                           children: [
//                             TextSpan(
//                               text: 'Đã bán',
//                               style: HAppStyle.paragraph3Regular.copyWith(
//                                   color: HAppColor.hGreyColorShade600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   gapH4,
//                   model.salePersent == 0
//                       ? Text(
//                           HAppUtils.vietNamCurrencyFormatting(model.price),
//                           style: HAppStyle.label2Bold
//                               .copyWith(color: HAppColor.hBluePrimaryColor),
//                         )
//                       : Text.rich(
//                           TextSpan(
//                             style: HAppStyle.label2Bold.copyWith(
//                                 color: HAppColor.hOrangeColor,
//                                 decoration: TextDecoration.none),
//                             text:
//                                 '${HAppUtils.vietNamCurrencyFormatting(model.priceSale)} ',
//                             children: [
//                               TextSpan(
//                                 text: HAppUtils.vietNamCurrencyFormatting(
//                                     model.price),
//                                 style: HAppStyle.label4Regular.copyWith(
//                                     color: HAppColor.hGreyColor,
//                                     decoration: TextDecoration.lineThrough),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
// }
