import 'package:farmsmart_flutter/features/core/mock_offline_store.dart';

/// Offline inventory (mock Room DB + AES-256 at rest).
class MockInventoryRepository {
  static const _key = 'mock_inventory_encrypted_v1';

  static Future<List<InventoryItem>> getAll() async {
    final rows = await MockOfflineStore.loadList(_key);
    if (rows.isEmpty) {
      final defaults = _defaults();
      await saveAll(defaults);
      return defaults;
    }
    return rows.map(InventoryItem.fromJson).toList();
  }

  static Future<void> saveAll(List<InventoryItem> items) async {
    await MockOfflineStore.saveList(
      _key,
      items.map((e) => e.toJson()).toList(),
    );
  }

  static Future<void> upsert(InventoryItem item) async {
    final all = await getAll();
    final idx = all.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      all[idx] = item;
    } else {
      all.add(item);
    }
    await saveAll(all);
  }

  static Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((e) => e.id == id);
    await saveAll(all);
  }

  static List<InventoryItem> _defaults() => [
        InventoryItem(
          id: '1',
          name: 'Maize seed SC727',
          category: 'Seeds',
          quantity: 25,
          unit: 'kg',
        ),
        InventoryItem(
          id: '2',
          name: 'Compound D fertiliser',
          category: 'Fertiliser',
          quantity: 4,
          unit: 'bags',
        ),
        InventoryItem(
          id: '3',
          name: 'Lambda-cyhalothrin',
          category: 'Pesticide',
          quantity: 2,
          unit: 'L',
        ),
      ];
}

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
        'unit': unit,
      };

  factory InventoryItem.fromJson(Map<String, dynamic> j) => InventoryItem(
        id: j['id'] as String,
        name: j['name'] as String,
        category: j['category'] as String,
        quantity: (j['quantity'] as num).toDouble(),
        unit: j['unit'] as String,
      );
}
