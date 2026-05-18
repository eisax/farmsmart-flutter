import 'package:farmsmart_flutter/features/weather/mock_weather_service.dart';
import 'package:farmsmart_flutter/ui/features/feature_screens.dart';
import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Dashboard weather — dark data card (reference greenhouse temperature UI).
class WeatherForecastCard extends StatefulWidget {
  const WeatherForecastCard({Key? key}) : super(key: key);

  @override
  State<WeatherForecastCard> createState() => _WeatherForecastCardState();
}

class _WeatherForecastCardState extends State<WeatherForecastCard> {
  WeatherBundle? _bundle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final b = await MockWeatherService.fetch();
    if (mounted) {
      setState(() {
        _bundle = b;
        _loading = false;
      });
    }
  }

  void _openFull(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WeatherFeatureScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: LinearProgressIndicator(minHeight: 2),
      );
    }
    final b = _bundle;
    if (b == null) return const SizedBox.shrink();
    final c = b.current;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: GestureDetector(
        onTap: () => _openFull(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.darkCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Weather', style: AppTheme.labelOnDark),
                  const Spacer(),
                  if (b.fromCache)
                    Icon(Icons.offline_pin, size: 16, color: Colors.white.withValues(alpha: 0.5)),
                  Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.6)),
                ],
              ),
              const SizedBox(height: 4),
              Text(b.city, style: AppTheme.caption.copyWith(color: Colors.white54)),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${c.tempHighC}°', style: AppTheme.valueOnDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c.condition,
                      style: AppTheme.labelOnDark.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _gradientBar(c.tempLowC, c.tempHighC),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _stat('Humidity', '${c.humidity}%'),
                  _stat('Rain', '${c.rainChance}%'),
                  _stat('Wind', '${c.windKmh} km/h'),
                ],
              ),
              if (b.daily.length > 1) ...[
                const SizedBox(height: 12),
                Text(
                  '7-day · ${DateFormat.E().format(b.daily[1].date)} ${b.daily[1].tempLowC}–${b.daily[1].tempHighC}°',
                  style: AppTheme.caption.copyWith(color: Colors.white54),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradientBar(int low, int high) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: const LinearGradient(
          colors: [Color(0xFF5C9CE6), Color(0xFF4CAF50), Color(0xFFE8B84A), Color(0xFFE85D4C)],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.caption.copyWith(color: Colors.white38, fontSize: 11)),
        Text(value, style: AppTheme.labelOnDark.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
