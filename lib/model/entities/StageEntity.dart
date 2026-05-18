import 'package:farmsmart_flutter/model/entities/article_entity.dart';

class StageEntity {
  final String id;
  final ArticleEntity article;
  final DateTime? started;
  final DateTime? ended;

  StageEntity({
    required this.id,
    required this.article,
    this.started,
    this.ended,
  });
}
