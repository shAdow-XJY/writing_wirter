import 'package:flutter/material.dart';

final ThemeData blueTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  primaryColor: Colors.blueGrey[600],
  dialogBackgroundColor: Colors.blueGrey[100],
  scaffoldBackgroundColor: Colors.blueGrey[100],
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey[600],
    toolbarTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.black),
      backgroundColor: MaterialStateProperty.all(Colors.blueGrey[600]),
      overlayColor: MaterialStateProperty.all(Colors.blueGrey[700]),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
    ),
    hintStyle: TextStyle(
      color: Colors.grey[400],
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 2,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blueGrey,
        width: 2,
      ),
    ),
  ),
);
