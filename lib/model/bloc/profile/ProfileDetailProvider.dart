import 'dart:async';
import 'dart:io';

import 'package:farmsmart_flutter/farmsmart_localizations.dart';
import 'package:farmsmart_flutter/model/analytics_interface.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/CreateAccountFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/EditProfileFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/FlowCoordinator.dart';
import 'package:farmsmart_flutter/model/bloc/download/OfflineDownloader.dart';
import 'package:farmsmart_flutter/model/bloc/download/OfflineDownloaderProvider.dart';
import 'package:farmsmart_flutter/model/bloc/plot/PlotStatistics.dart';
import 'package:farmsmart_flutter/model/bloc/profile/PersonName.dart';
import 'package:farmsmart_flutter/model/bloc/profile/SwitchProfileListProvider.dart';
import 'package:farmsmart_flutter/model/entities/PlotEntity.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/locale/locale_repository_interface.dart';
import 'package:farmsmart_flutter/model/repositories/plot/PlotRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/profile/implementation/ProfileEntityTransformers.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/PathImageProvider.dart';
import 'package:farmsmart_flutter/ui/profile/Profile.dart';
import 'package:flutter/widgets.dart';

import '../ViewModelProvider.dart';

class _AnalyticsNames {
  static const updatedImage = 'profile_image_updated';
}

class _DefaultLocale {
  static final current =
      ContentLocale(const Locale('en', 'KE'), 'English (Zimbabwe)');
}

class ProfileDetailProvider
    extends ObjectTransformer<ProfileEntity, ProfileViewModel>
    implements ViewModelProvider<ProfileViewModel> {
  final AccountRepositoryInterface _accountRepository;
  final PlotRepositoryInterface _plotRepository;
  final LocaleRepositoryInterface _localesRepository;
  final OfflineDownloader _downloader;
  ProfileRepositoryInterface? _profileRepository;
  int _activeCrops = 0;
  int _completedCrops = 0;
  ProfileViewModel? _snapshot;
  ProfileEntity? _currentProfile;
  LocaleState? _localeState;
  final PlotStatistics _plotStatistics = PlotStatistics();
  LoadingStatus _loadingStatus = LoadingStatus.LOADING;
  bool _canDeleteProfile = false;
  final StreamController<ProfileViewModel> _controller =
      StreamController<ProfileViewModel>.broadcast();

  late NewAccountFlowCoordinator _accountFlow;
  late EditProfileFlowCoordinator _editProfileFlow;

  ProfileDetailProvider(
      {required AccountRepositoryInterface accountRepo,
      required PlotRepositoryInterface plotRepo,
      required LocaleRepositoryInterface localeRepo,
      required OfflineDownloader downloader})
      : _accountRepository = accountRepo,
        _plotRepository = plotRepo,
        _localesRepository = localeRepo,
        _downloader = downloader;

  @override
  Stream<ProfileViewModel> stream() {
    return _controller.stream;
  }

  @override
  ProfileViewModel snapshot() {
    return _snapshot!;
  }

  @override
  ProfileViewModel initial() {
    if (_snapshot == null) {
      _accountRepository.observeAuthorized().listen((currentAccount) {
        _profileRepository = currentAccount.profileRepository;
        currentAccount.profileRepository.observeCurrent().listen((currentProfile) {
          _localesRepository.getLocaleState().then((localeState) {
            _localeState = localeState;
            _loadingStatus = LoadingStatus.SUCCESS;
            _currentProfile = currentProfile;
            _snapshot = transform(from: currentProfile);
            _controller.sink.add(_snapshot!);
          });
        });

        _profileRepository?.get().then((profiles) {
          _canDeleteProfile = profiles.length > 1;
          _localesRepository.getLocaleState().then((localeState) {
            _localeState = localeState;
            _update();
          });
        });
      });

      _plotRepository.observeFarm().listen((List<PlotEntity> plots) {
        _activeCrops = _plotStatistics.activeCount(plots);
        _completedCrops = _plotStatistics.compeletedCount(plots);
        _update();
      });

      _accountFlow = NewAccountFlowCoordinator(
        _accountRepository,
        _accountFlowStatusChanged,
      );
      _accountFlow.init();

      _editProfileFlow = EditProfileFlowCoordinator(
        _accountRepository,
        _accountFlowStatusChanged,
      );

      _snapshot = transform(from: null);
      _snapshot!.refresh();
    }
    return _snapshot!;
  }

  @override
  ProfileViewModel transform({ProfileEntity? from}) {
    final switchProfileProvider =
        SwitchProfileListProvider(accountRepo: _accountRepository);
    final personName = PersonName(from?.name ?? "");
    return ProfileViewModel(
      loadingStatus: _loadingStatus,
      username: personName.fullname,
      initials: personName.initials,
      refresh: _refresh,
      remove: _canDeleteProfile ? () => _remove() : null,
      logout: () => _logout(),
      image: from?.avatar ?? PathImageProvider(''),
      activeCrops: _activeCrops,
      completedCrops: _completedCrops,
      switchProfileProvider: switchProfileProvider,
      farmDetails: from?.lastPlotInfo ?? {},
      switchLanguageTapped: (language, country) =>
          _switchLanguage(language, country),
      newAccountFlow: _accountFlow,
      saveProfileImage: (file) => _saveProfileImage(file, from),
      renameProfile: (username) => _renameProfile(username),
      editProfileFlow: _editProfileFlow,
      supportedLocales:
          _localeState?.availableLocales ?? [_DefaultLocale.current],
      currentLocale: _localeState?.currentLocale ?? _DefaultLocale.current,
      downloaderViewModelProvider: OfflineDownloaderProvider(_downloader),
    );
  }

  _switchLanguage(String language, String country) async {
    await FarmsmartLocalizations.persistLocale(Locale(language, country));
    FarmsmartLocalizations.load().then((_) {
      _refresh();
    });
  }

  Future<bool> _logout() {
    _loadingStatus = LoadingStatus.LOADING;
    _update();
    return _accountRepository.deauthorize();
  }

  Future<bool> _remove() {
    return _profileRepository!.remove(_currentProfile!).then((success) {
      _profileRepository!.get().then((profiles) {
        final profile = profiles.isNotEmpty ? profiles.first : null;
        if (profile != null) {
          _profileRepository!.switchTo(profile);
        }
      });
      return success;
    });
  }

  void _accountFlowStatusChanged(FlowCoordinator coordinator) {}

  void _update() {
    _snapshot = transform(from: _currentProfile);
    _controller.sink.add(_snapshot!);
  }

  void _refresh() {
    _accountRepository.authorized().then((account) {
      _profileRepository?.getCurrent();
      _plotRepository.getFarm();
    });
  }

  void dispose() {
    _controller.sink.close();
    _controller.close();
  }

  void _saveProfileImage(File file, ProfileEntity? from) async {
    if (from == null) {
      return;
    }
    LocalProfileImageProvider.localAvatarPath(from.id).then((savePath) {
      imageCache.evict(FileImage(File(savePath)));
      file.copy(savePath).then((result) {
        AnalyticsInterface.implementation()
            .effect(_AnalyticsNames.updatedImage);
        _profileRepository?.updateCurrent(from);
      });
    });
  }

  void _renameProfile(String username) {
    if (_currentProfile == null) {
      return;
    }
    final updatedProfile = ProfileEntity(
      _currentProfile!.id,
      _currentProfile!.uri,
      username,
      _currentProfile!.avatar,
      _currentProfile!.lastPlotInfo,
    );
    _profileRepository?.updateCurrent(updatedProfile);
  }
}
