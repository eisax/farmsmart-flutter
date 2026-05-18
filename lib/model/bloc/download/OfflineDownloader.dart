import 'dart:async';

import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/crop_entity.dart';
import 'package:farmsmart_flutter/model/repositories/article/ArticleLinkExtractor.dart';
import 'package:farmsmart_flutter/model/repositories/article/ArticleRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/crop/CropRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/ratingEngine/RatingEngineRepositoryInterface.dart';
import 'package:flutter/material.dart';

import 'ApplicationCache.dart';

class DownloadProgress {
  final double progress;
  final Object? error;

  DownloadProgress(this.progress, this.error);
}

final imageSizes = [Size(double.infinity, 192.0),Size(double.infinity, 152.0), Size(80.0, 80.0),Size(72.0, 72.0)];

class OfflineDownloader {
  final _cacheManager = OfflineCacheManager();
  final ArticleRepositoryInterface _articleRepo;
  final CropRepositoryInterface _cropRepo;
  final RatingEngineRepositoryInterface _ratingRepo;

  StreamController<DownloadProgress> _controller =
      StreamController<DownloadProgress>.broadcast();

  OfflineDownloader(this._articleRepo, this._cropRepo, this._ratingRepo);

  Stream<DownloadProgress> dowloadImages({
    required List<ImageURLProvider> imageURls,
    Function? complete,
  }) {
    int taskCount = imageURls.length * imageSizes.length;
    int completeTasks = 0;
    List<Future> futures = [];
    for (var urlProvider in imageURls) {
      for (var imageSize in imageSizes) {
        futures.add(urlProvider
            .urlToFit(width: imageSize.width, height: imageSize.height)
            .then((url) {
             if(url.isEmpty){ 
                completeTasks++;
                _controller
                .add(DownloadProgress(completeTasks / taskCount, null));
               return  Future.value();
              }
          return _cacheManager.getSingleFile(url).then((file) {
            completeTasks++;
            _controller
                .add(DownloadProgress(completeTasks / taskCount, null));
          }, onError: (error) {
            completeTasks++;
            _controller
                .add(DownloadProgress(completeTasks / taskCount, error));
          });
        }, onError: (error){ 
           completeTasks++;
            _controller
                .add(DownloadProgress(completeTasks / taskCount, error));
        }));
      }
    }
    Future.wait(futures).then((_) {
      complete?.call();
    });
    return _controller.stream;
  }

  Stream<DownloadProgress> downloadAll({Function? complete}) {
    _ratingRepo.getRatingInfo();
    _articleRepo.get().then((articles) {
      List<ImageURLProvider> articleImageProviders = [];

      final articleUrls = articles.map((article) {
            final extractor = HTMLLinkExtractor(article.content ?? '');
                    extractor.imageProviders().forEach((provider) => articleImageProviders.add(provider));
            return ArticleImageProvider(article);
          } ).toList();
      articleImageProviders += articleUrls;
      _articleRepo
          .get(group: ArticleCollectionGroup.chatGroups)
          .then((chatGroupArticles) {
        articleImageProviders += chatGroupArticles
            .map((article) => ArticleImageProvider(article)).toList();
        _cropRepo.get().then((crops) {
          final List<Future> stages = [];
          final List<ImageURLProvider> cropImageProviders = [];
              crops.forEach((crop) {
                cropImageProviders.add(CropImageProvider(crop));
                final stageArticles = crop.stageArticles?.getEntities().then((stageList)
                {
                  for (var stage in stageList) {
                    final extractor = HTMLLinkExtractor(stage.content ?? '');
                    extractor.imageProviders().forEach((provider) => cropImageProviders.add(provider));
                    cropImageProviders.add(ArticleImageProvider(stage));
                  }
                });
                if(stageArticles != null) {
                  stages.add(stageArticles);
                }                
              }) ;
            Future.wait(stages).then((_){
                dowloadImages(
              imageURls: articleImageProviders +
                  cropImageProviders, complete: complete);
            });
        });
      });
    });
    return _controller.stream;
  }


}
