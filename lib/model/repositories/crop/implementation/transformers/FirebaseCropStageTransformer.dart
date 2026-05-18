import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/enums.dart';
import 'package:farmsmart_flutter/model/repositories/article/implementation/ArticlesRepositoryFlamelink.dart';
import 'package:farmsmart_flutter/model/repositories/article/implementation/FlameLinkMetaTransformer.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/ImageRepositoryFlamelink.dart';

import '../../../FlameLink.dart';
import '../../../FlamelinkMeta.dart';

ArticleEntity _transform(
    FlameLink cms, DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final transformer = FlamelinkCropArticleTransformer(
      cms: cms, metaTransformer: FlamelinkMetaTransformer());
  return transformer.transform(from: snapshot);
}

class CropStageArticleEntityCollectionFlamelink
    implements EntityCollection<ArticleEntity> {
  final FlamelinkDocumentCollection _collection;

  CropStageArticleEntityCollectionFlamelink(
      {FlamelinkDocumentCollection? collection})
      : _collection = collection!;

  @override
  Future<List<ArticleEntity>> getEntities({int limit = 0}) {
    return _collection.getDocuments().then((documents) {
      return documents
          .map((document) => _transform(_collection.cms, document))
          .toList();
    });
  }
}

class _Fields {
  static String content = "content";
  static String status = "status";
  static String summary = "summary";
  static String name = "stageName";
  static String relatedArticles = "relatedArticles";
  static String article = "article";
  static String image = "image";
  static String externalLink = "contentLink";
}

class FlamelinkCropArticleTransformer
    extends ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, ArticleEntity> {
  final ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, FlamelinkMeta> _metaTransformer;
  final FlameLink _cms;

  FlamelinkCropArticleTransformer(
      {required FlameLink cms,
      required ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, FlamelinkMeta>
          metaTransformer})
      : this._cms = cms,
        this._metaTransformer = metaTransformer;

  @override
  ArticleEntity transform({DocumentSnapshot<Map<String, dynamic>>? from}) {
    if (from == null) {
      throw StateError('DocumentSnapshot is null');
    }
    final meta = _metaTransformer.transform(from: from);
    final uri = from.reference.path;
    final data = from.data() as Map<String, dynamic>?;
    final content = castOrNull<String>(data?[_Fields.content]);
    final status = castOrNull<String>(data?[_Fields.status]);
    final summary = castOrNull<String>(data?[_Fields.summary]);
    final name = castOrNull<String>(data?[_Fields.name]) ??
        castOrNull<String>(data?[_Fields.name]);
    final externalLink = castOrNull(data?[_Fields.externalLink]);
    final published = meta.createdDate?.toDate();
    final entity = ArticleEntity(
        uri: uri,
        content: content,
        status: statusValues.map[status],
        summary: summary,
        title: name,
        published: published,
        externalLink: externalLink);
    final relatedRefs = _relatedRefs(data);
    final imageRefs = <String>[];
    final imageField = castOrNull<List<dynamic>>(data?[_Fields.image]);
    if (imageField != null) {
      imageRefs.addAll(imageField.map((image) {
        final ref = castOrNull<DocumentReference>(
            castOrNull<Map<String, dynamic>>(image)?['path']);
        return ref?.path;
      }).whereType<String>());
    }
    final relatedPaths = List<String>.from(relatedRefs);
    final imagePaths = List<String>.from(imageRefs);

    final articleCollection =
        FlamelinkDocumentCollection.list(cms: _cms, paths: relatedPaths);
    final imageCollection =
        FlamelinkDocumentCollection.list(cms: _cms, paths: imagePaths);
    entity.related =
        ArticleEntityCollectionFlamelink(collection: articleCollection);
    entity.images = imageRefs.isNotEmpty
        ? ImageEntityCollectionFlamelink(collection: imageCollection)
        : null;
    return entity;
  }

  List<String> _relatedRefs(Map<String, dynamic>? data) {
    return _related(
      data,
      _Fields.relatedArticles,
      _Fields.article,
    );
  }

  List<String> _related(
      Map<String, dynamic>? data, String collectionName, String itemName) {
    final collection = castOrNull<List<dynamic>>(data?[collectionName]);
    if (collection == null) {
      return [];
    }
    return collection
        .map((item) {
          final documentRef = castOrNull<DocumentReference>(
              castOrNull<Map<String, dynamic>>(item)?[itemName]);
          return documentRef?.path;
        })
        .whereType<String>()
        .toList();
  }
}
