import 'package:flutter/material.dart';
import 'package:todofront/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 103, 0, 0),
);
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 60, 0),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      darkTheme: ThemeData.dark().copyWith(
        
        textTheme: GoogleFonts.montserratTextTheme(),
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(
              255, 20, 20, 20), // Set the background color of the app bar
          foregroundColor: Colors.white,

          // Set the color of the content within the app bar (e.g., icons, text)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(kDarkColorScheme.onSecondary),
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(
              255, 236, 240, 250), // Set the background color of the app bar
          foregroundColor: Colors
              .black, // Set the color of the content within the app bar (e.g., icons, text)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(kColorScheme.primaryContainer),
          ),
        ),
        
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
