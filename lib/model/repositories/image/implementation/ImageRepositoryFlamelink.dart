import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/ImageEntity.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';

import '../../FlameLink.dart';
import '../ImageRepositoryInterface.dart';

class ImageEntityFields {
  static String sizes = "sizes";
  static String width = "width";
  static String height = "height";
  static String path = "path";
  static String file = "file";
}

class _Strings {
  static const sizesFolder = "sized";
  static const pathDivider = "/";
}

class _Constants {
  static const int unkownSize = 0;
}

class _NullImageProvider implements ImageURLProvider {
  @override
  Future<String> urlToFit({double width = 0, double height = 0}) {
    return Future.error(StateError('No image provider available yet'));
  }

  @override
  String cacheIdentifier({double width = 0, double height = 0}) {
    return ImageURLProvider.sizeIdentifier(width: width, height: height);
  }

  @override
  String cachedUrlToFit({double width = 0, double height = 0}) {
    return '';
  }
}

class FlamelinkImageEntity extends ImageEntity {
  final FlameLink _cms;
  final List<ImageEntity> otherSizes;
  FlamelinkImageEntity(FlameLink cms, int width, int height, String path,
      List<ImageEntity> otherSizes)
      : this._cms = cms,
        this.otherSizes = otherSizes,
        super(width, height, path, _NullImageProvider()) {
    this.urlProvider = FlameLinkImageProvider(_cms, this);
  }
}

ImageEntity _transform(
    FlameLink cms, DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final data = snapshot.data() as Map<String, dynamic>?;
  final imageFileNamePath =
      castOrNull<String>(data?[ImageEntityFields.file]) ?? '';
  if (data == null) {
    return FlamelinkImageEntity(
        cms, _Constants.unkownSize, _Constants.unkownSize, '', []);
  }

  final sizes = castOrNull<List<dynamic>>(data[ImageEntityFields.sizes]) ?? [];
  final alternateSizesObjs = sizes.map((imageSize) {
    final sizeData = castOrNull<Map<String, dynamic>>(imageSize) ?? {};
    final path = _Strings.sizesFolder +
        _Strings.pathDivider +
        (castOrNull<String>(sizeData[ImageEntityFields.path]) ?? '') +
        _Strings.pathDivider +
        imageFileNamePath;
    final width = castOrNull<int>(sizeData[ImageEntityFields.width]) ?? 0;
    final height = castOrNull<int>(sizeData[ImageEntityFields.height]) ?? 0;
    return FlamelinkImageEntity(cms, width, height, path, []);
  }).toList();
  final alternateSizes = List<ImageEntity>.from(alternateSizesObjs);
  return FlamelinkImageEntity(cms, _Constants.unkownSize, _Constants.unkownSize,
      imageFileNamePath, alternateSizes);
}

class FlameLinkImageProvider implements ImageURLProvider {
  final FlameLink _cms;
  final FlamelinkImageEntity _entity;
  FlameLinkImageProvider(FlameLink cms, FlamelinkImageEntity entity)
      : _cms = cms,
        _entity = entity;

  @override
  Future<String> urlToFit({double width = 0, double height = 0}) {
    if (_entity.path.isEmpty) {
      return Future.error(StateError('Image path is empty'));
    }
    final originalImage = _cms.images(path: _entity.path);
    if (width != double.infinity) {
      final targetWidth = width.toInt();
      var alternateImages = _entity.otherSizes;
      alternateImages.sort((a, b) {
        return a.width.compareTo(b.width);
      });

      for (var image in alternateImages) {
        if (image.width >= targetWidth) {
          return _cms.images(path: image.path).getDownloadURL().then((value) {
            cacheURL(value, cacheIdentifier(width: width, height: height));
            return value;
          });
        }
      }
    }
    return originalImage.getDownloadURL().then((value) {
      final url = value.toString();
      cacheURL(url, cacheIdentifier(height: height, width: width));
      return url;
    });
  }

  @override
  String cacheIdentifier({double width = 0, double height = 0}) {
    return _entity.path +
        ImageURLProvider.sizeIdentifier(
          width: width,
          height: height,
        );
  }

  @override
  String cachedUrlToFit({double width = 0, double height = 0}) {
    return cachedURL(cacheIdentifier(width: width, height: height));
  }
}

class ImageEntityCollectionFlamelink implements EntityCollection<ImageEntity> {
  final FlamelinkDocumentCollection _collection;

  ImageEntityCollectionFlamelink(
      {required FlamelinkDocumentCollection collection})
      : _collection = collection;

  @override
  Future<List<ImageEntity>> getEntities({int limit = 0}) {
    return _collection.getDocuments().then((documents) {
      return documents
          .map((document) => _transform(_collection.cms, document))
          .toList();
    });
  }
}

class ImageRepositoryFlameLink implements ImageRepositoryInterface {
  final FlameLink _cms;

  ImageRepositoryFlameLink(FlameLink cms) : _cms = cms;

  @override
  Future<ImageEntity> get(String uri) {
    if (uri.isEmpty) {
      return Future.error(
          ArgumentError.value(uri, 'uri', 'URI cannot be empty'));
    }
    final baseCollection = _cms.files();
    return baseCollection
        .doc(uri)
        .get()
        .then((snapshot) => _transform(_cms, snapshot));
  }

  @override
  Future<List<ImageEntity>> getImages(List<String> paths) {
    final collection =
        FlamelinkDocumentCollection.list(cms: _cms, paths: paths);
    return ImageEntityCollectionFlamelink(collection: collection).getEntities();
  }

  @override
  Stream<ImageEntity> observe(String uri) {
    if (uri.isEmpty) {
      return Stream.error(
          ArgumentError.value(uri, 'uri', 'URI cannot be empty'));
    }
    final baseCollection = _cms.files();
    final _typeTransform =
        StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, ImageEntity>
            .fromHandlers(
            handleData: (snapshot, sink) {
      sink.add(_transform(_cms, snapshot));
    });
    return baseCollection.doc(uri).snapshots().transform(_typeTransform);
  }

  @override
  Future<String> getURL(ImageEntity image) {
    final storageReference = _cms.images(path: image.path);
    return storageReference.getDownloadURL();
  }
}
