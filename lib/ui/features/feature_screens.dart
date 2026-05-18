import 'package:farmsmart_flutter/features/ai/mock_ai_recommendation_service.dart';
import 'package:farmsmart_flutter/features/calendar/mock_crop_calendar_service.dart';
import 'package:farmsmart_flutter/features/disease/mock_disease_detection_service.dart';
import 'package:farmsmart_flutter/features/inventory/mock_inventory_repository.dart';
import 'package:farmsmart_flutter/features/logs/mock_field_log_repository.dart';
import 'package:farmsmart_flutter/features/market/mock_market_price_service.dart';
import 'package:farmsmart_flutter/features/messaging/mock_messaging_service.dart';
import 'package:farmsmart_flutter/features/weather/mock_weather_service.dart';
import 'package:farmsmart_flutter/model/entities/mock/mock_crop_catalog.dart';
import 'package:farmsmart_flutter/ui/features/feature_screen_shell.dart';
import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ——— 1. Weather ———
class WeatherFeatureScreen extends StatefulWidget {
  const WeatherFeatureScreen({Key? key}) : super(key: key);

  @override
  State<WeatherFeatureScreen> createState() => _WeatherFeatureScreenState();
}

class _WeatherFeatureScreenState extends State<WeatherFeatureScreen> {
  WeatherBundle? _bundle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    setState(() => _loading = true);
    final b = await MockWeatherService.fetch(forceRefresh: refresh);
    if (mounted) setState(() {
      _bundle = b;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Weather forecast',
      subtitle: 'OpenWeatherMap · GPS ${MockWeatherService.defaultLat}, ${MockWeatherService.defaultLon}',
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: () => _load(refresh: true)),
      ],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bundle == null
              ? const SizedBox.shrink()
              : ListView(
                  children: [
                    mockBadge(_bundle!.fromCache
                        ? 'Offline: showing last cached forecast (AES-ready store)'
                        : 'Live fetch · cached for offline use'),
                    _currentCard(_bundle!),
                    if (_bundle!.alerts.isNotEmpty) ..._alertCards(_bundle!.alerts),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text('7-day outlook',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                    ..._bundle!.daily.map(_dayTile),
                    const SizedBox(height: 24),
                  ],
                ),
    );
  }

  Widget _currentCard(WeatherBundle b) {
    final c = b.current;
    return darkMetricCard(
      title: b.city,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${c.tempHighC}° · ${c.condition}',
            style: AppTheme.valueOnDark.copyWith(fontSize: 32),
          ),
          Text(
            'Updated ${DateFormat.jm().format(b.fetchedAt)}',
            style: AppTheme.caption.copyWith(color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Text(
            'Humidity ${c.humidity}% · Rain ${c.rainChance}% · Wind ${c.windKmh} km/h',
            style: AppTheme.labelOnDark.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  List<Widget> _alertCards(List<WeatherAlert> alerts) {
    return alerts
        .map((a) => Card(
              color: Colors.orange.shade50,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.warning_amber, color: Colors.orange),
                title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(a.body),
              ),
            ))
        .toList();
  }

  Widget _dayTile(DayForecast d) {
    return ListTile(
      title: Text(DateFormat.E().add_MMMd().format(d.date)),
      subtitle: Text(d.condition),
      trailing: Text('${d.tempLowC}°–${d.tempHighC}°'),
    );
  }
}

// ——— 2. AI recommendations ———
class AiRecommendationFeatureScreen extends StatefulWidget {
  const AiRecommendationFeatureScreen({Key? key}) : super(key: key);

  @override
  State<AiRecommendationFeatureScreen> createState() =>
      _AiRecommendationFeatureScreenState();
}

class _AiRecommendationFeatureScreenState
    extends State<AiRecommendationFeatureScreen> {
  String _crop = MockCropCatalog.all.first.name;
  String _soil = 'Loam';
  String _location = 'Harare, Natural Region II';
  String _weather = 'Partly cloudy, 24°C, 40% rain';
  AiRecommendationResult? _result;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'AI crop recommendations',
      subtitle: 'Inputs → advice in under 5 seconds',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          mockBadge('Mock AI · replace with cloud model in production'),
          _dropdown('Crop', _crop, MockCropCatalog.names,
              (v) => setState(() => _crop = v!)),
          _dropdown('Soil', _soil, ['Loam', 'Sandy loam', 'Clay loam', 'Volcanic'],
              (v) => setState(() => _soil = v!)),
          _textField('Location', _location, (v) => setState(() => _location = v)),
          _textField('Current weather', _weather, (v) => setState(() => _weather = v)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _loading ? null : _run,
            style: FilledButton.styleFrom(backgroundColor: AppTheme.accent),
            child: Text(_loading ? 'Analysing…' : 'Get AI advice'),
          ),
          if (_result != null) ...[
            const SizedBox(height: 20),
            _adviceCard('Planting', _result!.plantingAdvice),
            _adviceCard('Fertiliser', _result!.fertiliserRates),
            _adviceCard('Pest management', _result!.pestManagement),
            _adviceCard('Weather note', _result!.weatherNote),
            Text('Response time: ${_result!.responseMs} ms',
                style: AppTheme.body),
          ],
        ],
      ),
    );
  }

  Future<void> _run() async {
    setState(() {
      _loading = true;
      _result = null;
    });
    final r = await MockAiRecommendationService.advise(
      cropType: _crop,
      soilType: _soil,
      location: _location,
      weatherSummary: _weather,
    );
    setState(() {
      _result = r;
      _loading = false;
    });
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _textField(String label, String initial, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }

  Widget _adviceCard(String title, String body) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(body),
          ],
        ),
      ),
    );
  }
}

