import 'package:flutter/material.dart';

class Palette {
  static const Color primary = Color(0xff8c83f5);
  static const Color secondary = Color(0xff99ff8e);
  static const Color background = Color(0xff1c1e1f);
  static const Color surface = Color(0xff252728);
  static const Color white = Color(0xffffffff);

  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: background,
    cardColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      iconTheme: IconThemeData(
        color: white,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: surface,
    ),
    primaryColor: primary,
  );
}
