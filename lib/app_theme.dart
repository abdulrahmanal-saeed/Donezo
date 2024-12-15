import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Light Theme
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color backgroundLight = Color(0xFFDFECDB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF363636);
  static const Color green = Color(0xFF61E757);
  static const Color red = Color(0xFFEC4B4B);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryLight,
    scaffoldBackgroundColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: white,
      selectedItemColor: primaryLight,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(color: white, width: 4.r), // استخدام ScreenUtil هنا
      ),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.black),
      titleSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.grey),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 13.sp, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(white),
    ),
  );

  // Dark Theme
  static const Color primaryDark = Color(0xFF6C63FF);
  static const Color backgroundDark = Color(0xFF141922);
  static const Color bottomNav = Color(0xFF141922);
  static const Color unselectedItemColor = Color(0xFFC8C9CB);
  static const Color darkDropDown = Color(0xFF060E1E);

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: bottomNav,
      selectedItemColor: primaryDark,
      unselectedItemColor: unselectedItemColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(color: const Color(0xFF141922), width: 4.r),
      ),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.black),
      titleSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 13.sp, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(white),
    ),
  );
}
