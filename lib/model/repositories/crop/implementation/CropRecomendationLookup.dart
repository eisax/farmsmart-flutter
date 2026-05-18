import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/repositories/FlameLink.dart';

class _Fields {
  static const cropName = "cropName";
  static const score = "score";
  static const identifier = "cmsCropId";
}

class _Constants {
  static const lookupCollection = "/fs_crop_score_cms_link";
  static const pathDivider = "/";
}

class CropRecommendationLookup {
  final FlameLink _flameLink;

  CropRecommendationLookup(this._flameLink);

  Future<Map<String, String>> lookupTable() {
    final contentPath = _flameLink.content().path + _Constants.pathDivider;
    return _flameLink.store
        .collection(_Constants.lookupCollection)
        .get()
        .then((snapshot) {
      return snapshot.docs.asMap().map((_, document) {
        return MapEntry(
            contentPath + _identifier(document), _recomendationName(document));
      });
    });
  }

  String _identifier(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return castOrNull<String>(data?[_Fields.identifier]) ?? '';
  }

  String _recomendationName(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    final score = data?[_Fields.score];
    final cropname = data?[_Fields.cropName];
    return castOrNull<String>(score ?? cropname) ?? '';
  }
}
