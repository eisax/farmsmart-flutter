import 'package:farmsmart_flutter/ui/features/feature_screens.dart';
import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Launcher for core FarmSmart modules — minimal white grid.
class FarmToolsHub extends StatelessWidget {
  const FarmToolsHub({Key? key}) : super(key: key);

  static const _tools = [
    _Tool('Weather', Icons.cloud_outlined, WeatherFeatureScreen.new),
    _Tool('AI Advice', Icons.psychology_outlined, AiRecommendationFeatureScreen.new),
    _Tool('Disease scan', Icons.biotech_outlined, DiseaseDetectionFeatureScreen.new),
    _Tool('Calendar', Icons.calendar_month_outlined, CropCalendarFeatureScreen.new),
    _Tool('Inventory', Icons.inventory_2_outlined, InventoryFeatureScreen.new),
    _Tool('Field logs', Icons.menu_book_outlined, FieldLogsFeatureScreen.new),
    _Tool('Messages', Icons.forum_outlined, MessagingFeatureScreen.new),
    _Tool('Market', Icons.trending_up, MarketPricesFeatureScreen.new),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tools', style: AppTheme.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          Text('Everything you need on the farm', style: AppTheme.body),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
            children: _tools.map((t) => _tile(context, t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, _Tool tool) {
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => tool.builder()),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.accentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(tool.icon, color: AppTheme.accent, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                tool.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tool {
  final String title;
  final IconData icon;
  final Widget Function() builder;
  const _Tool(this.title, this.icon, this.builder);
}
