import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/account/implementation/FirebaseUserToAccountTransformer.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountRepositoryFirebase implements AccountRepositoryInterface {
  final FirebaseAuth _auth;
  final FirebaseUserToAccountTransformer _transformer;

  AccountRepositoryFirebase(
      FirebaseAuth authProvider, ProfileRepositoryInterface profileRepository)
      : _auth = authProvider,
        _transformer = FirebaseUserToAccountTransformer(profileRepository);
  @override
  Future<AccountEntity> authorized() async {
    return _transformer.transform(from: _auth.currentUser);
  }

  @override
  Future<AccountEntity> authorize(String username, String password) {
    return _auth
        .signInWithEmailAndPassword(
      email: username,
      password: password,
    )
        .then((result) {
      return _transformer.transform(from: result.user);
    });
  }

  @override
  Future<AccountEntity> create(String username, String password) {
    return _auth
        .createUserWithEmailAndPassword(
      email: username,
      password: password,
    )
        .then((result) {
      return _transformer.transform(from: result.user);
    });
  }

  @override
  Future<AccountEntity> anonymous() {
    return _auth.signInAnonymously().then((result) {
      return _transformer.transform(from: result.user);
    });
  }

  @override
  Future<bool> deauthorize() {
    return _auth.signOut().then((_) => _auth.currentUser == null);
  }

  @override
  Stream<AccountEntity> observeAuthorized() {
    return _auth
        .authStateChanges()
        .where((user) => user != null)
        .map((user) => _transformer.transform(from: user));
  }
}
