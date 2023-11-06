/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {

  static Color text_background = Color(0xFFEAEAFF);
  static Color bold_text_color = Color(0xFF2E3456);
  static Color secondary = Color(0xFF094268);
  static Color buttonborderColors = Color(0xFF4E6AFF);
  // static Color primary = Color(0xFF6161FF);
  static Color primary = Color(0xFF039EA2);
  static const appColor = Color.fromARGB(229, 52, 1, 255);
  static const secondaryAppColor = Color.fromARGB(255, 35, 74, 214);
  static const whiteColor = Colors.white;
  static const blackColor = Color(0xFF000000);
  static const lightBlack = Color(0xFF454545);
  static const greyColor = Color(0xFF6A707C);
  static const backgroundColor = Color(0xFFF3F3F3);
  static const orangeColor = Color(0xFFFF9900);
  static const greenColor = Color(0xFF32CD32);
  static const persianGreen = Color(0xFF039EA2);
  static const borderColor = Color(0xFFE8ECF4);
  static const textColor = Color(0xFF8391A1);
  static const buttonGrey = Color(0xFF808080);
  static const blue = Color(0xFF1877F2);
  static const iceberg = Color(0xFFD9F1F1);
  static const bright_gray = Color(0xFFEDEDED);
  static const light_white = Color(0xFFFFFFF7);
  static Color buttonColors = Color(0xFF039EA2);
  static Color redColor = Color(0xFFF14336);
  static Color alphabatic_gray = Color(0xFF797979);
  static const transparent = Color.fromARGB(0, 0, 0, 0);




  static const titleStyle = TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontSize: 14),
  displayLarge: typeTheme.bodyLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontSize: 28),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontSize: 18),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontSize: 21),
);

ThemeData light = ThemeData(fontFamily: 'regular', primaryColor: ThemeProvider.appColor, secondaryHeaderColor: ThemeProvider.secondaryAppColor, disabledColor: const Color(0xFFBABFC4), brightness: Brightness.light, hintColor: const Color(0xFF9F9F9F), cardColor: ThemeProvider.appColor, textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)), textTheme: txtTheme, colorScheme: const ColorScheme.light(primary: ThemeProvider.appColor, secondary: ThemeProvider.secondaryAppColor).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)));

ThemeData dark = ThemeData(fontFamily: 'regular', primaryColor: ThemeProvider.blackColor, secondaryHeaderColor: const Color(0xFF009f67), disabledColor: const Color(0xffa2a7ad), brightness: Brightness.dark, hintColor: const Color(0xFFbebebe), cardColor: Colors.black, textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.blackColor)), textTheme: txtTheme, colorScheme: const ColorScheme.dark(primary: ThemeProvider.blackColor, secondary: Color(0xFFffbd5c)).copyWith(background: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)));
