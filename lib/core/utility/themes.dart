import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.teal,
      primaryColor: white,
      scaffoldBackgroundColor: white,
      iconTheme: const IconThemeData(color: black),

      /// Generator: https://m2.material.io/design/typography/the-type-system.html#type-scale
      textTheme: TextTheme(
        headline1: GoogleFonts.varelaRound(
            fontSize: 99, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headline2: GoogleFonts.varelaRound(
            fontSize: 62, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        headline3:
            GoogleFonts.varelaRound(fontSize: 49, fontWeight: FontWeight.w400),
        headline4: GoogleFonts.varelaRound(
            fontSize: 35, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        headline5:
            GoogleFonts.varelaRound(fontSize: 25, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.varelaRound(
            fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.varelaRound(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.varelaRound(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: GoogleFonts.openSans(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: GoogleFonts.openSans(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: GoogleFonts.openSans(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.openSans(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.openSans(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ));

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.teal,
    primaryColor: black,
    scaffoldBackgroundColor: black,
    iconTheme: const IconThemeData(color: white),
    textTheme: TextTheme(
      headline1: GoogleFonts.varelaRound(
          fontSize: 99, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      headline2: GoogleFonts.varelaRound(
          fontSize: 62, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      headline3:
          GoogleFonts.varelaRound(fontSize: 49, fontWeight: FontWeight.w400),
      headline4: GoogleFonts.varelaRound(
          fontSize: 35, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headline5:
          GoogleFonts.varelaRound(fontSize: 25, fontWeight: FontWeight.w400),
      headline6: GoogleFonts.varelaRound(
          fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      subtitle1: GoogleFonts.varelaRound(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      subtitle2: GoogleFonts.varelaRound(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyText1: GoogleFonts.openSans(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyText2: GoogleFonts.openSans(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      button: GoogleFonts.openSans(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      caption: GoogleFonts.openSans(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      overline: GoogleFonts.openSans(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
    ),
  );
}
