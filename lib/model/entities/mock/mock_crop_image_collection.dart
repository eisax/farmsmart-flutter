import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/ImageEntity.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/PathImageProvider.dart';

class MockCropImageCollection implements EntityCollection<ImageEntity> {
  final String _imageUrl;

  MockCropImageCollection(this._imageUrl);

  @override
  Future<List<ImageEntity>> getEntities({int limit = 0}) {
    return Future.value([
      ImageEntity(400, 300, _imageUrl, PathImageProvider(_imageUrl)),
    ]);
  }
}
