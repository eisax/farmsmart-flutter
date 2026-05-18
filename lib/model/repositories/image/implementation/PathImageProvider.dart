import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';

class PathImageProvider implements ImageURLProvider {
  final String _path;

  PathImageProvider(this._path);
  @override
  Future<String> urlToFit({double width = 0, double height = 0}) {
    return Future.value(cachedUrlToFit(width: width, height: height));
  }

  @override
  String cacheIdentifier({double width = 0, double height = 0}) {
    return _path +
        ImageURLProvider.sizeIdentifier(
          width: width,
          height: height,
        );
  }

  @override
  String cachedUrlToFit({double width = 0, double height = 0}) {
    return _path;
  }
}
