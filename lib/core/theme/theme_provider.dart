import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tube_filter/core/constants/app_colors.dart';

enum AppThemeMode { light, dark, pink, blue, green }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  AppThemeMode _currentMode = AppThemeMode.light;
  late SharedPreferences _prefs;

  AppThemeMode get currentMode => _currentMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final idx = _prefs.getInt(_themeKey) ?? 0;
    // Handle old theme indices gracefully
    _currentMode = idx < AppThemeMode.values.length 
        ? AppThemeMode.values[idx] 
        : AppThemeMode.light;
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode mode) async {
    _currentMode = mode;
    await _prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  ThemeData get themeData {
    switch (_currentMode) {
      case AppThemeMode.dark:
        return _darkTheme;
      case AppThemeMode.pink:
        return _pinkTheme;
      case AppThemeMode.blue:
        return _blueTheme;
      case AppThemeMode.green:
        return _greenTheme;
      case AppThemeMode.light:
        return _lightTheme;
    }
  }

  // ============ THEMES ============

  // 1. Light (Original Gold/Yellow)
  static final _lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.primaryVariant,
      surface: AppColors.background,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.playball(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.playball(
        color: AppColors.textPrimary,
        fontSize: 24,
      ),
      bodyLarge: const TextStyle(color: AppColors.textPrimary),
      bodyMedium: const TextStyle(color: AppColors.textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: GoogleFonts.playball(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // 2. Dark (Classic Dark Mode)
  static final _darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: AppColors.primary,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: const Color(0xFF1E1E1E),
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.playball(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.playball(color: Colors.white, fontSize: 24),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.playball(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // 3. Hot Pink (Vibrant)
  static const _pinkPrimary = Color(0xFFE91E63);
  static const _pinkBg = Color(0xFFFCE4EC);
  
  static final _pinkTheme = ThemeData(
    scaffoldBackgroundColor: _pinkBg,
    primaryColor: _pinkPrimary,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _pinkPrimary,
      primary: _pinkPrimary,
      surface: _pinkBg,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.playball(
        color: _pinkPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.playball(color: _pinkPrimary, fontSize: 24),
      bodyLarge: const TextStyle(color: Color(0xFF880E4F)),
      bodyMedium: TextStyle(color: Colors.pink.shade300),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _pinkBg,
      elevation: 0,
      iconTheme: const IconThemeData(color: _pinkPrimary),
      titleTextStyle: GoogleFonts.playball(
        color: _pinkPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // 4. Ocean Blue (Vibrant)
  static const _bluePrimary = Color(0xFF2196F3);
  static const _blueBg = Color(0xFFE3F2FD);
  
  static final _blueTheme = ThemeData(
    scaffoldBackgroundColor: _blueBg,
    primaryColor: _bluePrimary,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _bluePrimary,
      primary: _bluePrimary,
      surface: _blueBg,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.playball(
        color: _bluePrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.playball(color: _bluePrimary, fontSize: 24),
      bodyLarge: const TextStyle(color: Color(0xFF0D47A1)),
      bodyMedium: TextStyle(color: Colors.blue.shade300),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _blueBg,
      elevation: 0,
      iconTheme: const IconThemeData(color: _bluePrimary),
      titleTextStyle: GoogleFonts.playball(
        color: _bluePrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // 5. Lime Green (Vibrant)
  static const _greenPrimary = Color(0xFF4CAF50);
  static const _greenBg = Color(0xFFE8F5E9);
  
  static final _greenTheme = ThemeData(
    scaffoldBackgroundColor: _greenBg,
    primaryColor: _greenPrimary,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _greenPrimary,
      primary: _greenPrimary,
      surface: _greenBg,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.playball(
        color: _greenPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.playball(color: _greenPrimary, fontSize: 24),
      bodyLarge: const TextStyle(color: Color(0xFF1B5E20)),
      bodyMedium: TextStyle(color: Colors.green.shade300),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _greenBg,
      elevation: 0,
      iconTheme: const IconThemeData(color: _greenPrimary),
      titleTextStyle: GoogleFonts.playball(
        color: _greenPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
