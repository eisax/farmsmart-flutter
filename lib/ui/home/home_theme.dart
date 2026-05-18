import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// @deprecated Use [AppTheme] directly. Kept for gradual migration.
class FarmSmartHomeTheme {
  FarmSmartHomeTheme._();

  static const primaryGreen = AppTheme.accent;
  static const accentGreen = AppTheme.accent;
  static const lightGreen = AppTheme.accentLight;
  static const navy = AppTheme.black;
  static const slate = AppTheme.grey;
  static const mutedText = AppTheme.greyLight;
  static const surface = AppTheme.white;
  static const cardSurface = AppTheme.white;
  static const divider = AppTheme.border;

  static const bottomBarSelected = AppTheme.accent;
  static const bottomBarUnselected = AppTheme.greyLight;

  static TextStyle get screenTitle => AppTheme.displayTitle;
  static TextStyle get screenSubtitle => AppTheme.body;

  /// Alias for legacy call sites.
  static TextStyle get body => AppTheme.body;

  static BoxDecoration get headerDecoration => const BoxDecoration(
        color: AppTheme.white,
      );

  static BoxDecoration get plotCardDecoration => AppTheme.whiteCard();
}
