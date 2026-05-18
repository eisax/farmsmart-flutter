import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/enums.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockDate.dart';

/// Fixed stage articles for a crop (used by mock recommendations and plot detail).
class MockCropStageArticleCollection implements EntityCollection<ArticleEntity> {
  final List<String> _stageTitles;
  final _mockDate = MockDate();

  MockCropStageArticleCollection(this._stageTitles);

  @override
  Future<List<ArticleEntity>> getEntities({int limit = 0}) {
    final titles =
        limit > 0 ? _stageTitles.take(limit).toList() : _stageTitles;
    final articles = titles.map((title) {
      return ArticleEntity(
        uri: 'stage-$title',
        content: '<p>Growing stage: <strong>$title</strong></p>',
        status: Status.PUBLISHED,
        summary: 'Care tips for the $title phase.',
        title: title,
        published: _mockDate.randomMonthAgo(),
      );
    }).toList();
    return Future.value(articles);
  }
}
