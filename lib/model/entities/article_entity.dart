import 'package:farmsmart_flutter/model/entities/ImageEntity.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/repositories/image/ImageRepositoryInterface.dart';

import 'EntityCollectionInterface.dart';
import 'enums.dart';

class ArticleEntity {
  String? uri;
  String? content;
  EntityCollection<ImageEntity>? images;
  EntityCollection<ArticleEntity>? related;
  Status? status;
  String? summary;
  String? title;
  DateTime? published;
  String? externalLink;

  ArticleEntity({
    this.uri,
    this.content,
    this.images,
    this.related,
    this.status,
    this.summary,
    this.title,
    this.published,
    this.externalLink,
  });
}

// LH this is to make getting the main article image easier
// if we want to get more images from an article, we can get the image entities
// and use their ImageEntityURLProvider
class ArticleImageProvider implements ImageURLProvider {
  final ArticleEntity _article;

  ArticleImageProvider(ArticleEntity article) : _article = article;

  @override
  Future<String> urlToFit({double width = 0, double height = 0}) {
    if (_article.images == null) {
      return Future.value('');
    }

    return _article.images!.getEntities(limit: 1).then((imageEntities) {
      if (imageEntities.isEmpty) {
        return '';
      }
      return imageEntities.first.urlProvider
          .urlToFit(
        width: width,
        height: height,
      )
          .then((url) {
        if (url.isNotEmpty) {
          cacheURL(
            url,
            cacheIdentifier(width: width, height: height),
          );
        }
        return url;
      });
    });
  }

  @override
  String cachedUrlToFit({double width = 0, double height = 0}) {
    return cachedURL(
          cacheIdentifier(width: width, height: height),
        ) ??
        '';
  }

  @override
  String cacheIdentifier({double width = 0, double height = 0}) {
    return (_article.uri ?? '') +
        ImageURLProvider.sizeIdentifier(
          width: width,
          height: height,
        );
  }
}
