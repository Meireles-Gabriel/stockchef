import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color unkWhite = const Color.fromARGB(255, 241, 241, 255);
Color squidInk = const Color.fromARGB(255, 48, 60, 78);
Color queenBlue = const Color.fromARGB(255, 86, 117, 143);
Color unkBlack = const Color.fromARGB(255, 38, 38, 38);

Color darkGunmetal = const Color.fromARGB(255, 24, 29, 44);
Color pastelBlue = const Color.fromARGB(255, 178, 200, 214);
Color airForceBlue = const Color.fromARGB(255, 105, 139, 171);
Color antiFlashWhite = const Color.fromARGB(255, 241, 241, 241);

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light().copyWith(
    surface: unkWhite,
    onSurface: unkBlack,
    primary: squidInk,
    onPrimary: unkWhite,
    secondary: queenBlue,
    onSecondary: unkWhite,
  ),
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
    bodyColor: unkBlack,
    displayColor: unkBlack,
  ),
);
ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark().copyWith(
    surface: darkGunmetal,
    onSurface: antiFlashWhite,
    primary: pastelBlue,
    onPrimary: darkGunmetal,
    secondary: airForceBlue,
    onSecondary: antiFlashWhite,
  ),
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
    bodyColor: antiFlashWhite,
    displayColor: antiFlashWhite,
  ),
);

class MyColors {
  Color statusPastelBlue = const Color.fromARGB(255, 179, 235, 242);
  Color statusPastelYellow = const Color.fromARGB(255, 255, 238, 140);
  Color statusPastelOrange = const Color.fromARGB(255, 255, 192, 103);
  Color statusPastelRed = const Color.fromARGB(255, 255, 116, 108);
}
