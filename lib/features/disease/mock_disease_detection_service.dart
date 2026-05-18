import 'dart:math';

/// Mock TensorFlow Lite / PlantVillage CNN inference (on-device in production).
class MockDiseaseDetectionService {
  static final _diagnoses = [
    (
      disease: 'Early blight (Alternaria solani)',
      confidence: 0.91,
      treatment:
          'Remove infected leaves. Apply chlorothalonil or mancozeb per label. '
          'Improve airflow between plants.',
    ),
    (
      disease: 'Powdery mildew',
      confidence: 0.87,
      treatment:
          'Sulphur or potassium bicarbonate spray. Avoid overhead irrigation in late afternoon.',
    ),
    (
      disease: 'Healthy leaf (no disease)',
      confidence: 0.94,
      treatment:
          'Continue routine scouting. Maintain balanced NPK and mulch to reduce splash.',
    ),
    (
      disease: 'Leaf spot (Cercospora)',
      confidence: 0.83,
      treatment:
          'Rotate with non-host crops. Apply copper-based fungicide at first symptoms.',
    ),
  ];

  /// Simulates TFLite inference latency (offline-capable).
  static Future<DiseaseDiagnosis> analyzePhoto({String? cropHint}) async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final pick = _diagnoses[Random().nextInt(_diagnoses.length)];
    return DiseaseDiagnosis(
      crop: cropHint ?? 'Tomato',
      disease: pick.disease,
      confidence: pick.confidence,
      treatment: pick.treatment,
      model: 'plantvillage_mobilenet_v2.tflite (mock)',
      offline: true,
    );
  }
}

class DiseaseDiagnosis {
  final String crop;
  final String disease;
  final double confidence;
  final String treatment;
  final String model;
  final bool offline;

  DiseaseDiagnosis({
    required this.crop,
    required this.disease,
    required this.confidence,
    required this.treatment,
    required this.model,
    required this.offline,
  });
}
