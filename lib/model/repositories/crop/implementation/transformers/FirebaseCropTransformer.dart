import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/crop_entity.dart';
import 'package:farmsmart_flutter/model/entities/enums.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/ImageRepositoryFlamelink.dart';

import '../../../FlameLink.dart';
import '../../../FlamelinkMeta.dart';
import 'FirebaseCropStageTransformer.dart';

class _Fields {
  static String status = "status";
  static String summary = "summary";
  static String name = "name";
  static String image = "image";
  static String stages = "stages";
  static String stage = "cropStage";
  static String type = "type";

  static String companionPlants = "companionPlants";
  static String nonCompanionPlants = "nonCompanionPlants";
  static String soilTypes = "soilType";
  static String complexity = "complexity";
  static String watering = "waterRequirement";
  static String cost = "setupCost";
  static String profitability = "profitability";
}

class FlamelinkCropTransformer
    extends ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, CropEntity> {
  final ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, FlamelinkMeta> _metaTransformer;
  final FlameLink _cms;

  FlamelinkCropTransformer(
      {required FlameLink cms,
      required ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, FlamelinkMeta>
          metaTransformer})
      : this._cms = cms,
        this._metaTransformer = metaTransformer;

  @override
  CropEntity transform({DocumentSnapshot<Map<String, dynamic>>? from}) {
    if (from == null) {
      throw StateError('DocumentSnapshot is null');
    }
    final meta = _metaTransformer.transform(from: from);
    final uri = from.reference.path;
    final data = from.data() as Map<String, dynamic>?;
    final statusString = castOrNull<String>(data?[_Fields.status]);
    final summary = castOrNull<String>(data?[_Fields.summary]);
    final name = castOrNull<String>(data?[_Fields.name]);
    final companionPlants =
        castListOrNull<String>(data?[_Fields.companionPlants]);
    final nonCompanionPlants =
        castListOrNull<String>(data?[_Fields.nonCompanionPlants]);
    final soilTypes = castListOrNull<String>(data?[_Fields.soilTypes]);
    final complexity =
        _cropComplexity(castOrNull<String>(data?[_Fields.complexity]));
    final watering = _lowHigh(castOrNull<String>(data?[_Fields.watering]));
    final type = _cropType(castOrNull<String>(data?[_Fields.type]));
    final cost = _lowHigh(castOrNull<String>(data?[_Fields.cost]));
    final profitability =
        _lowHigh(castOrNull<String>(data?[_Fields.profitability]));
    final published = meta.createdDate?.toDate();
    final imageRefs = data?[_Fields.image];
    final stageRefs = data?[_Fields.stages];
    ImageEntityCollectionFlamelink? imageCollection;
    CropStageArticleEntityCollectionFlamelink? stageCollection;

    if (imageRefs != null) {
      imageCollection = ImageEntityCollectionFlamelink(
          collection: FlamelinkDocumentCollection.fromDocumentReferences(
        cms: _cms,
        paths: imageRefs,
      ));
    }

    if (stageRefs != null) {
      stageCollection = CropStageArticleEntityCollectionFlamelink(
          collection: FlamelinkDocumentCollection.fromObjectReferences(
              cms: _cms,
              objectReferences: stageRefs,
              linkField: _Fields.stage));
    }
    final status = statusValues.map[statusString];
    final article = ArticleEntity(
      uri: uri,
      title: name,
      status: status,
      summary: summary,
      content: summary, //LH crops don´t have content
      published: published,
    );
    article.images = imageCollection;
    final crop = CropEntity(
        uri: uri,
        status: status,
        name: name,
        cropType: type,
        article: article,
        companionPlants: companionPlants,
        nonCompanionPlants: nonCompanionPlants,
        soilType: soilTypes,
        complexity: complexity,
        waterRequirement: watering,
        setupCost: cost,
        profitability: profitability);
    crop.images = imageCollection;
    crop.stageArticles = stageCollection;
    return crop;
  }

  CropComplexity _cropComplexity(String? value) {
    final defaultValue = CropComplexity.UNDEFINED;
    if (value == null) {
      return defaultValue;
    }
    return begAdvValues.map[value] ?? defaultValue;
  }

  LoHi _lowHigh(String? value) {
    final defaultValue = LoHi.UNDEFINED;
    if (value == null) {
      return defaultValue;
    }
    return loHiValues.map[value] ?? defaultValue;
  }

  CropType _cropType(String? value) {
    final defaultValue = CropType.SINGLE;
    if (value == null) {
      return defaultValue;
    }
    return cropTypeValues.map[value] ?? defaultValue;
  }
}
