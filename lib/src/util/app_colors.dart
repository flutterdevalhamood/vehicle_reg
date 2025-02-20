import 'package:flutter/material.dart';
import 'package:sample/src/theme/light_theme.dart';

abstract class Appcolors {
  static Color bottomSheetBgColor(BuildContext context) =>
      ThemedColor(light: LightTheme.textWhiteColor).getColor(context);
  static Color appBarBgColor(BuildContext context) =>
      ThemedColor(light: LightTheme.lightBlueColor).getColor(context);

  static Color textWhiteColor(BuildContext context) =>
      ThemedColor(light: LightTheme.textWhiteColor).getColor(context);
  static Color textColor(BuildContext context) =>
      ThemedColor(light: LightTheme.textBlackColor).getColor(context);

  static Color textLightGrayColor(BuildContext context) =>
      ThemedColor(light: LightTheme.textLightGrayColor).getColor(context);

  static Color primaryBlue(BuildContext context) =>
      ThemedColor(light: LightTheme.primaryBlueColor).getColor(context);

  static Color secondaryBlue(BuildContext context) =>
      ThemedColor(light: LightTheme.secondaryBlueColor).getColor(context);

  static Color borderColor(BuildContext context) =>
      ThemedColor(light: LightTheme.dividerColor).getColor(context);

  static Color borderLightGreyColor(BuildContext context) =>
      ThemedColor(light: LightTheme.borderLightGreyColor).getColor(context);

  static Color get textDarkBlueColor => const Color(0xFF081B63);

  static Color blackColor = const Color(0xFF212121);

  static Color get btnTextColor => const Color(0xFFFFFFFF);

  static Gradient btnGradient = LinearGradient(
    colors: [LightTheme.primaryBlueColor, LightTheme.secondaryBlueColor],
  );

  static Gradient btnDisableGradient = LinearGradient(
    colors: [LightTheme.secondaryBlueColor, LightTheme.secondaryBlueColor],
  );
}

class ThemedColor {
  final Color light;

  const ThemedColor({required this.light});
  Color getColor(BuildContext context) {
    return light;
  }
}
