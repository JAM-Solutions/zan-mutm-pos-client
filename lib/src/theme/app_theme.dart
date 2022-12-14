import 'package:flutter/material.dart';

const Color primaryColor =  Colors.teal;
const Color dangerColor =  Colors.red;

final ThemeData defaultTheme = ThemeData(
  primaryColor: primaryColor,
  secondaryHeaderColor: Colors.tealAccent,
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  ),
  appBarTheme: const AppBarTheme(
    color: primaryColor
  ),
 elevatedButtonTheme: ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
     backgroundColor: primaryColor,
   ),
 ),
  iconTheme: const IconThemeData(
    color: Color.fromARGB(200, 110, 114, 116)
  ),
  inputDecorationTheme: const InputDecorationTheme(
     labelStyle: TextStyle(fontSize: 14),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
      ) ,
      errorBorder:   OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: dangerColor),
      ),
    focusedBorder:OutlineInputBorder(
      borderSide: BorderSide(width: 0.9, color: primaryColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0.9, color: dangerColor),
    )

  ),
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor:  Color.fromARGB(255, 15, 15, 15),
    elevation: 4,
    actionTextColor: Colors.white,
  )
);