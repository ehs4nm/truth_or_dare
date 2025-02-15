import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle semiBold13 = _customFontWith(TextStyle(fontSize: 13, fontWeight: FontWeight.w200, color: Colors.white));
  static TextStyle semiBold14 = _customFontWith(TextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: Colors.white));
  static TextStyle semiBold14black = _customFontWith(TextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: Colors.black));
  static TextStyle semiBold17 = _customFontWith(TextStyle(fontSize: 17, fontWeight: FontWeight.w200, color: Colors.white));
  static TextStyle semiBold17black = _customFontWith(TextStyle(fontSize: 17, fontWeight: FontWeight.w200, color: Colors.black));
  static TextStyle semiBold30 = _customFontWith(TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white));
  static TextStyle semiBold20 = _customFontWith(TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white));
  static TextStyle semiBold22 = _customFontWith(TextStyle(fontSize: 22, fontWeight: FontWeight.w200, color: Colors.white));
  static TextStyle extraBold24 = _customFontWith(TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white));
  static TextStyle extraBold28 = _customFontWith(TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white));
  static TextStyle extraBold30 = _customFontWith(TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white));
  static TextStyle extraBold32 = _customFontWith(TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white));

  static TextStyle extraBold32black = _customFontWith(TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black));
  static TextStyle extraBold48 = _customFontWith(TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white));
  static TextStyle extraBold78 = _customFontWith(TextStyle(fontSize: 78, fontWeight: FontWeight.w800, color: Colors.white));
  static TextStyle extraBlackBold24 = _customFontWith(TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black));
}

TextStyle _customFontWith(TextStyle textStyle) {
  return GoogleFonts.lalezar(textStyle: textStyle);
}
