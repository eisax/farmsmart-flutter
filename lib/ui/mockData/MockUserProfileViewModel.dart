import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:farmsmart_flutter/model/bloc/StaticViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/CreateAccountFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/EditProfileFlow.dart';
import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/locale/locale_repository_interface.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/MockImageEntity.dart';
import 'package:farmsmart_flutter/ui/mockData/MockSwitchProfile.dart';
import 'package:farmsmart_flutter/ui/offline/OfflineDownloadPage.dart';
import 'package:farmsmart_flutter/ui/profile/Profile.dart';
import 'package:farmsmart_flutter/ui/profile/ProfileListItem.dart';
import 'package:farmsmart_flutter/ui/profile/SwitchProfileList.dart';
import 'package:intl/intl.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockString.dart';

class MockProfileViewModel {
  static ProfileViewModel build() {
    final username = _mockUserName.random();
    final accountRepository = _MockAccountRepository();

    return ProfileViewModel(
      loadingStatus: LoadingStatus.SUCCESS,
      username: username,
      initials: username.isNotEmpty
          ? username
              .split(' ')
              .map((part) => part.isNotEmpty ? part[0] : '')
              .join()
              .toUpperCase()
          : 'NA',
      activeCrops: Random().nextInt(50),
      completedCrops: Random().nextInt(50),
      switchProfileProvider:
          StaticViewModelProvider<SwitchProfileListViewModel>(
              MockSwitchProfile.build()),
      image: MockImageEntity().build().urlProvider,
      refresh: () {},
      logout: () {},
      remove: null,
      renameProfile: (String _) {},
      farmDetails: {},
      switchLanguageTapped: (String language, String country) {},
      newAccountFlow: NewAccountFlowCoordinator(accountRepository, (_) {}),
      saveProfileImage: (File file) {},
      editProfileFlow: EditProfileFlowCoordinator(accountRepository, (_) {}),
      supportedLocales: [ContentLocale(Locale('en', 'KE'), 'English (Kenya)')],
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
    );
  }

  static ProfileViewModel buildLarger() {
    final username = _mockUserName.random();
    final accountRepository = _MockAccountRepository();
    List<ProfileListItemViewModel> list = [];
    for (var i = 0; i < 8; i++) {
      list.add(MockUserProfileListItemViewModel.buildLarger(i));
    }

    return ProfileViewModel(
      loadingStatus: LoadingStatus.SUCCESS,
      username: username,
      initials: username.isNotEmpty
          ? username
              .split(' ')
              .map((part) => part.isNotEmpty ? part[0] : '')
              .join()
              .toUpperCase()
          : 'NA',
      activeCrops: Random().nextInt(150),
      completedCrops: Random().nextInt(150),
      switchProfileProvider:
          StaticViewModelProvider<SwitchProfileListViewModel>(
              MockSwitchProfile.build()),
      image: MockImageEntity().build().urlProvider,
      refresh: () {},
      logout: () {},
      remove: null,
      renameProfile: (String _) {},
      farmDetails: {},
      switchLanguageTapped: (String language, String country) {},
      newAccountFlow: NewAccountFlowCoordinator(accountRepository, (_) {}),
      saveProfileImage: (File file) {},
      editProfileFlow: EditProfileFlowCoordinator(accountRepository, (_) {}),
      supportedLocales: [ContentLocale(Locale('en', 'KE'), 'English (Kenya)')],
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
    );
  }
}

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

class MockUserProfileListItemViewModel {
  static ProfileListItemViewModel build(index) {
    return ProfileListItemViewModel(
      title: Intl.message(_mockActionTitle[index]),
      icon: _mockActionIcon[index],
      onTap: () => _mockItemTap(),
      isDestructive: index != 7 ? false : true,
    );
  }

  static ProfileListItemViewModel buildLarger(index) {
    return ProfileListItemViewModel(
      title: Intl.message(_mockActionTitleLarger[index]),
      icon: _mockActionIcon[index],
      onTap: () => _mockItemTap(),
      isDestructive: index != 7 ? false : true,
    );
  }

  static _mockItemTap() {
    print("Was tapped");
  }
}

List<String> _mockActionTitleLarger = [
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  "Maecenas vitae risus vitae nulla euismod viverra ut eu lacus.",
  "Duis at dolor posuere, iaculis diam a, dictum urna.",
  "Mauris a turpis sem. Cras eleifend semper lorem id feugiat.",
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  "Donec a magna a ipsum aliquet fringilla.",
  "Mauris elementum arcu turpis, ac imperdiet sem rutrum vel.",
  "Sed eu fermentum nisi. Fusce dui velit, dictum nec dictum eget, varius at felis.",
];

List<String> _mockActionTitle = [
  "Switch Language",
  "Your Farm Details",
  "Update Pin",
  "Create New Profile",
  "Invite Friends",
  "Privacy Policy",
  "Terms of Use",
  "Delete Profile",
];
List<String?> _mockActionIcon = [
  "assets/icons/detail_icon_language.png",
  "assets/icons/detail_icon_best_soil.png",
  "assets/icons/detail_icon_pin.png",
  "assets/icons/detail_icon_new_profile.png",
  "assets/icons/detail_icon_invite.png",
  null,
  null,
  null,
];

MockString _mockUserName = MockString(library: [
  "Ireti Kuta",
]);