// ——— 3. Disease detection ———
class DiseaseDetectionFeatureScreen extends StatefulWidget {
  const DiseaseDetectionFeatureScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionFeatureScreen> createState() =>
      _DiseaseDetectionFeatureScreenState();
}

class _DiseaseDetectionFeatureScreenState extends State<DiseaseDetectionFeatureScreen> {
  DiseaseDiagnosis? _diagnosis;
  bool _loading = false;

  Future<void> _pickAndScan(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 1024);
    if (file == null) return;
    setState(() {
      _loading = true;
      _diagnosis = null;
    });
    final result = await MockDiseaseDetectionService.analyzePhoto(cropHint: 'Tomato');
    setState(() {
      _diagnosis = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Disease detection',
      subtitle: 'CNN · PlantVillage · TensorFlow Lite',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          mockBadge('On-device TFLite inference (mock) · works offline'),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : () => _pickAndScan(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : () => _pickAndScan(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),
          if (_loading) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
          if (_diagnosis != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_diagnosis!.disease,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text('Crop: ${_diagnosis!.crop} · '
                        '${(_diagnosis!.confidence * 100).toStringAsFixed(0)}% confidence'),
                    const SizedBox(height: 12),
                    const Text('Treatment', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(_diagnosis!.treatment),
                    const SizedBox(height: 8),
                    Text('Model: ${_diagnosis!.model}',
                        style: AppTheme.body),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ——— 4. Crop calendar ———
class CropCalendarFeatureScreen extends StatefulWidget {
  const CropCalendarFeatureScreen({Key? key}) : super(key: key);

  @override
  State<CropCalendarFeatureScreen> createState() => _CropCalendarFeatureScreenState();
}

class _CropCalendarFeatureScreenState extends State<CropCalendarFeatureScreen> {
  String _crop = MockCropCatalog.all.first.name;
  late List<CalendarEvent> _events;

  @override
  void initState() {
    super.initState();
    _events = MockCropCalendarService.buildSchedule(
      cropName: _crop,
      location: 'Harare, NR II',
    );
  }

  void _rebuild() {
    setState(() {
      _events = MockCropCalendarService.buildSchedule(
        cropName: _crop,
        location: 'Harare, NR II',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Crop calendar',
      subtitle: 'Climate-optimised planting & harvest',
      body: Column(
        children: [
          mockBadge('Seasonal model mock · NR II Zimbabwe'),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _crop,
              decoration: const InputDecoration(labelText: 'Crop', border: OutlineInputBorder()),
              items: MockCropCatalog.names
                  .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  _crop = v;
                  _rebuild();
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (_, i) {
                final e = _events[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.accentLight,
                      child: Text('${i + 1}'),
                    ),
                    title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${DateFormat.MMMd().format(e.start)} – ${DateFormat.MMMd().format(e.end)}\n${e.note}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ——— 5. Inventory ———
class InventoryFeatureScreen extends StatefulWidget {
  const InventoryFeatureScreen({Key? key}) : super(key: key);

  @override
  State<InventoryFeatureScreen> createState() => _InventoryFeatureScreenState();
}

class _InventoryFeatureScreenState extends State<InventoryFeatureScreen> {
  List<InventoryItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await MockInventoryRepository.getAll();
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _add() async {
    final name = TextEditingController();
    final qty = TextEditingController(text: '1');
  await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add stock item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: qty, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await MockInventoryRepository.upsert(InventoryItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name.text,
                category: 'General',
                quantity: double.tryParse(qty.text) ?? 1,
                unit: 'units',
              ));
              Navigator.pop(ctx);
              _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Inventory',
      subtitle: 'Offline · Room/SQLite · AES-256 (mock)',
      actions: [IconButton(icon: const Icon(Icons.add), onPressed: _add)],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                mockBadge('Encrypted local store (SharedPreferences mock)'),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      return Dismissible(
                        key: ValueKey(item.id),
                        onDismissed: (_) => MockInventoryRepository.delete(item.id).then((_) => _load()),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.category),
                          trailing: Text('${item.quantity} ${item.unit}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ——— 6. Field logs ———
class FieldLogsFeatureScreen extends StatefulWidget {
  const FieldLogsFeatureScreen({Key? key}) : super(key: key);

  @override
  State<FieldLogsFeatureScreen> createState() => _FieldLogsFeatureScreenState();
}

class _FieldLogsFeatureScreenState extends State<FieldLogsFeatureScreen> {
  List<FieldLogEntry> _logs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final logs = await MockFieldLogRepository.getAll();
    setState(() => _logs = logs);
  }

  Future<void> _add() async {
    final obs = TextEditingController();
    final action = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New field observation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: obs, decoration: const InputDecoration(labelText: 'Observation'), maxLines: 3),
            TextField(controller: action, decoration: const InputDecoration(labelText: 'Action taken')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await MockFieldLogRepository.add(FieldLogEntry(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                date: DateTime.now(),
                crop: 'Tomatoes',
                plot: 'Plot 1',
                observation: obs.text,
                actionTaken: action.text,
              ));
              Navigator.pop(ctx);
              _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Field observation logs',
      subtitle: 'Replace paper notebooks',
      actions: [IconButton(icon: const Icon(Icons.add), onPressed: _add)],
      body: Column(
        children: [
          mockBadge('Stored locally · sync when online (future)'),
          Expanded(
            child: _logs.isEmpty
                ? const Center(child: Text('No logs yet. Tap + to record a visit.'))
                : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (_, i) {
                      final log = _logs[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          title: Text('${log.crop} · ${log.plot}'),
                          subtitle: Text(
                            '${DateFormat.yMMMd().format(log.date)}\n${log.observation}\nAction: ${log.actionTaken}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ——— 7. Messaging ———
class MessagingFeatureScreen extends StatefulWidget {
  const MessagingFeatureScreen({Key? key}) : super(key: key);

  @override
  State<MessagingFeatureScreen> createState() => _MessagingFeatureScreenState();
}

class _MessagingFeatureScreenState extends State<MessagingFeatureScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  List<ChatMessage> _messages = [];
  List<AppNotification> _notifications = [];
  final _input = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _messages = [];
      _notifications = [];
    });
    final m = await MockMessagingService.getMessages();
    final n = await MockMessagingService.getNotifications();
    setState(() {
      _messages = m;
      _notifications = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Messages & alerts',
      subtitle: 'Extension officer · push notifications',
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            labelColor: AppTheme.accent,
            tabs: const [Tab(text: 'Chat'), Tab(text: 'Notifications')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m = _messages[i];
                          final mine = m.sender == 'You';
                          return Align(
                            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mine ? AppTheme.accentLight : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${m.sender}: ${m.body}'),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _input,
                              decoration: const InputDecoration(
                                hintText: 'Message extension officer…',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              if (_input.text.isEmpty) return;
                              await MockMessagingService.sendMessage(_input.text);
                              _input.clear();
                              _load();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (_, i) {
                    final n = _notifications[i];
                    return ListTile(
                      leading: Icon(_notifIcon(n.type), color: AppTheme.accent),
                      title: Text(n.title),
                      subtitle: Text(n.body),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _notifIcon(NotificationType t) {
    switch (t) {
      case NotificationType.weather:
        return Icons.cloud;
      case NotificationType.pest:
        return Icons.bug_report;
      case NotificationType.market:
        return Icons.attach_money;
      default:
        return Icons.notifications;
    }
  }
}

// ——— 8. Market prices ———
class MarketPricesFeatureScreen extends StatefulWidget {
  const MarketPricesFeatureScreen({Key? key}) : super(key: key);

  @override
  State<MarketPricesFeatureScreen> createState() => _MarketPricesFeatureScreenState();
}

class _MarketPricesFeatureScreenState extends State<MarketPricesFeatureScreen> {
  List<CommodityPrice> _prices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    setState(() => _loading = true);
    final p = await MockMarketPriceService.getPrices(refresh: refresh);
    setState(() {
      _prices = p;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScreenShell(
      title: 'Market prices',
      subtitle: 'Harare · USD/kg · historical trend',
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: () => _load(refresh: true)),
      ],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                mockBadge('Significant moves trigger farmer notifications (mock)'),
                ..._prices.map((p) {
                  final up = p.changePercent >= 0;
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(child: Text(p.commodity, style: const TextStyle(fontWeight: FontWeight.w600))),
                          if (p.notifyFarmer)
                            const Icon(Icons.notifications_active, size: 18, color: Colors.orange),
                        ],
                      ),
                      subtitle: Text('${p.market} · was \$${p.previousPrice.toStringAsFixed(2)}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${p.currentPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          Text(
                            '${up ? '+' : ''}${p.changePercent.toStringAsFixed(1)}%',
                            style: TextStyle(color: up ? Colors.green : Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
