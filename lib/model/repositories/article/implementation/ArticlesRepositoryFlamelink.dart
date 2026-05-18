import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/enums.dart';
import 'package:farmsmart_flutter/model/repositories/article/implementation/FlameLinkMetaTransformer.dart';
import '../../../firebase_const.dart';
import '../../FlameLink.dart';
import '../ArticleRepositoryInterface.dart';
import 'transformers/FirebaseArticleTransformer.dart';

class _Fields {
  static final articleCollection = "articles";
  static final articleEntry = "article";
  static final chatGroupCollection = "chatGroups";
  static final chatGroupEntry = "chatGroup";
  static final articleSchema = "article";
  static final articleDirectoryName = "articleDirectory";
  static final chatGroupDirectoryName = "chatGroupDirectory";
}

ArticleEntity _transform(
    FlameLink cms, DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final transformer = FlamelinkArticleTransformer(
      cms: cms, metaTransformer: FlamelinkMetaTransformer());
  return transformer.transform(from: snapshot);
}

class ArticleEntityCollectionFlamelink
    implements EntityCollection<ArticleEntity> {
  final FlamelinkDocumentCollection _collection;
  final bool _onlyPublished;

  ArticleEntityCollectionFlamelink(
      {required FlamelinkDocumentCollection collection,
      bool onlyPublished = true})
      : _collection = collection,
        _onlyPublished = onlyPublished;

  @override
  Future<List<ArticleEntity>> getEntities({int limit = 0}) {
    return _collection.getDocuments().then((documents) {
      var articles = documents
          .map((document) => _transform(_collection.cms, document))
          .toList();
      if (_onlyPublished) {
        articles.removeWhere((article) {
          return article.status != Status.PUBLISHED;
        });
      }
      return articles;
    });
  }
}

class ArticlesRepositoryFlameLink implements ArticleRepositoryInterface {
  final FlameLink _cms;

  ArticlesRepositoryFlameLink(FlameLink cms) : _cms = cms;

  @override
  Future<ArticleEntity> getArticle(String uri) {
    if (uri.isEmpty) {
      return Future.error(
          ArgumentError.value(uri, 'uri', 'URI cannot be empty'));
    }
    final baseCollection = _cms.content();
    return baseCollection
        .doc(uri)
        .get()
        .then((snapshot) => _transform(_cms, snapshot));
  }

  @override
  Stream<ArticleEntity> observeArticle(String uri) {
    if (uri.isEmpty) {
      return Stream.error(
          ArgumentError.value(uri, 'uri', 'URI cannot be empty'));
    }
    final baseCollection = _cms.content();
    final _typeTransform =
        StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, ArticleEntity>
            .fromHandlers(
            handleData: (snapshot, sink) {
      sink.add(_transform(_cms, snapshot));
    });
    return baseCollection.doc(uri).snapshots().transform(_typeTransform);
  }

  @override
  Future<List<ArticleEntity>> getArticles(
      EntityCollection<ArticleEntity> collection) {
    return collection.getEntities();
  }

  @override
  Future<List<ArticleEntity>> get(
      {ArticleCollectionGroup group = ArticleCollectionGroup.all,
      int limit = 0}) {
    switch (group) {
      case ArticleCollectionGroup.discovery:
        return getDirectory(
            directoryName: _Fields.articleDirectoryName,
            collectionName: _Fields.articleCollection,
            entryName: _Fields.articleEntry);
      case ArticleCollectionGroup.chatGroups:
        return getDirectory(
            directoryName: _Fields.chatGroupDirectoryName,
            collectionName: _Fields.chatGroupCollection,
            entryName: _Fields.chatGroupEntry);
      default:
        final publishedDocuments = _cms
            .documentsQuery(schema: _Fields.articleSchema, limit: limit)
            .where(PUBLICATION_STATUS, isEqualTo: DataStatus.PUBLISHED);
        final collection =
            FlamelinkDocumentCollection(cms: _cms, query: publishedDocuments);
        return ArticleEntityCollectionFlamelink(collection: collection)
            .getEntities();
    }
  }

  Future<List<ArticleEntity>> getDirectory(
      {required String directoryName,
      required String collectionName,
      required String entryName}) {
    return _cms.getSingle(schema: directoryName).then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      final refs = castOrNull<List<dynamic>>(data?[collectionName]) ?? [];
      final paths = refs
          .map((article) =>
              castOrNull<Map<String, dynamic>>(article)?[entryName])
          .whereType<DocumentReference>()
          .map((ref) => ref.path)
          .toList();
      final collection =
          FlamelinkDocumentCollection.list(cms: _cms, paths: paths);
      return ArticleEntityCollectionFlamelink(collection: collection)
          .getEntities();
    });
  }
}
