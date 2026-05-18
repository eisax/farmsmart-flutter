import 'dart:ui';

import 'package:farmsmart_flutter/model/bloc/StaticViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/CreateAccountFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/EditProfileFlow.dart';
import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/locale/locale_repository_interface.dart';
import 'package:farmsmart_flutter/ui/offline/OfflineDownloadPage.dart';
import 'package:farmsmart_flutter/ui/profile/Profile.dart';
import 'package:farmsmart_flutter/ui/profile/SwitchProfileList.dart';
import 'package:farmsmart_flutter/ui/profile/SwitchProfileListItem.dart';

import '../Transformer.dart';
import 'PersonName.dart';

class SwitchProfileListItemViewModelTransformer
    extends ObjectTransformer<ProfileEntity, SwitchProfileListItemViewModel> {
  final Function _switch;
  final ProfileEntity? _currentProfile;
  SwitchProfileListItemViewModelTransformer(this._switch, this._currentProfile);
  @override
  SwitchProfileListItemViewModel transform({ProfileEntity? from}) {
    if (from == null) {
      throw ArgumentError.notNull('from');
    }
    final initials = PersonName(from.name).initials;
    final avatarProvider = StaticViewModelProvider<ProfileViewModel>(
      _avatarViewModel(from.avatar, initials),
    );
    return SwitchProfileListItemViewModel(
      title: from.name,
      image: from.avatar,
      icon: _Icons.checkBox,
      tapAction: () {},
      switchAction: () => _switch(from),
      avatarViewModelProvider: avatarProvider,
      isSelected: (from.uri == _currentProfile?.uri),
    );
  }

  static ProfileViewModel _avatarViewModel(
      ImageURLProvider image, String initials) {
    final accountRepository = _StubAccountRepository();
    return ProfileViewModel(
      loadingStatus: LoadingStatus.SUCCESS,
      username: '',
      initials: initials,
      activeCrops: 0,
      completedCrops: 0,
      switchProfileProvider: StaticViewModelProvider<SwitchProfileListViewModel>(
        SwitchProfileListViewModel(
          title: '',
          actionTitle: '',
          items: [],
          confirmedIndex: 0,
          selectedIndex: 0,
          loadingStatus: LoadingStatus.SUCCESS,
          newProfileFlow:
              NewAccountFlowCoordinator(accountRepository, (_) {}),
          refresh: () {},
        ),
      ),
      image: image,
      refresh: () {},
      logout: () {},
      farmDetails: {},
      switchLanguageTapped: (_, __) {},
      newAccountFlow: NewAccountFlowCoordinator(accountRepository, (_) {}),
      saveProfileImage: (_) {},
      renameProfile: (_) {},
      editProfileFlow: EditProfileFlowCoordinator(accountRepository, (_) {}),
      supportedLocales: [
        ContentLocale(const Locale('en', 'KE'), 'English (Kenya)')
      ],
      currentLocale: ContentLocale(const Locale('en', 'KE'), 'English (Kenya)'),
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

class _Icons {
  static final checkBox = "assets/icons/radio_button_default.png";
}

class _StubAccountRepository implements AccountRepositoryInterface {
  @override
  Stream<AccountEntity> observeAuthorized() async* {}

  @override
  Future<AccountEntity> authorized() async => throw UnimplementedError();

  @override
  Future<AccountEntity> authorize(String username, String password) async =>
      throw UnimplementedError();

  @override
  Future<AccountEntity> create(String username, String password) async =>
      throw UnimplementedError();

  @override
  Future<AccountEntity> anonymous() async => throw UnimplementedError();

  @override
  Future<bool> deauthorize() async => throw UnimplementedError();
}
