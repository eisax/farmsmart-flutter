import 'package:farmsmart_flutter/model/repositories/repository_provider.dart';
import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String environment;
  final RepositoryProvider repositoryProvider;
  final String buildFlavor;

  const AppConfig({
    required this.environment,
    required this.buildFlavor,
    required Widget child,
    required this.repositoryProvider,
    super.key,
  }) : super(child: child);

  static AppConfig of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  bool isProductionBuild() => buildFlavor == "Production";
}
