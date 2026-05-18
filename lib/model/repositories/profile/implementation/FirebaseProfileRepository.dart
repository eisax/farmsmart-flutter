import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:farmsmart_flutter/model/repositories/FirestoreList.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ProfileEntityTransformers.dart';

class _Fields {
  static const collectionName = "fs_users";
  static const profiles = "profiles";
  static const currentProfile = "currentProfile";
  static const separator = "/";
}

String _identify(ProfileEntity entity) {
  return entity.uri;
}

Future<String> _uninitializedPath() {
  throw StateError('Profile repository path not initialized');
}

class FirebaseProfileRepository extends FireStoreList<ProfileEntity>
    implements ProfileRepositoryInterface {
  final FirebaseAuth _auth;
  final _currentProfileController = StreamController<ProfileEntity>.broadcast();

  late Future<User?> _user;
  FirebaseProfileRepository(
    FirebaseFirestore firestore,
    FirebaseAuth auth,
  )   : _auth = auth,
        super(
          firestore,
          ProfileEntityToDocumentTransformer(),
          DocumentToProfileEntityTransformer(),
          _uninitializedPath,
          _identify,
        ) {
    path = profilesCollectionPath;
    init();
  }

  void init() {
    _user = Future.value(_auth.currentUser);
    _auth.authStateChanges().listen((user) {
      _user = Future.value(user);
    });
  }

  @override
  Future<List<ProfileEntity>> getCollection(
      EntityCollection<ProfileEntity> collection) {
    return collection.getEntities();
  }

  @override
  Future<ProfileEntity> getCurrent() {
    return _user.then((user) async {
      if (user == null) {
        throw StateError('No authenticated user');
      }
      final userDocument = await firestore.doc(_userPath(user)).get();
      final userData = userDocument.data();
      if (userData != null) {
        final profileURI = userData[_Fields.currentProfile] as String?;
        if (profileURI != null) {
          final profileDocument = await firestore.doc(profileURI).get();
          return _updateWith(profileDocument);
        }
      }
      throw StateError('No current profile');
    });
  }

  ProfileEntity _updateWith(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final profile = fromFirestoreTransformer.transform(from: document);
      _currentProfileController.sink.add(profile);
      return profile;
    }
    throw StateError('Profile document has no data');
  }

  @override
  Future<ProfileEntity> updateCurrent(ProfileEntity updated) {
    return _user.then((user) async {
      if (user == null) {
        throw StateError('No authenticated user');
      }
      final firebaseObject = toFirestoreTransformer.transform(from: updated);
      final profileURI = updated.uri;
      await firestore.doc(profileURI).set(firebaseObject);
      final document = await firestore.doc(profileURI).get();
      return _updateWith(document);
    });
  }

  @override
  Future<ProfileEntity> getSingle(String uri) {
    return firestore.doc(uri).get().then((document) {
      return fromFirestoreTransformer.transform(from: document);
    });
  }

  @override
  Stream<ProfileEntity> observeSingle(String uri) {
    return firestore.doc(uri).snapshots().map((document) {
      return fromFirestoreTransformer.transform(from: document);
    });
  }

  @override
  Stream<ProfileEntity> observeCurrent() {
    return _currentProfileController.stream;
  }

  @override
  Future<bool> switchTo(ProfileEntity profile) {
    return _user.then((user) async {
      if (user == null) {
        return false;
      }
      final data = {_Fields.currentProfile: profile.uri};
      await firestore.doc(_userPath(user)).set(data);
      _currentProfileController.sink.add(profile);
      return true;
    }).catchError((_) => false);
  }

  String _userPath(User user) {
    return _Fields.collectionName + _Fields.separator + user.uid;
  }

  Future<String> profilesCollectionPath() {
    return _user.then((user) {
      if (user == null) {
        throw StateError('No authenticated user');
      }
      return _userPath(user) + _Fields.separator + _Fields.profiles;
    });
  }

  void deinit() {
    _currentProfileController.sink.close();
    _currentProfileController.close();
  }
}
