import 'dart:ui';

import 'package:farmsmart_flutter/farmsmart_localizations.dart';
import 'package:farmsmart_flutter/model/repositories/locale/locale_repository_interface.dart';

class MockLocaleRepository implements LocaleRepositoryInterface {
  static final List<ContentLocale> _locales = [
    FarmsmartLocalizations.defaultLocale,
    ContentLocale(Locale('en', 'US'), 'English (USD)'),
  ];

  @override
  Future<List<ContentLocale>> availableLocales() async => _locales;

  @override
  Future<ContentLocale> currentLocale() async {
    final locale = await FarmsmartLocalizations.getLocale();
    return _locales.firstWhere(
      (entry) => entry.locale == locale,
      orElse: () => FarmsmartLocalizations.defaultLocale,
    );
  }

  @override
  Future<LocaleState> getLocaleState() async {
    final current = await currentLocale();
    return LocaleState(current, _locales);
  }
}
