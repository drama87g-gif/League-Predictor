import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Brand Colors
  static const Color primary = Color(0xFF1A5F2A);      // Deep football green
  static const Color primaryLight = Color(0xFF2E8B47);
  static const Color primaryDark = Color(0xFF0D3D16);
  static const Color secondary = Color(0xFFF5A623);    // Gold/Amber
  static const Color accent = Color(0xFF00B4D8);       // Cyan
  static const Color error = Color(0xFFE63946);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);

  // Backgrounds
  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A1F2E);
  static const Color darkElevated = Color(0xFF252B3B);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevated = Color(0xFFF1F3F5);

  // Text
  static const Color darkTextPrimary = Color(0xFFE8ECF1);
  static const Color darkTextSecondary = Color(0xFF8B95A5);
  static const Color darkTextTertiary = Color(0xFF5A6578);
  static const Color lightTextPrimary = Color(0xFF1A1F2E);
  static const Color lightTextSecondary = Color(0xFF4A5568);
  static const Color lightTextTertiary = Color(0xFF718096);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFF8D56B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white10, Colors.white05],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: darkSurface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary, darkTextTertiary),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primary,
        unselectedItemColor: darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primary,
        unselectedLabelColor: darkTextTertiary,
        indicatorColor: primary,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      inputDecorationTheme: _buildInputDecoration(darkSurface, darkTextSecondary, primary),
      elevatedButtonTheme: _buildElevatedButton(primary, Colors.white),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: darkTextTertiary.withOpacity(0.2),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkElevated,
        selectedColor: primary.withOpacity(0.2),
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        secondaryLabelStyle: GoogleFonts.poppins(fontSize: 12, color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkElevated,
        contentTextStyle: GoogleFonts.poppins(color: darkTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextPrimary),
        contentTextStyle: GoogleFonts.poppins(fontSize: 14, color: darkTextSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: lightSurface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: lightTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary, lightTextTertiary),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primary,
        unselectedItemColor: lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primary,
        unselectedLabelColor: lightTextTertiary,
        indicatorColor: primary,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      inputDecorationTheme: _buildInputDecoration(lightElevated, lightTextSecondary, primary),
      elevatedButtonTheme: _buildElevatedButton(primary, Colors.white),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: lightTextTertiary.withOpacity(0.2),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightElevated,
        selectedColor: primary.withOpacity(0.1),
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        secondaryLabelStyle: GoogleFonts.poppins(fontSize: 12, color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightTextPrimary,
        contentTextStyle: GoogleFonts.poppins(color: lightSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: lightTextPrimary),
        contentTextStyle: GoogleFonts.poppins(fontSize: 14, color: lightTextSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary, Color tertiary) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: primary),
      displayMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: primary),
      displaySmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: primary),
      headlineLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: primary),
      headlineSmall: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: primary),
      titleLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      titleMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
      titleSmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: primary),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: secondary),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: tertiary),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: secondary),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: tertiary),
      labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: tertiary, letterSpacing: 0.5),
    );
  }

  static InputDecorationTheme _buildInputDecoration(Color fill, Color hint, Color focus) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      hintStyle: GoogleFonts.inter(color: hint, fontSize: 14),
      labelStyle: GoogleFonts.inter(color: hint, fontSize: 14),
      prefixIconColor: hint,
      suffixIconColor: hint,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButton(Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
