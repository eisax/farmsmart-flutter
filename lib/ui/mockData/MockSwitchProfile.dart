import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:farmsmart_flutter/model/bloc/StaticViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/CreateAccountFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/EditProfileFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/FlowCoordinator.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockString.dart';
import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/MockImageEntity.dart';
import 'package:farmsmart_flutter/model/repositories/locale/locale_repository_interface.dart';
import 'package:farmsmart_flutter/ui/offline/OfflineDownloadPage.dart';
import 'package:farmsmart_flutter/ui/profile/Profile.dart';
import 'package:farmsmart_flutter/ui/profile/SwitchProfileList.dart';
import 'package:farmsmart_flutter/ui/profile/SwitchProfileListItem.dart';

class MockSwitchProfile {
  static SwitchProfileListViewModel build() {
    List<SwitchProfileListItemViewModel> list = [];
    for (var i = 0; i < 10; i++) {
      list.add(MockSwitchProfileItemsViewModel.build(i));
    }

    return SwitchProfileListViewModel(
      items: list,
      title: "Switch Profile",
      actionTitle: "Switch Profile",
      isVisible: false,
      selectedIndex: 0,
      confirmedIndex: 0,
      loadingStatus: LoadingStatus.SUCCESS,
      newProfileFlow: _MockFlowCoordinator(),
      refresh: () {},
    );
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

class _MockAccountRepository implements AccountRepositoryInterface {
  @override
  Stream<AccountEntity> observeAuthorized() async* {}

  @override
  Future<AccountEntity> authorized() async {
    throw UnimplementedError();
  }

  @override
  Future<AccountEntity> authorize(String username, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<AccountEntity> create(String username, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<AccountEntity> anonymous() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> deauthorize() async {
    throw UnimplementedError();
  }
}

class MockSwitchProfileItemsViewModel {
  static SwitchProfileListItemViewModel build(index) {
    return SwitchProfileListItemViewModel(
      title: _mockTitle.random(),
      icon: "assets/icons/radio_button_default.png",
      image: MockImageEntity().build().urlProvider,
      tapAction: () {},
      switchAction: () {},
      avatarViewModelProvider: StaticViewModelProvider<ProfileViewModel>(
        ProfileViewModel(
          loadingStatus: LoadingStatus.SUCCESS,
          username: 'User',
          initials: 'U',
          activeCrops: 0,
          completedCrops: 0,
          switchProfileProvider:
              StaticViewModelProvider<SwitchProfileListViewModel>(
            SwitchProfileListViewModel(
              title: 'Switch Profile',
              actionTitle: 'Switch Profile',
              items: [],
              confirmedIndex: 0,
              selectedIndex: 0,
              loadingStatus: LoadingStatus.SUCCESS,
              newProfileFlow: _MockFlowCoordinator(),
              refresh: () {},
            ),
          ),
          image: MockImageEntity().build().urlProvider,
          refresh: () {},
          logout: () {},
          remove: null,
          renameProfile: (String _) {},
          farmDetails: {},
          switchLanguageTapped: (String language, String country) {},
          newAccountFlow:
              NewAccountFlowCoordinator(_MockAccountRepository(), (_) {}),
          saveProfileImage: (File file) {},
          editProfileFlow:
              EditProfileFlowCoordinator(_MockAccountRepository(), (_) {}),
          supportedLocales: [
            ContentLocale(Locale('en', 'KE'), 'English (Kenya)')
          ],
          currentLocale: ContentLocale(Locale('en', 'KE'), 'English (Kenya)'),
          downloaderViewModelProvider:
              StaticViewModelProvider<OfflineDownloadPageViewModel>(
            OfflineDownloadPageViewModel(
              LoadingStatus.SUCCESS,
              () {},
              0.0,
              Error(),
            ),
          ),
        ),
      ),
      isSelected: index == 0 ? true : false,
    );
  }
}

MockString _mockTitle = MockString(library: [
  "Isioma Adegoke",
  "Ndubuisi Ajayi",
  "Temitope Aliero",
  "Safinatu Adegoke",
  "Ireti Kuta",
]);
