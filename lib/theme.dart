import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


abstract class AppColors {
  //Colors.purple
  static const primary =  Color(0xff10232a);
  static const accent = Color(0xFFfcab88);
  static const textDark = Color(0xFF000000);
  static const textGrey = Color(0xFF242424);
  static const Color lytBrown = Color(0xffb58863);
  static const Color paraColor = Color(0xffd3c3b9);
  static const Color signColor = Color(0xffa79e9c);
  static const Color rifleBlue = Color(0xFF10232a);
  static const Color lytBlue = Color(0xff3d4d55);
  static const Color darkBrown = Color(0xff161616);
  static const Color buttonBackgroundColor = Color(0xFFf7f6f4);
}

abstract class _LightColors {
  static const background = Color(0xFFffffff);
  static const secondaryBackground = Color.fromARGB(255, 255, 255, 255);
}

abstract class _DarkColors {
  static const background = Color(0xFF1B1E1F);
}

/// Reference to the application theme.
class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  final darkBase = ThemeData.dark();
  final lightBase = ThemeData.light();

  /// Light theme and its settings.
  ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primary,
    textTheme: TextTheme(
      labelLarge: GoogleFonts.montserrat(
        color: AppColors.textGrey,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
      labelMedium: GoogleFonts.montserrat(
        color: AppColors.textGrey,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
      ),
      labelSmall: GoogleFonts.montserrat(
          color: AppColors.textGrey,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
          height: 1.2
      ),
      titleLarge: GoogleFonts.montserrat(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
      titleMedium: GoogleFonts.montserrat(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
      ),
      titleSmall: GoogleFonts.montserrat(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
          height: 1.2
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    //scaffoldBackgroundColor: _LightColors.background,
    /*bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _LightColors.background
    )*/
  );

  /// Dark theme and its settings.
  ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,

  );
}
