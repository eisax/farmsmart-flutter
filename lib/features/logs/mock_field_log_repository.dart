import 'package:farmsmart_flutter/features/core/mock_offline_store.dart';

/// Digital field observation logs (replaces paper notebooks).
class MockFieldLogRepository {
  static const _key = 'mock_field_logs_v1';

  static Future<List<FieldLogEntry>> getAll() async {
    final rows = await MockOfflineStore.loadList(_key);
    return rows.map(FieldLogEntry.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> add(FieldLogEntry entry) async {
    final all = await getAll();
    all.insert(0, entry);
    await MockOfflineStore.saveList(
      _key,
      all.map((e) => e.toJson()).toList(),
    );
  }

  static Future<void> remove(String id) async {
    final all = await getAll();
    all.removeWhere((e) => e.id == id);
    await MockOfflineStore.saveList(
      _key,
      all.map((e) => e.toJson()).toList(),
    );
  }
}

class FieldLogEntry {
  final String id;
  final DateTime date;
  final String crop;
  final String plot;
  final String observation;
  final String actionTaken;

  FieldLogEntry({
    required this.id,
    required this.date,
    required this.crop,
    required this.plot,
    required this.observation,
    required this.actionTaken,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'crop': crop,
        'plot': plot,
        'observation': observation,
        'actionTaken': actionTaken,
      };

  factory FieldLogEntry.fromJson(Map<String, dynamic> j) => FieldLogEntry(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        crop: j['crop'] as String,
        plot: j['plot'] as String,
        observation: j['observation'] as String,
        actionTaken: j['actionTaken'] as String,
      );
}
