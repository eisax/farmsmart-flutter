import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:path_provider/path_provider.dart';

class _Fields {
  static const name = "name";
  static const plotInfo = "plotInfo";
}

class _Constants {
  static final avatarPathSuffix = '_avatar.jpg';
}

class LocalProfileImageProvider implements ImageURLProvider {
  final String id;

  LocalProfileImageProvider(this.id);

  @override
  Future<String> urlToFit({double width = 0, double height = 0}) {
    return localAvatarPath(id);
  }

  static Future<String> localAvatarPath(String id) {
    return getApplicationDocumentsDirectory().then((directory) {
      return '${directory.path}/${id}_${_Constants.avatarPathSuffix}';
    });
  }

  @override
  String cacheIdentifier({double width = 0, double height = 0}) {
    return id +
        ImageURLProvider.sizeIdentifier(width: width, height: height);
  }

  @override
  String cachedUrlToFit({double width = 0, double height = 0}) {
    return '';
  }
}

class DocumentToProfileEntityTransformer
    extends ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, ProfileEntity> {
  @override
  ProfileEntity transform({DocumentSnapshot<Map<String, dynamic>>? from}) {
    if (from == null) {
      throw ArgumentError.notNull('from');
    }
    final data = from.data();
    final name = castOrNull<String>(data?[_Fields.name]);
    final plotInfo = _getPlotInfoData(data?[_Fields.plotInfo]);
    final uri = castOrNull<String>(from.reference.path) ?? '';
    final id = from.id;
    return ProfileEntity(
      id,
      uri,
      name ?? '',
      LocalProfileImageProvider(id),
      plotInfo,
    );
  }

  Map<String, Map<String, String>> _getPlotInfoData(dynamic data) {
    Map<String, Map<String, String>> responseMap = {};
    if (data == null) {
      return responseMap;
    }
    (data as Map).forEach((key, value) {
      final castKey = castOrNull<String>(key);
      if (castKey != null) {
        responseMap[castKey] = castMapOrNull<String, String>(value);
      }
    });
    return responseMap;
  }
}

class ProfileEntityToDocumentTransformer
    extends ObjectTransformer<ProfileEntity, Map<String, dynamic>> {
  @override
  Map<String, dynamic> transform({ProfileEntity? from}) {
    if (from == null) {
      throw ArgumentError.notNull('from');
    }
    return {
      _Fields.name: from.name,
      _Fields.plotInfo: from.lastPlotInfo,
    };
  }
}
