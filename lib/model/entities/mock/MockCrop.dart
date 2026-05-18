import 'package:farmsmart_flutter/model/entities/mock/MockArticle.dart';
import 'package:farmsmart_flutter/model/entities/mock/crop_plant_images.dart';
import 'package:farmsmart_flutter/model/entities/mock/mock_crop_catalog.dart';
import 'package:farmsmart_flutter/model/entities/mock/mock_crop_image_collection.dart';
import 'package:farmsmart_flutter/model/entities/mock/mock_crop_stage_articles.dart';
import 'package:farmsmart_flutter/model/repositories/MockStrings.dart';

import '../crop_entity.dart';

class MockCrop {
  static CropEntity build({String? cropName}) {
    final name = cropName ?? plants.random();
    final definition =
        MockCropCatalog.findByName(name) ?? MockCropCatalog.all.first;

    final entity = CropEntity(
      uri: definition.name,
      article: MockArticle().buildCrop(
        definition.name,
        summary: definition.summary,
      ),
      companionPlants: definition.companions,
      complexity: definition.complexity,
      cropsInRotation: definition.rotationCrops,
      cropType: definition.cropType,
      name: definition.name,
      nonCompanionPlants: definition.nonCompanions,
      profitability: definition.profitability,
      setupCost: definition.setupCost,
      soilType: definition.soilTypes,
      waterRequirement: definition.waterRequirement,
    );
    entity.stageArticles =
        MockCropStageArticleCollection(definition.stageTitles);
    entity.images = MockCropImageCollection(
      CropPlantImages.forCrop(definition.name),
    );
    return entity;
  }

  static List<CropEntity> uniqueList() {
    return MockCropCatalog.all.map((d) => build(cropName: d.name)).toList();
  }

  static List<CropEntity> list({int count = 50}) {
    final items = <CropEntity>[];
    for (var i = 0; i < count; i++) {
      items.add(build(cropName: plants.libarary()[i % plants.libarary().length]));
    }
    return items;
  }
}
