import 'package:farmsmart_flutter/model/entities/mock/mock_crop_catalog.dart';

/// Mock AI advisor — production would call cloud LLM; target &lt; 5 s response.
class MockAiRecommendationService {
  static Future<AiRecommendationResult> advise({
    required String cropType,
    required String soilType,
    required String location,
    required String weatherSummary,
  }) async {
    final elapsed = Stopwatch()..start();
    await Future.delayed(const Duration(milliseconds: 2200));
    elapsed.stop();

    final crop = MockCropCatalog.findByName(cropType);
    final planting = crop != null
        ? 'Plant ${crop.name} after soils reach 18°C at 10 cm depth. '
            'Use ${crop.soilTypes.first} where possible.'
        : 'Align planting with the start of reliable rains in $location.';

    return AiRecommendationResult(
      cropType: cropType,
      plantingAdvice: planting,
      fertiliserRates:
          'Basal: 300 kg/ha compound D at planting. Top-dress 150 kg/ha AN '
          'at 4–6 weeks if rainfall is adequate.',
      pestManagement:
          'Scout twice weekly. For ${cropType.toLowerCase()}, watch for aphids '
          'and leaf miners; use registered products only and respect PHI.',
      weatherNote:
          'Current outlook: $weatherSummary. Adjust irrigation if rain chance exceeds 60%.',
      responseMs: elapsed.elapsedMilliseconds,
    );
  }
}

class AiRecommendationResult {
  final String cropType;
  final String plantingAdvice;
  final String fertiliserRates;
  final String pestManagement;
  final String weatherNote;
  final int responseMs;

  AiRecommendationResult({
    required this.cropType,
    required this.plantingAdvice,
    required this.fertiliserRates,
    required this.pestManagement,
    required this.weatherNote,
    required this.responseMs,
  });
}
