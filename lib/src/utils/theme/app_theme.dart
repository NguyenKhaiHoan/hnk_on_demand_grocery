import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class HAppTheme {
  final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: HAppColor.hBackgroundColor,
    primaryColor: HAppColor.hBluePrimaryColor,
    splashColor: HAppColor.hTransparentColor,
    appBarTheme: const AppBarTheme(
        elevation: 0,
        surfaceTintColor: HAppColor.hTransparentColor,
        backgroundColor: HAppColor.hBackgroundColor,
        titleTextStyle: HAppStyle.heading4Style),
    textTheme: const TextTheme(
      headlineLarge: HAppStyle.heading1Style,
      headlineMedium: HAppStyle.heading2Style,
      headlineSmall: HAppStyle.heading3Style,
      displayLarge: HAppStyle.heading4Style,
      displayMedium: HAppStyle.heading5Style,
      displaySmall: HAppStyle.paragraph1Bold,
      titleLarge: HAppStyle.paragraph2Bold,
      titleMedium: HAppStyle.paragraph3Bold,
      titleSmall: HAppStyle.label1Bold,
      bodyLarge: HAppStyle.label2Bold,
      bodyMedium: HAppStyle.label3Bold,
      bodySmall: HAppStyle.label4Bold,
    ),
  );
}
