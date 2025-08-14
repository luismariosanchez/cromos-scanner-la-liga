import 'package:cromos_scanner_laliga/app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF212121),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF212121),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF303030)),
          elevation: WidgetStatePropertyAll<double>(0.0),
          hintStyle: WidgetStatePropertyAll<TextStyle>(
            TextStyle(color: Color(0x9EFFFFFF)),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            TextStyle(color: Colors.white),
          ),
        ),
        searchViewTheme: SearchViewThemeData(
          backgroundColor: Color(0xFF303030),
          headerHintStyle: TextStyle(color: Color(0x9EFFFFFF)),
          headerTextStyle: TextStyle(color: Colors.white)
        ),
        brightness: Brightness.dark, // opcional, si quieres base oscura
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        primaryTextTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: HomeScreen(),
      ),
    );
  }
}
