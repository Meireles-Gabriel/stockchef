import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light().copyWith(
    surface: const Color.fromARGB(255, 238, 239, 245),
  ),
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
    bodyColor: const Color.fromARGB(255, 19, 19, 19),
    displayColor: const Color.fromARGB(255, 19, 19, 19),
  ),
);
ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark().copyWith(
    surface: const Color.fromARGB(255, 19, 19, 19),
  ),
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
    bodyColor: const Color.fromARGB(255, 238, 239, 245),
    displayColor: const Color.fromARGB(255, 238, 239, 245),
  ),
);
