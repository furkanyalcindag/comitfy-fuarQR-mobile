import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: white,
      iconTheme: const IconThemeData(color: black),
      primaryColor: white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: white,
        primaryContainer: white,
        secondaryContainer: whiteSecondary,
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(primary),
          foregroundColor: MaterialStatePropertyAll(whiteSecondary),
          textStyle:
              MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),

      /// Generator: https://m2.material.io/design/typography/the-type-system.html#type-scale
      textTheme: TextTheme(
        headline1: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 99,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5),
        headline2: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 62,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5),
        headline3: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 49,
            fontWeight: FontWeight.w400),
        headline4: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 35,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25),
        headline5: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 25,
            fontWeight: FontWeight.w400),
        headline6: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 21,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15),
        subtitle1: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15),
        subtitle2: GoogleFonts.varelaRound(
            color: lightThemeTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1),
        bodyText1: GoogleFonts.openSans(
            color: lightThemeTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5),
        bodyText2: GoogleFonts.openSans(
            color: lightThemeTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25),
        button: GoogleFonts.openSans(
            color: lightThemeTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25),
        caption: GoogleFonts.openSans(
            color: lightThemeTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4),
        overline: GoogleFonts.openSans(
            color: lightThemeTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5),
      ));

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: black,
      primaryContainer: black,
      secondaryContainer: blackSecondary,
    ),
    scaffoldBackgroundColor: black,
    iconTheme: const IconThemeData(color: white),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(blackSecondary),
        foregroundColor: MaterialStatePropertyAll(primary),
        textStyle:
            MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)),
      ),
    ),
    textTheme: TextTheme(
      headline1: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 99,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5),
      headline2: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 62,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5),
      headline3: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 49,
          fontWeight: FontWeight.w400),
      headline4: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 35,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25),
      headline5: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 25,
          fontWeight: FontWeight.w400),
      headline6: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 21,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15),
      subtitle1: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15),
      subtitle2: GoogleFonts.varelaRound(
          color: blackThemeTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1),
      bodyText1: GoogleFonts.openSans(
          color: blackThemeTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5),
      bodyText2: GoogleFonts.openSans(
          color: blackThemeTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25),
      button: GoogleFonts.openSans(
          color: blackThemeTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25),
      caption: GoogleFonts.openSans(
          color: blackThemeTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4),
      overline: GoogleFonts.openSans(
          color: blackThemeTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5),
    ),
  );
}
