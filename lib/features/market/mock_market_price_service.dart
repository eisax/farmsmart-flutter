import 'dart:math';

import 'package:farmsmart_flutter/features/core/mock_offline_store.dart';

/// Commodity market prices (mock AMIS / local market feeds).
class MockMarketPriceService {
  static const _key = 'mock_market_prices_v1';

  static Future<List<CommodityPrice>> getPrices({bool refresh = false}) async {
    if (!refresh) {
      final cached = await MockOfflineStore.loadList(_key);
      if (cached.isNotEmpty) {
        return cached.map(CommodityPrice.fromJson).toList();
      }
    }
    await Future.delayed(const Duration(milliseconds: 600));
    final prices = _generate();
    await MockOfflineStore.saveList(
      _key,
      prices.map((p) => p.toJson()).toList(),
    );
    return prices;
  }

  static List<CommodityPrice> _generate() {
    final rand = Random();
    return [
      _item('Maize grain', 0.32, 0.28, rand),
      _item('Tomatoes', 0.85, 0.76, rand),
      _item('Leafy greens (covo)', 0.45, 0.42, rand),
      _item('Dry beans', 1.10, 1.05, rand),
      _item('Onions', 0.55, 0.60, rand, invertTrend: true),
      _item('Irish potatoes', 0.48, 0.44, rand),
      _item('Sorghum', 0.29, 0.27, rand),
      _item('Chillies (dry)', 2.40, 2.15, rand),
    ];
  }

  static CommodityPrice _item(
    String name,
    double current,
    double previous,
    Random rand, {
    bool invertTrend = false,
  }) {
    var change = ((current - previous) / previous) * 100;
    if (invertTrend) change = -change;
    final significant = change.abs() >= 8;
    return CommodityPrice(
      commodity: name,
      unit: 'USD/kg',
      currentPrice: current,
      previousPrice: previous,
      changePercent: change,
      market: 'Harare / Mbare',
      history: List.generate(
        6,
        (i) => previous + (rand.nextDouble() - 0.5) * 0.08,
      ),
      notifyFarmer: significant,
    );
  }
}

class CommodityPrice {
  final String commodity;
  final String unit;
  final double currentPrice;
  final double previousPrice;
  final double changePercent;
  final String market;
  final List<double> history;
  final bool notifyFarmer;

  CommodityPrice({
    required this.commodity,
    required this.unit,
    required this.currentPrice,
    required this.previousPrice,
    required this.changePercent,
    required this.market,
    required this.history,
    this.notifyFarmer = false,
  });

  Map<String, dynamic> toJson() => {
        'commodity': commodity,
        'unit': unit,
        'currentPrice': currentPrice,
        'previousPrice': previousPrice,
        'changePercent': changePercent,
        'market': market,
        'history': history,
        'notifyFarmer': notifyFarmer,
      };

  factory CommodityPrice.fromJson(Map<String, dynamic> j) => CommodityPrice(
        commodity: j['commodity'] as String,
        unit: j['unit'] as String,
        currentPrice: (j['currentPrice'] as num).toDouble(),
        previousPrice: (j['previousPrice'] as num).toDouble(),
        changePercent: (j['changePercent'] as num).toDouble(),
        market: j['market'] as String,
        history: (j['history'] as List).map((e) => (e as num).toDouble()).toList(),
        notifyFarmer: j['notifyFarmer'] as bool? ?? false,
      );
}
