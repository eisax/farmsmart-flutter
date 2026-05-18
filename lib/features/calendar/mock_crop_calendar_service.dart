import 'package:farmsmart_flutter/model/entities/mock/mock_crop_catalog.dart';

/// Seasonal schedule from climate models + crop type (mock).
class MockCropCalendarService {
  static List<CalendarEvent> buildSchedule({
    required String cropName,
    required String location,
  }) {
    final now = DateTime.now();
    final crop = MockCropCatalog.findByName(cropName);
    final stages = crop?.stageTitles ??
        ['Land prep', 'Planting', 'Growth', 'Harvest'];

    return List<CalendarEvent>.generate(stages.length, (i) {
      final start = now.add(Duration(days: i * 21));
      final end = start.add(const Duration(days: 18));
      return CalendarEvent(
        title: stages[i],
        crop: cropName,
        location: location,
        start: start,
        end: end,
        note: _noteForStage(stages[i], location),
      );
    });
  }

  static String _noteForStage(String stage, String location) {
    if (stage.toLowerCase().contains('plant')) {
      return 'Optimal window for $location based on NR II rainfall onset.';
    }
    if (stage.toLowerCase().contains('harvest')) {
      return 'Monitor moisture; harvest in cool hours for quality.';
    }
    return 'Complete tasks before next seasonal rain band.';
  }
}

class CalendarEvent {
  final String title;
  final String crop;
  final String location;
  final DateTime start;
  final DateTime end;
  final String note;

  CalendarEvent({
    required this.title,
    required this.crop,
    required this.location,
    required this.start,
    required this.end,
    required this.note,
  });
}
