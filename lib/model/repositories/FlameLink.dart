import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlameLinkSchemaType {
  static String single = "single";
}

class FlameLinkFileType {
  static String images = "images";
}

class FlameLinkFileFields {
  static String type = "type";
  static String contentType = "contentType";
  static String name = "file";
}

class FlameLinkDocumentFields {
  static String schema = '_fl_meta_.schema';
  static String type = "_fl_meta_.schemaType";
  static String env = '_fl_meta_.env';
  static String locale = '_fl_meta_.locale';
}

class _Strings {
  static const flamelinkDivider = "-";
  static const flutterLocaleDivider = "_";
}

class FlameLink {
  static const _contentCollectionName = 'fl_content';
  static const _fileCollectionName = 'fl_files';
  static const _storageBasePath = "/flamelink";
  static const _imageBasePath = "media";
  final FirebaseFirestore store;
  final String _environment;
  final Locale _locale;

  FlameLink({
    required FirebaseFirestore store,
    required String environment,
    required Locale locale,
  })  : store = store,
        _environment = environment,
        _locale = locale;

  CollectionReference<Map<String, dynamic>> content() {
    return store.collection(_contentCollectionName);
  }

  CollectionReference<Map<String, dynamic>> files() {
    return store.collection(_fileCollectionName);
  }

  Reference storage({required String path}) {
    final flamelinkPath = _storageBasePath + '/' + path;
    return FirebaseStorage.instance.ref().child(flamelinkPath);
  }

  Reference images({required String path}) {
    return storage(path: _imageBasePath + '/' + path);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSingle(
      {required String schema}) {
    return documentQuery(schema: schema).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return Future.error("Empty");
      }
      return snapshot.docs.first;
    });
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> get(
      List<String> paths) {
    final fetchRequests = paths.map((path) => store.doc(path).get());
    return Future.wait(fetchRequests);
  }

  Query<Map<String, dynamic>> fileQuery({String type = ""}) {
    Query<Map<String, dynamic>> query =
        files().where(FlameLinkFileFields.type, isEqualTo: type);
    return query;
  }

  Query<Map<String, dynamic>> documentQuery({String schema = ""}) {
    Query<Map<String, dynamic>> query = documentsQuery(schema: schema, limit: 1)
        .where(FlameLinkDocumentFields.type,
            isEqualTo: FlameLinkSchemaType.single);
    return query;
  }

  Query<Map<String, dynamic>> documentsQuery({String schema = "", int limit = 0}) {
    final locale = _serverFormatLocale();
    var query = content()
        .where(FlameLinkDocumentFields.locale, isEqualTo: locale)
        .where(FlameLinkDocumentFields.env, isEqualTo: _environment)
        .where(FlameLinkDocumentFields.schema, isEqualTo: schema);
    if (limit > 0) {
      query = query.limit(limit);
    }
    return query;
  }

  String _serverFormatLocale() {
    final serverFormat = _locale.languageCode +
        _Strings.flamelinkDivider +
        (_locale.countryCode ?? '');
    return serverFormat.toLowerCase();
  }
}

class FlamelinkDocumentCollection {
  final FlameLink _cms;
  final Query<Map<String, dynamic>>? _query;
  final List<String> _paths;

  FlamelinkDocumentCollection({required FlameLink cms, required Query<Map<String, dynamic>> query})
      : _cms = cms,
        _query = query,
        _paths = [];

  FlamelinkDocumentCollection.list(
      {required FlameLink cms, required List<String> paths})
      : _cms = cms,
        _paths = paths,
        _query = null;

  factory FlamelinkDocumentCollection.fromDocumentReferences({
    required FlameLink cms,
    required List<dynamic> paths,
  }) {
    final refs = List<String>.from(paths.map((doc) => doc.path as String)).toList();
    return FlamelinkDocumentCollection.list(cms: cms, paths: refs);
  }

  factory FlamelinkDocumentCollection.fromObjectReferences({
    required FlameLink cms,
    required List<dynamic> objectReferences,
    required String linkField,
  }) {
    final paths = List<dynamic>.from(objectReferences.map((refObject) {
      return refObject[linkField];
    })).toList();
    return FlamelinkDocumentCollection.fromDocumentReferences(
        cms: cms, paths: paths);
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getDocuments(
      {int limit = 0}) {
    if (_paths.isNotEmpty) {
      return _cms.get(_paths).then((snapshots) {
        return snapshots.toList();
      });
    } else if (_query != null) {
      return _query!.get().then((snapshot) {
        return snapshot.docs.toList();
      });
    }
    return Future.value([]);
  }

  FlameLink get cms {
    return _cms;
  }
}
