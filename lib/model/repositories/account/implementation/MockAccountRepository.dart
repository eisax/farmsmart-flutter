import 'dart:async';
import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';

import '../AccountRepositoryInterface.dart';

class _Strings {
  static const accountID = "Mock";
}

class MockAccountRepository implements AccountRepositoryInterface {
  final AccountEntity _account;
  final _streamController = StreamController<AccountEntity>.broadcast();
  bool _created = false;

  MockAccountRepository._(this._account);

  factory MockAccountRepository(ProfileRepositoryInterface profileRepository) {
    final repository = MockAccountRepository._(
        AccountEntity(_Strings.accountID, profileRepository));
    repository._signIn();
    return repository;
  }

  void _signIn() {
    _created = true;
    _streamController.add(_account);
  }

  @override
  Future<AccountEntity> authorize(String username, String password) {
    _signIn();
    return Future.value(_account);
  }

  @override
  Future<AccountEntity> create(String username, String password) {
    _signIn();
    return Future.value(_account);
  }

  @override
  Future<AccountEntity> authorized() {
    return _created
        ? Future.value(_account)
        : Future<AccountEntity>.error(StateError('no authorized account'));
  }

  @override
  Future<AccountEntity> anonymous() {
    _signIn();
    return Future.value(_account);
  }

  @override
  Future<bool> deauthorize() {
    _created = false;
    _streamController.addError(StateError('deauthorized'));
    return Future.value(true);
  }

  @override
  Stream<AccountEntity> observeAuthorized() async* {
    if (_created) {
      yield _account;
    }
    yield* _streamController.stream;
  }

  void deinit() {
    _streamController.sink.close();
    _streamController.close();
  }
}
