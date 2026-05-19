import 'dart:async';
import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';

import '../AccountRepositoryInterface.dart';

class _Strings {
  static const guestPrefix = "guest_";
}

class MockAccountRepository implements AccountRepositoryInterface {
  final ProfileRepositoryInterface _profileRepository;
  final _streamController = StreamController<AccountEntity>.broadcast();

  final Map<String, String> _users = {}; // username -> password
  final Set<String> _mfaEnabled = {}; // usernames with MFA enabled
  final Map<String, String> _pendingMfa = {}; // username -> code

  AccountEntity? _currentAccount;

  MockAccountRepository._(this._profileRepository);

  factory MockAccountRepository(ProfileRepositoryInterface profileRepository) {
    return MockAccountRepository._(profileRepository);
  }

  AccountEntity _accountFor(String username) {
    return AccountEntity(username, _profileRepository);
  }

  void _setCurrent(AccountEntity account) {
    _currentAccount = account;
    _streamController.add(account);
  }

  @override
  Future<AccountEntity> authorize(String username, String password) async {
    // Support MFA mock by allowing password to be 'password:code'
    final parts = password.split(':');
    final suppliedPassword = parts[0];
    final suppliedCode = parts.length > 1 ? parts[1] : null;

    if (!_users.containsKey(username)) {
      return Future<AccountEntity>.error(StateError('no_such_user'));
    }
    if (_users[username] != suppliedPassword) {
      return Future<AccountEntity>.error(StateError('invalid_credentials'));
    }

    if (_mfaEnabled.contains(username)) {
      // If a code is supplied, verify it
      if (suppliedCode != null) {
        final expected = _pendingMfa[username];
        if (expected != null && expected == suppliedCode) {
          _pendingMfa.remove(username);
          final account = _accountFor(username);
          _setCurrent(account);
          return Future.value(account);
        }
        return Future<AccountEntity>.error(StateError('invalid_mfa'));
      }
      // No code supplied: create a pending code and signal MFA required
      final code = (100000 + (DateTime.now().millisecondsSinceEpoch % 899999))
          .toString();
      _pendingMfa[username] = code;
      // For a mock, print the code so developers can use it.
      print('MockAccountRepository: MFA code for $username is $code');
      return Future<AccountEntity>.error(StateError('mfa_required'));
    }

    final account = _accountFor(username);
    _setCurrent(account);
    return Future.value(account);
  }

  @override
  Future<AccountEntity> create(String username, String password) async {
    if (_users.containsKey(username)) {
      return Future<AccountEntity>.error(StateError('account_exists'));
    }
    _users[username] = password;
    // Enable MFA for usernames that contain 'mfa' (simple mock rule)
    if (username.contains('mfa')) {
      _mfaEnabled.add(username);
    }
    final account = _accountFor(username);
    _setCurrent(account);
    return Future.value(account);
  }

  @override
  Future<AccountEntity> authorized() {
    return _currentAccount != null
        ? Future.value(_currentAccount)
        : Future<AccountEntity>.error(StateError('no authorized account'));
  }

  @override
  Future<AccountEntity> anonymous() {
    final id =
        _Strings.guestPrefix + DateTime.now().millisecondsSinceEpoch.toString();
    final guest = _accountFor(id);
    _setCurrent(guest);
    return Future.value(guest);
  }

  @override
  Future<bool> deauthorize() {
    _currentAccount = null;
    _streamController.addError(StateError('deauthorized'));
    return Future.value(true);
  }

  @override
  Stream<AccountEntity> observeAuthorized() async* {
    if (_currentAccount != null) {
      yield _currentAccount!;
    }
    yield* _streamController.stream;
  }

  void deinit() {
    _streamController.sink.close();
    _streamController.close();
  }
}
