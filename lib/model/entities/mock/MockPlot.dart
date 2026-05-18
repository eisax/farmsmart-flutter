import 'dart:math';

import 'package:farmsmart_flutter/model/entities/crop_entity.dart';

import '../PlotEntity.dart';
import 'MockCrop.dart';
import 'MockEntity.dart';
import 'MockStage.dart';
import 'MockString.dart';

MockString _identifiers = MockString();
MockStage _mockStage = MockStage();

class MockPlotEntity extends MockEntity<PlotEntity> {
  final Random _rand;
  final int _maxStages= 10;

  MockPlotEntity({int seed = 0}) : _rand = Random(seed);

  PlotEntity build() {
    final crop = MockCrop.build();
    return buildSync(crop, inProgress: _rand.nextBool());
  }

  /// Synchronous plot for mock seed data and tests.
  PlotEntity buildSync(CropEntity crop, {bool inProgress = true}) {
    final start = DateTime.now().subtract(const Duration(days: 48));
    final end = DateTime.now().subtract(const Duration(days: 4));
    return PlotEntity(
      uri: 'plot-${crop.uri}',
      title: crop.name ?? '',
      crop: crop,
      score: 0.5,
      stages: _mockStage.sequence(
        starting: start,
        ending: end,
        inProgress: inProgress,
        count: 4,
      ),
    );
  }

  Future<PlotEntity> buildWith(CropEntity crop) {
    final stageArticles = crop.stageArticles;
    if (stageArticles == null) {
      return Future.value(build());
    }
    return stageArticles.getEntities(limit: _rand.nextInt(_maxStages)).then((articles) {
        final stages = articles.map((article) {
            return MockStage().buildNewFromArticle(article);
        }).toList();
        return PlotEntity(
        uri: _identifiers.identifier(),
        title: crop.name ?? '',
        crop: crop,
        score: 0.5,
        stages: stages);
    });        
    
  }
}
