import 'package:Fe_mobile/config/ui_icons.dart';
import 'package:flutter/material.dart';

class EstiloUtil {
  static const Color COLOR_PRIMARY = Color(0xFF0BB2E3);
  static const Color COLOR_SECUNDARY = Color(0xFF0BB2E3);
  static const Color COLOR_WARNING = Color(0xFFECB602);
  static const Color COLOR_SUCCESS = Color(0xFF44C174);
  static const Color COLOR_SUCCESS_CLEAR = Color(0xFF6FE89E);
  static const Color COLOR_SUCCESS_DARK = Color(0xFF1D8044);
  static const Color COLOR_INFO = Color(0xFFFFFFFF);
  static const Color COLOR_INFO_2 = Color(0xFF5089D9);
  static const Color COLOR_ERROR = Color(0xFFE1000E);
  static const Color COLOR_DARK = Color(0xFF014E65);
  static const Color COLOR_CLEAR = Color(0xFFFDFAFF);
  static const Color COLOR_CLEAR_2 = Color(0xFFC2F1FF);
  static const Color COLOR_CLEAR_3 = Color(0xFFD99EFF);
  static const Color COLOR_CLEAR_4 = Color(0xFFEACAFF);
  static const Color COLOR_CLEAR_5 = Color(0xFF73C4F0);

  static const Color COLOR_1 = Color(0xFFF9FDFE);
  static const Color COLOR_2 = Color(0xFF0077B6);
  static const Color COLOR_3 = Color(0xFFE4F9FF);

  static InputDecoration crearInputDecorationFormCustom(String labelText,
          {String hintText,
          String helperText,
          String counterText,
          IconButton suffixIcon,
          Icon icon}) =>
      InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: icon,
          helperText: helperText,
          counterText: counterText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.pinkAccent),
          ));
}
