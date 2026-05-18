import 'dart:math';

import 'package:farmsmart_flutter/features/core/mock_offline_store.dart';

/// Mock OpenWeatherMap-style service with GPS location and offline cache.
class MockWeatherService {
  MockWeatherService._();

  static const _cacheKey = 'mock_openweather_cache_v1';
  static const defaultLat = -17.8252;
  static const defaultLon = 31.0522;
  static const defaultCity = 'Harare, Zimbabwe';

  static Future<WeatherBundle> fetch({
    double lat = defaultLat,
    double lon = defaultLon,
    String cityLabel = defaultCity,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await MockOfflineStore.loadJson(_cacheKey);
      if (cached != null) {
        return WeatherBundle.fromJson(cached, fromCache: true);
      }
    }

    await Future.delayed(const Duration(milliseconds: 800));
    final bundle = _generate(lat, lon, cityLabel);
    await MockOfflineStore.saveJson(_cacheKey, bundle.toJson());
    return bundle;
  }

  static WeatherBundle _generate(double lat, double lon, String city) {
    final rand = Random();
    final conditions = [
      'Clear sky',
      'Partly cloudy',
      'Overcast',
      'Light rain',
      'Thunderstorms',
    ];
    final current = DayForecast(
      date: DateTime.now(),
      condition: conditions[rand.nextInt(conditions.length)],
      tempHighC: 20 + rand.nextInt(12),
      tempLowC: 12 + rand.nextInt(8),
      humidity: 40 + rand.nextInt(45),
      rainChance: rand.nextInt(90),
      windKmh: 5 + rand.nextInt(25),
    );
    final daily = List<DayForecast>.generate(7, (i) {
      final day = DateTime.now().add(Duration(days: i));
      return DayForecast(
        date: day,
        condition: conditions[rand.nextInt(conditions.length)],
        tempHighC: 18 + rand.nextInt(14),
        tempLowC: 10 + rand.nextInt(10),
        humidity: 35 + rand.nextInt(50),
        rainChance: rand.nextInt(100),
        windKmh: 4 + rand.nextInt(28),
      );
    });
    final alerts = <WeatherAlert>[];
    if (current.rainChance > 70 || current.condition.contains('Thunder')) {
      alerts.add(WeatherAlert(
        title: 'Heavy rain advisory',
        body:
            'Prepare drainage on vegetable beds. Delay top-dressing fertiliser until soils dry.',
        severity: 'warning',
      ));
    }
    return WeatherBundle(
      city: city,
      lat: lat,
      lon: lon,
      fetchedAt: DateTime.now(),
      current: current,
      daily: daily,
      alerts: alerts,
      fromCache: false,
    );
  }
}

class WeatherBundle {
  final String city;
  final double lat;
  final double lon;
  final DateTime fetchedAt;
  final DayForecast current;
  final List<DayForecast> daily;
  final List<WeatherAlert> alerts;
  final bool fromCache;

  WeatherBundle({
    required this.city,
    required this.lat,
    required this.lon,
    required this.fetchedAt,
    required this.current,
    required this.daily,
    required this.alerts,
    this.fromCache = false,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'lat': lat,
        'lon': lon,
        'fetchedAt': fetchedAt.toIso8601String(),
        'current': current.toJson(),
        'daily': daily.map((d) => d.toJson()).toList(),
        'alerts': alerts.map((a) => a.toJson()).toList(),
      };

  factory WeatherBundle.fromJson(Map<String, dynamic> j,
      {bool fromCache = true}) {
    return WeatherBundle(
      city: j['city'] as String,
      lat: (j['lat'] as num).toDouble(),
      lon: (j['lon'] as num).toDouble(),
      fetchedAt: DateTime.parse(j['fetchedAt'] as String),
      current: DayForecast.fromJson(j['current'] as Map<String, dynamic>),
      daily: (j['daily'] as List)
          .map((e) => DayForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (j['alerts'] as List? ?? [])
          .map((e) => WeatherAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      fromCache: fromCache,
    );
  }
}

class DayForecast {
  final DateTime date;
  final String condition;
  final int tempHighC;
  final int tempLowC;
  final int humidity;
  final int rainChance;
  final int windKmh;

  DayForecast({
    required this.date,
    required this.condition,
    required this.tempHighC,
    required this.tempLowC,
    required this.humidity,
    required this.rainChance,
    required this.windKmh,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'condition': condition,
        'tempHighC': tempHighC,
        'tempLowC': tempLowC,
        'humidity': humidity,
        'rainChance': rainChance,
        'windKmh': windKmh,
      };

  factory DayForecast.fromJson(Map<String, dynamic> j) => DayForecast(
        date: DateTime.parse(j['date'] as String),
        condition: j['condition'] as String,
        tempHighC: j['tempHighC'] as int,
        tempLowC: j['tempLowC'] as int,
        humidity: j['humidity'] as int,
        rainChance: j['rainChance'] as int,
        windKmh: j['windKmh'] as int,
      );
}

class WeatherAlert {
  final String title;
  final String body;
  final String severity;

  WeatherAlert({
    required this.title,
    required this.body,
    required this.severity,
  });

  Map<String, dynamic> toJson() =>
      {'title': title, 'body': body, 'severity': severity};

  factory WeatherAlert.fromJson(Map<String, dynamic> j) => WeatherAlert(
        title: j['title'] as String,
        body: j['body'] as String,
        severity: j['severity'] as String,
      );
}
