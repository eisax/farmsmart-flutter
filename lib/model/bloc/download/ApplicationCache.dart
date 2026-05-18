import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class OfflineCacheManager extends CacheManager {
  static const key = "offlineCachedImageData";

  static OfflineCacheManager? _instance;

  factory OfflineCacheManager() {
    _instance ??= OfflineCacheManager._();
    return _instance!;
  }

  OfflineCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 365),
          maxNrOfCacheObjects: 4096,
        ));

  Future<String> getFilePath() async {
    var directory = await getApplicationSupportDirectory();
    return p.join(directory.path, key);
  }
}
