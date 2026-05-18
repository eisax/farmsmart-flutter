
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/entities/AccountEntity.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserToAccountTransformer extends ObjectTransformer<User, AccountEntity> {
  final ProfileRepositoryInterface _profileRepository;

  FirebaseUserToAccountTransformer(this._profileRepository);
  @override
  AccountEntity transform({User? from}) {
    if (from == null) {
      throw StateError('No authenticated user');
    }
    return AccountEntity(from.uid, _profileRepository);
  }
}
