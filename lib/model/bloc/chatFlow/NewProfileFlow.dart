import 'package:farmsmart_flutter/chat/ChatPage.dart';
import 'package:farmsmart_flutter/chat/ui/viewmodel/ChatResponseViewModel.dart';
import 'package:farmsmart_flutter/model/bloc/startup/ChatResponseToPlotInfoTransformer.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:farmsmart_flutter/model/repositories/MockStrings.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/PathImageProvider.dart';
import 'package:farmsmart_flutter/ui/common/modal_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../analytics_interface.dart';
import '../Transformer.dart';
import 'FlowCoordinator.dart';

class _LocalisedAssets {
  static String onboardingFlow() =>
      Intl.message('assets/responses/farmsmart_chat_ui_flow.json');
}

class _LocalisedStrings {
  static String alreadyInProgress() =>
      Intl.message('Operation already in progress');
}

class _Strings {
  static const nameField = "Name";
}

class _AnalyticsNames {
  static const newProfile = 'new_profile';
}

class NewProfileFlowCoordinator implements FlowCoordinator {
  final AccountRepositoryInterface _accountRepository;
  final Function _onStatusChanged;
  FlowCoordinatorStatus _status = FlowCoordinatorStatus.Idle;

  NewProfileFlowCoordinator(this._accountRepository, Function onStatusChanged)
      : _onStatusChanged = onStatusChanged;

  void run(BuildContext context, {Function? onSuccess, Function? onFail}) {
    if (_status != FlowCoordinatorStatus.InProgress) {
      _setStatus(FlowCoordinatorStatus.InProgress);
      NavigationScope.presentModal(
          context,
          ChatPage(
              viewModel: _chatPageViewModel(onSuccess: () {
            _setStatus(FlowCoordinatorStatus.Complete);

            onSuccess?.call();
          }, onFail: (error) {
            _setStatus(FlowCoordinatorStatus.Complete);
            onFail?.call(error);
          })));
    } else {
      onFail?.call(UnsupportedError(_LocalisedStrings.alreadyInProgress()));
    }
  }

  ChatPageViewModel _chatPageViewModel(
      {Function? onSuccess, Function? onFail}) {
    return ChatPageViewModel(_LocalisedAssets.onboardingFlow(), (data) {
      final Map<String, ChatResponseViewModel>? chatInput =
          castOrNull<Map<String, ChatResponseViewModel>>(data);
      if (chatInput != null) {
        _updateAccount(
          chatInput,
          () {
            final valueMap = chatInput.map<String, String>(
                (key, value) => MapEntry(key, value.value.toString()));
            AnalyticsInterface.implementation()
                .effect(_AnalyticsNames.newProfile, parameters: valueMap);
            onSuccess?.call();
          },
          onFail,
        );
      } else {
        onFail?.call();
      }
    }, onFail ?? () {});
  }

  void _setStatus(FlowCoordinatorStatus newStatus) {
    if (newStatus != _status) {
      _status = newStatus;
      _onStatusChanged(this);
    }
  }

  void _updateAccount(Map<String, ChatResponseViewModel> chatInput,
      Function? onSuccess, Function? onFail) {
    final name = chatInput[_Strings.nameField];
    final transformer = ChatResponseToPlotInfoTransformer();
    final plotInfo = transformer.transform(from: chatInput);
    //TODO: Remove the Mock ID´s once implemented
    if (name != null) {
      _accountRepository.authorized().then((account) {
        final newProfile = ProfileEntity(
          mockPlainText.identifier(),
          mockPlainText.identifier(),
          name.value,
          PathImageProvider(''),
          plotInfo,
        );
        account.profileRepository.add(newProfile).then((profile) {
          account.profileRepository.switchTo(profile).then((result) {
            result
                ? onSuccess?.call()
                : onFail?.call(StateError('switch_failed'));
          }, onError: (error) {
            onFail?.call(error);
          });
        }, onError: (error) {
          onFail?.call(error);
        });
      }, onError: (error) {
        onFail?.call(error);
      });
    } else {
      onFail?.call(StateError('missing_name'));
    }
  }

  @override
  FlowCoordinatorStatus get status => _status;
}
