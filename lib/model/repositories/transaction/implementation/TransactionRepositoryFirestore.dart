import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';

import 'package:farmsmart_flutter/model/entities/TransactionAmount.dart';

import 'package:farmsmart_flutter/model/entities/TransactionEntity.dart';
import 'package:farmsmart_flutter/model/repositories/FirestoreList.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';

import '../TransactionRepositoryInterface.dart';
import 'TransactionEntityTransformers.dart';

class _Fields {
  static const transactions = "/transactions";
  static const orderField = "timestamp";
}

class _Constants {
  static final initalBalance = TransactionAmount("0", false);
}

String _getURI(TransactionEntity entity) {
  return entity.uri;
}

PathProvider _transactionPathProvider(
    ProfileRepositoryInterface profileRepository) {
  return () {
    return profileRepository.getCurrent().then((profile) {
      return profile.uri + _Fields.transactions;
    });
  };
}

class TransactionRepositoryFirestore extends FireStoreList<TransactionEntity>
    implements TransactionRepositoryInterface {
  final ProfileRepositoryInterface _profileRepository;
  late Future<ProfileEntity> _currentProfile;
  late TransactionAmount _balance;
  StreamSubscription<List<TransactionEntity>>? _balanceSubscription;

  TransactionRepositoryFirestore(
    FirebaseFirestore firestore,
    ProfileRepositoryInterface profileRepository,
  )   : this._profileRepository = profileRepository,
        super(
          firestore,
          TransactionEntityToDocumentTransformer(),
          DocumentToTransactionEntityTransformer(),
          _transactionPathProvider(profileRepository),
          _getURI,
          orderField: _Fields.orderField,
          orderDecending: true,
        ) {
    path = _transactionsCollectionPath;
    _balance = _Constants.initalBalance;
    _currentProfile = _profileRepository.getCurrent().then((profile) {
      _startBalanceSubscription();
      return profile;
    }).catchError((Object _) {
      return _profileRepository.observeCurrent().first.then((profile) {
        _startBalanceSubscription();
        return profile;
      });
    });
    _profileRepository.observeCurrent().listen((profile) {
      _currentProfile = Future.value(profile);
    });
  }

  void _startBalanceSubscription() {
    _balanceSubscription?.cancel();
    _balanceSubscription =
        stream().listen((List<TransactionEntity> transactions) {
      _updateBalance(transactions);
    });
  }

  @override
  Future<TransactionAmount> allTimeBalance() {
    return Future.value(_balance);
  }

  @override
  Future<List<TransactionEntity>> getCollection(
      EntityCollection<TransactionEntity> collection) {
    return collection.getEntities();
  }

  @override
  Future<TransactionEntity> getSingle(String uri) {
    final transformer = DocumentToTransactionEntityTransformer();
    return firestore.doc(uri).get().then((document) {
      return transformer.transform(from: document);
    });
  }

  @override
  Stream<TransactionEntity> observeSingle(String uri) {
    final transformer = DocumentToTransactionEntityTransformer();
    return firestore.doc(uri).snapshots().map((document) {
      return transformer.transform(from: document);
    });
  }

  @override
  Future<TransactionAmount> thisWeekCosts() {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    return get().then((transactions) {
      return transactions
          .where((transaction) =>
              transaction.timestamp.isAfter(weekAgo) &&
              transaction.amount.isCost())
          .map((transaction) => transaction.amount)
          .fold<TransactionAmount>(TransactionAmount('0', false),
              (TransactionAmount a, TransactionAmount b) => a + b);
    });
  }

  @override
  Future<TransactionAmount> thisWeekSales() {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    return get().then((transactions) {
      return transactions
          .where((transaction) =>
              transaction.timestamp.isAfter(weekAgo) &&
              transaction.amount.isSale())
          .map((transaction) => transaction.amount)
          .fold<TransactionAmount>(TransactionAmount('0', false),
              (TransactionAmount a, TransactionAmount b) => a + b);
    });
  }

  Future<String> _transactionsCollectionPath() {
    return _currentProfile.then((profile) {
      return profile.uri + _Fields.transactions;
    });
  }

  void _updateBalance(List<TransactionEntity> transactions) {
    if (transactions.isEmpty) {
      _balance = _Constants.initalBalance;
      return;
    }
    _balance =
        transactions.map((transaction) => transaction.amount).reduce((a, b) {
      return a + b;
    });
  }

  @override
  void dispose() {
    _balanceSubscription?.cancel();
    super.dispose();
  }
}
