import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HAppSize {
  static const p2 = 2.0;
  static const p4 = 4.0;
  static const p6 = 6.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p40 = 40.0;
  static const p100 = 100.0;
  static const p200 = 200.0;

  static final deviceWidth = Get.width;
  static final deviceHeight = Get.height;
}

const hAppDefaultPadding = HAppSize.p16;
const hAppDefaultPaddingLR =
    EdgeInsets.fromLTRB(hAppDefaultPadding, 0, hAppDefaultPadding, 0);

const hAppDefaultPaddingL = EdgeInsets.only(left: hAppDefaultPadding);
const hAppDefaultPaddingR = EdgeInsets.only(right: hAppDefaultPadding);

const gapW2 = SizedBox(width: HAppSize.p2);
const gapW4 = SizedBox(width: HAppSize.p4);
const gapW6 = SizedBox(width: HAppSize.p6);
const gapW8 = SizedBox(width: HAppSize.p8);
const gapW10 = SizedBox(width: HAppSize.p10);
const gapW12 = SizedBox(width: HAppSize.p12);
const gapW16 = SizedBox(width: HAppSize.p16);
const gapW20 = SizedBox(width: HAppSize.p20);
const gapW24 = SizedBox(width: HAppSize.p24);
const gapW40 = SizedBox(width: HAppSize.p40);
const gapW100 = SizedBox(width: HAppSize.p100);
const gapW200 = SizedBox(width: HAppSize.p200);

const gapH2 = SizedBox(height: HAppSize.p2);
const gapH4 = SizedBox(height: HAppSize.p4);
const gapH6 = SizedBox(height: HAppSize.p6);
const gapH8 = SizedBox(height: HAppSize.p8);
const gapH10 = SizedBox(height: HAppSize.p10);
const gapH12 = SizedBox(height: HAppSize.p12);
const gapH16 = SizedBox(height: HAppSize.p16);
const gapH20 = SizedBox(height: HAppSize.p20);
const gapH24 = SizedBox(height: HAppSize.p24);
const gapH40 = SizedBox(height: HAppSize.p40);
const gapH100 = SizedBox(height: HAppSize.p100);
const gapH200 = SizedBox(height: HAppSize.p200);
