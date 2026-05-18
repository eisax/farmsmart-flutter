import 'package:farmsmart_flutter/model/entities/crop_entity.dart';
import 'StageEntity.dart';

class PlotEntity {
  final String uri;
  final String title;
  final CropEntity crop;
  final double score;
  final List<StageEntity> stages;

  PlotEntity({
    required String uri,
    required String title,
    required CropEntity crop,
    required double score,
    required List<StageEntity> stages,
  })  : this.uri = uri,
        this.title = title,
        this.crop = crop,
        this.score = score,
        this.stages = stages;
}
