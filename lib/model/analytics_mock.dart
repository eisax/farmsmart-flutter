import 'package:farmsmart_flutter/model/analytics_interface.dart';
import 'package:flutter/widgets.dart';

class AnalyticsMockImp extends AnalyticsInterface {
  @override
  Future<void> send(AnalyticsEvent event) async {
    print('Mock Analytics Event: ${event.name}');
    print('Parameters: ${event.parameters}');
  }

  @override
  Future<void> userProperty(String name, String value) async {
    print('Mock User Property: $name = $value');
  }

  @override
  NavigatorObserver get navigationObserver => NavigatorObserver();
}
