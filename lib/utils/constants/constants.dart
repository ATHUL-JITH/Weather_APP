import 'package:flutter/material.dart';

class Constants {
  static Color appBg = const Color.fromARGB(255, 51, 28, 113);
  static Color cardBg = const Color.fromARGB(255, 88, 66, 169);

  static List<String> icons = [];
  static ThemeData appThemeData = ThemeData(
    
    // dropdownMenuTheme: const DropdownMenuThemeData(
    //     inputDecorationTheme: InputDecorationTheme(),
    //     // menuStyle: MenuStyle(),
    //     textStyle: TextStyle(color: Colors.white)),
    listTileTheme: const ListTileThemeData(textColor: Colors.white),
    scaffoldBackgroundColor: appBg,
    cardTheme: CardTheme(color: cardBg),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    useMaterial3: true,
  );
}
// 