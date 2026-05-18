import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FarmSmart design system — clean white UI, black type, dark grey data cards,
/// forest-green accents (Agri AI / less-is-more reference).
class AppTheme {
  AppTheme._();

  // —— Core palette ——
  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF6F7F6);
  static const black = Color(0xFF121212);
  static const charcoal = Color(0xFF1E1E1E);
  static const darkGrey = Color(0xFF2D2D2D);
  static const grey = Color(0xFF6B6B6B);
  static const greyLight = Color(0xFF9E9E9E);
  static const border = Color(0xFFEBEBEB);
  static const mintWash = Color(0xFFF0F4F1);

  static const accent = Color(0xFF3D9140);
  static const accentLight = Color(0xFFE8F3E9);
  static const accentGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // —— Radii ——
  static const radiusXl = 24.0;
  static const radiusLg = 20.0;
  static const radiusMd = 16.0;
  static const radiusSm = 12.0;
  static const radiusPill = 40.0;

  // —— Typography ——
  static const String fontFamily = 'IBMPlexSans';

  static const TextStyle displayTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: black,
    letterSpacing: -0.6,
    height: 1.2,
  );

  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: black,
    letterSpacing: -0.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: grey,
    height: 1.45,
  );

  static const TextStyle bodyDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: black,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: greyLight,
  );

  static const TextStyle labelOnDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: white,
  );

  static const TextStyle valueOnDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: white,
  );

  // —— Decorations ——
  static BoxDecoration whiteCard({double radius = radiusLg}) => BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration darkCard({double radius = radiusLg}) => BoxDecoration(
        color: charcoal,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static BoxDecoration pillField = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(radiusPill),
    border: Border.all(color: border),
  );

  // —— Material theme ——
  static ThemeData build() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: white,
      canvasColor: white,
      dividerColor: border,
      colorScheme: ColorScheme.light(
        primary: accent,
        onPrimary: white,
        surface: white,
        onSurface: black,
        secondary: darkGrey,
        onSecondary: white,
        outline: border,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: white,
        foregroundColor: black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: screenTitle,
        iconTheme: IconThemeData(color: black, size: 22),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: accent,
        unselectedItemColor: greyLight,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: black,
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: offWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        labelStyle: caption.copyWith(color: grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
      listTileTheme: const ListTileThemeData(
        iconColor: grey,
        textColor: black,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: black,
        ),
        subtitleTextStyle: body,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: greyLight,
        indicatorColor: accent,
        dividerColor: border,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: charcoal,
        contentTextStyle: labelOnDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return base;
  }

  /// Circular green icon holder (reference quick-action tiles).
  static Widget iconTile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: white,
      borderRadius: BorderRadius.circular(radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radiusMd),
        child: Container(
          width: 88,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radiusMd),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: accentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
