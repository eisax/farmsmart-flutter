import 'app_bootstrap.dart';
import 'model/repositories/mock_repository_provider.dart';
import 'package:farmsmart_flutter/model/analytics_interface.dart';
import 'package:farmsmart_flutter/model/repositories/locale/locale_repository_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_coordinator.dart';
import 'farmsmart_localizations.dart';
import 'ui/theme/app_theme.dart';
import 'flavors/app_config.dart';
import 'l10n/tahitian_support.dart';
import 'model/analytics_mock.dart';
import 'model/bloc/ViewModelProvider.dart';
import 'model/bloc/locale/locale_selection_provider.dart';
import 'model/bloc/locale/locale_selection_viewmodel.dart';
import 'model/repositories/image/ImageRepositoryInterface.dart';

AnalyticsInterface analytics = AnalyticsMockImp();

class _Constants {
  static final defaultLocaleState = LocaleState(
      FarmsmartLocalizations.defaultLocale,
      [FarmsmartLocalizations.defaultLocale]);
}

class _String {
  static title() => 'FarmSmart';
}

class FarmSmartApp extends StatefulWidget {
  @override
  _FarmSmartAppState createState() => _FarmSmartAppState();
}

class _FarmSmartAppState extends State<FarmSmartApp> {
  @override
  void initState() {
    AnalyticsInterface.registerImplementation(analytics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final repositoryProvider = AppConfig.of(context).repositoryProvider;
    repositoryProvider.init(context);
    final repoProvider = Provider.value(value: repositoryProvider);
    final ViewModelProvider<LocaleSelectionViewModel> localeSelectionProvider =
        LocaleSelectionProvider(repositoryProvider.getLocaleRepository());
    final localeProvider = Provider.value(value: localeSelectionProvider);
    return FutureBuilder<LocaleState>(
      future: repositoryProvider
          .getLocaleRepository()
          .getLocaleState()
          .then((state) {
        return FarmsmartLocalizations.hasPersistedLocale().then((persisted) {
          if (!persisted) {
            FarmsmartLocalizations.persistLocale(state.currentLocale.locale);
            return FarmsmartLocalizations.load().then((_) {
              return startURLCache().then((_) {
                return state;
              });
            });
          }
          return startURLCache().then((_) {
            return state;
          });
        });
      }),
      initialData: _Constants.defaultLocaleState,
      builder: (BuildContext context, AsyncSnapshot<LocaleState> snapshot) {
        final LocaleState state =
            snapshot.data ?? _Constants.defaultLocaleState;
        final supportedLocales =
            state.availableLocales.map<Locale>((e) => e.locale).toList();
        return MultiProvider(
          providers: [repoProvider, localeProvider],
          child: MaterialApp(
            locale: state.currentLocale.locale,
            onGenerateTitle: (context) => _String.title(),
            localizationsDelegates: [
              FarmsmartLocalizationsDelegate(supportedLocales),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              TyMaterialLocalizations.delegate
            ],
            supportedLocales: supportedLocales,
            theme: AppTheme.build(),
            home: AppCoordinator(),
          ),
        );
      },
    );
  }
}

/// Default entry point for local dev with mock data and mock auth.
/// Use `-t lib/main_prod.dart` for production (Firebase).
void main() {
  runFarmSmartApp(
    environment: 'development',
    buildFlavor: 'Development',
    repositoryProvider: MockRepositoryProvider(),
    useFirebase: false,
  );
}
