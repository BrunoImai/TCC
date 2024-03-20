import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';

class ThemeText{

  ThemeText._();

  static TextTheme lightTextTheme = TextTheme(
    headline1: GoogleFonts.montserrat(fontSize : 28.0, fontWeight: FontWeight.bold, color: darkColor),
    headline2: GoogleFonts.montserrat(fontSize : 24.0, fontWeight: FontWeight.w700, color: darkColor),
    headline3: GoogleFonts.poppins(fontSize : 24.0, fontWeight: FontWeight.w700, color: darkColor),
    headline4: GoogleFonts.poppins(fontSize : 16.0, fontWeight: FontWeight.w600, color: darkColor),
    headline6: GoogleFonts.poppins(fontSize : 14.0, fontWeight: FontWeight.w600, color: darkColor),
    bodyText1: GoogleFonts.poppins(fontSize : 14.0, fontWeight: FontWeight.normal, color: darkColor),
    bodyText2: GoogleFonts.poppins(fontSize : 14.0, fontWeight: FontWeight.normal, color: darkColor),
  );

  static TextTheme darkTextTheme = TextTheme(
    headline1: GoogleFonts.montserrat(fontSize : 28.0, fontWeight: FontWeight.bold, color: whiteColor),
    headline2: GoogleFonts.montserrat(fontSize : 24.0, fontWeight: FontWeight.w700, color: whiteColor),
    headline3: GoogleFonts.poppins(fontSize : 24.0, fontWeight: FontWeight.w700, color: whiteColor),
    headline4: GoogleFonts.poppins(fontSize : 16.0, fontWeight: FontWeight.w600, color: whiteColor),
    headline6: GoogleFonts.poppins(fontSize : 14.0, fontWeight: FontWeight.w600, color: whiteColor),
    bodyText1: GoogleFonts.poppins(fontSize : 14.0, fontWeight: FontWeight.normal, color: whiteColor),
    bodyText2: GoogleFonts.poppins(fontSize : 14.0, fontWeight: FontWeight.normal, color: whiteColor),
  );
}