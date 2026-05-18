import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FeatureScreenShell extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;

  const FeatureScreenShell({
    Key? key,
    required this.title,
    this.subtitle,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: body,
    );
  }
}

Widget mockBadge(String label) {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: AppTheme.offWhite,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      border: Border.all(color: AppTheme.border),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: AppTheme.grey),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTheme.caption.copyWith(color: AppTheme.grey))),
      ],
    ),
  );
}

/// Dark metric card for data-heavy feature sections.
Widget darkMetricCard({
  required String title,
  required Widget child,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: const EdgeInsets.all(20),
    decoration: AppTheme.darkCard(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.labelOnDark),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}
