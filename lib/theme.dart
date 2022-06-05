import 'package:flutter/material.dart';

const primaryColor = Colors.indigo;
const primaryColorDark = Colors.indigoAccent;

/*
PRIMARY:            AppBar, Buttons, Switches
TERTIARY:           Replacement for CardColor

HEADLINE LARGE:     App Title (LoginScreen)
HEADLINE MEDIUM:    Header (LoginScreen)
TITLE MEDIUM:       Leading Text (TeacherItem)
LABEL SMALL:        Label (EditContainer), Datetime (BroadcastTile)
BODY MEDIUM:        Header (SchoolLifeItemTile, BroadcastTile), Content (TeacherTile), Child (EditContainer)
BODY SMALL:         Content (SchoolLifeItemTile, BroadcastTile)
*/

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Montserrat",
    scaffoldBackgroundColor: const Color(0xffefeff4),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      tertiary: Colors.white,
      onTertiary: Colors.grey.shade200,
    ),
    dividerColor: Colors.grey,
    indicatorColor: Colors.white,
    toggleableActiveColor: primaryColor,
    appBarTheme: const AppBarTheme(
      elevation: 1,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 25, fontFamily: "Montserrat"),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        shape: MaterialStateProperty.resolveWith(
          (_) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: const TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontFamily: "LobsterTwo",
      ),
      headlineMedium: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 24,
        letterSpacing: 1,
      ),
      labelSmall: const TextStyle(
        fontSize: 15,
        color: Colors.grey,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: const TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      bodySmall: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Montserrat",
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: primaryColorDark,
      tertiary: Colors.grey.shade800,
      onTertiary: Colors.grey.shade700,
      onTertiaryContainer: Colors.white,
    ),
    indicatorColor: primaryColorDark,
    dividerColor: Colors.white,
    toggleableActiveColor: primaryColorDark,
    appBarTheme: const AppBarTheme(
      foregroundColor: primaryColorDark,
      elevation: 1,
    ),
    tabBarTheme: const TabBarTheme(labelColor: primaryColorDark),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey.shade800,
      foregroundColor: primaryColorDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(
          fontSize: 25,
          fontFamily: "Montserrat",
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        shape: MaterialStateProperty.resolveWith(
          (_) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      focusColor: primaryColorDark,
    ),
    textTheme: TextTheme(
      headlineLarge: const TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontFamily: "LobsterTwo",
      ),
      headlineMedium: const TextStyle(
        color: primaryColorDark,
        fontWeight: FontWeight.w500,
        fontSize: 24,
        letterSpacing: 1,
      ),
      labelSmall: TextStyle(
        fontSize: 15,
        color: Colors.grey.shade300,
        letterSpacing: 0,
      ),
      titleMedium: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      bodySmall: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    ),
  );
}
