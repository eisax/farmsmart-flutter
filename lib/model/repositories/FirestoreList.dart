import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';

typedef PathProvider = Future<String> Function();
typedef ObjectIdentifier<T> = String Function(T object);

class FireStoreList<T> {
  final FirebaseFirestore firestore;
  final ObjectTransformer<T, Map<String, dynamic>> toFirestoreTransformer;
  final ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, T>
      fromFirestoreTransformer;
  final String? orderField;
  final bool orderDecending;
  final List<T> _emptyList = [];
  PathProvider path;
  String? _currentPath;
  ObjectIdentifier<T> resourceIdentifier;
  StreamController<List<T>>? _listController;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  FireStoreList(this.firestore, this.toFirestoreTransformer,
      this.fromFirestoreTransformer, this.path, this.resourceIdentifier,
      {this.orderField, this.orderDecending = false});

  Future<T> add(T object) {
    return path().then((collectionPath) {
      final firestoreObject = toFirestoreTransformer.transform(from: object);
      return firestore
          .collection(collectionPath)
          .add(firestoreObject)
          .then((result) {
        return result.get().then((document) {
          return fromFirestoreTransformer.transform(from: document);
        });
      });
    });
  }

  Future<bool> remove(T object) {
    return path().then((collectionPath) {
      final documentPath = resourceIdentifier(object);
      return firestore.doc(documentPath).delete().then((response) {
        return true;
      }, onError: (error) {
        return false;
      });
    });
  }

  Stream<List<T>> stream() {
    if (_listController == null) {
      _listController = StreamController<List<T>>.broadcast();
    }
    renewSubscriptionIfNeeded();
    return _listController!.stream;
  }

  Future<List<T>> get() {
    return path().then((collectionPath) {
      return _fetch(collectionPath);
    });
  }

  Future<List<T>> _fetchAndOrder(String collectionPath) {
    return _orderedCollection(
      collectionPath,
      orderField!,
      descending: orderDecending,
    ).get().then((snapshot) {
      return _update(snapshot);
    }, onError: (error) {
      return _emptyList;
    });
  }

  Future<List<T>> _fetch(String collectionPath) {
    if (orderField != null) {
      return _fetchAndOrder(collectionPath);
    } else {
      return firestore.collection(collectionPath).get().then((snapshot) {
        return _update(snapshot);
      }, onError: (error) {
        return _emptyList;
      });
    }
  }

  void renewSubscriptionIfNeeded() {
    path().then((collectionPath) {
      if (collectionPath != _currentPath) {
        _subscription?.cancel();
        _subscription = _subscribe(collectionPath);
        _currentPath = collectionPath;
      }
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _subscribeAndOrder(
      String collectionPath) {
    return _orderedCollection(
      collectionPath,
      orderField!,
      descending: orderDecending,
    ).snapshots().listen((snapshot) {
      _update(snapshot);
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _subscribe(
      String collectionPath) {
    if (orderField != null) {
      return _subscribeAndOrder(collectionPath);
    }
    return firestore.collection(collectionPath).snapshots().listen((snapshot) {
      _update(snapshot);
    });
  }

  List<T> _update(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final newValue = _transformCollection(snapshot);
    if (_listController != null) {
      _listController!.sink.add(newValue);
    }
    return newValue;
  }

  Query<Map<String, dynamic>> _orderedCollection(
    String path,
    String field, {
    bool descending = false,
  }) {
    return firestore.collection(path).orderBy(
          field,
          descending: descending,
        );
  }

  List<T> _transformCollection(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((document) {
      return fromFirestoreTransformer.transform(from: document);
    }).toList();
  }

  void dispose() {
    if (_listController != null) {
      _listController!.sink.close();
      _listController!.close();
    }
  }
}
