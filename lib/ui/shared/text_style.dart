import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextStyles {
  static final homePageTitleTextStyle = GoogleFonts.inter(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 6.w);
  static final homePageDescTextStyle =
      GoogleFonts.inter(color: Colors.white, fontSize: 4.w);
  static final homePageButtonsTextStyle =
      GoogleFonts.inter(color: Colors.white, fontSize: 5.w);
  static final homePageButtonsBoldTextStyle = GoogleFonts.inter(
      color: Colors.white, fontSize: 5.w, fontWeight: FontWeight.bold);
}
