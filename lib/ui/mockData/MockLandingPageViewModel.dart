import 'package:flutter/widgets.dart';
import 'package:farmsmart_flutter/model/bloc/StaticViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/FlowCoordinator.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/ui/LandingPage.dart';
import 'package:farmsmart_flutter/ui/offline/OfflineDownloadPage.dart';
import 'package:intl/intl.dart';

class _LocalisedStrings {
  static String detailText() =>
      Intl.message('A network and knowledge source for farmers in Kenya');

  static String actionText() => Intl.message('Get Started');

  static String footerText() =>
      Intl.message('Switch language – Badilisha Lugha');
}

class MockLandingPageViewModel {
  static LandingPageViewModel build() {
    return LandingPageViewModel(
      detailText: _LocalisedStrings.detailText(),
      actionText: _LocalisedStrings.actionText(),
      footerText: _LocalisedStrings.footerText(),
      headerImage: "assets/raw/illustration_welcome.png",
      subtitleImage: "assets/raw/logo_default.png",
      newAccountFlow: _MockFlowCoordinator(),
      switchLanguageTapped: (language, country) =>
          _mockSwitchLanguage(language, country),
      downloaderViewModelProvider:
          StaticViewModelProvider<OfflineDownloadPageViewModel>(
        OfflineDownloadPageViewModel(
          LoadingStatus.SUCCESS,
          () {},
          0.0,
          Error(),
        ),
      ),
    );
  }

  static _mockSwitchLanguage(String language, String country) {
    print(language + " " + country);
  }
}

class _MockFlowCoordinator implements FlowCoordinator {
  @override
  FlowCoordinatorStatus get status => FlowCoordinatorStatus.Idle;

  @override
  void run(BuildContext context,
      {Function onSuccess = _defaultOnSuccess,
      Function onFail = _defaultOnFail}) {
    onSuccess();
  }
}

void _defaultOnSuccess() {}

void _defaultOnFail() {}
