import 'package:country_codes/country_codes.dart';
import 'package:farmsmart_flutter/flavors/app_config.dart';
import 'package:farmsmart_flutter/main.dart';
import 'package:farmsmart_flutter/model/bloc/ResetStateWidget.dart';
import 'package:farmsmart_flutter/model/repositories/repository_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> runFarmSmartApp({
  required String environment,
  required String buildFlavor,
  required RepositoryProvider repositoryProvider,
  bool lockPortraitOrientation = false,
  bool useFirebase = false,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (useFirebase) {
    await Firebase.initializeApp();
  }
  await CountryCodes.init();

  if (lockPortraitOrientation) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  runApp(
    ResetStateWidget(
      child: AppConfig(
        environment: environment,
        buildFlavor: buildFlavor,
        child: FarmSmartApp(),
        repositoryProvider: repositoryProvider,
      ),
    ),
  );
}
