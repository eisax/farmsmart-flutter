import 'package:farmsmart_flutter/features/core/mock_offline_store.dart';

/// Farmer ↔ extension officer messaging + system notifications.
class MockMessagingService {
  static const _messagesKey = 'mock_messages_v1';
  static const _notifKey = 'mock_notifications_v1';

  static Future<List<ChatMessage>> getMessages() async {
    final rows = await MockOfflineStore.loadList(_messagesKey);
    if (rows.isEmpty) {
      final seed = _seedMessages();
      await MockOfflineStore.saveList(
        _messagesKey,
        seed.map((m) => m.toJson()).toList(),
      );
      return seed;
    }
    return rows.map(ChatMessage.fromJson).toList();
  }

  static Future<void> sendMessage(String text, {bool fromFarmer = true}) async {
    final list = await getMessages();
    list.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: fromFarmer ? 'You' : 'Extension Officer',
      body: text,
      sentAt: DateTime.now(),
    ));
    await MockOfflineStore.saveList(
      _messagesKey,
      list.map((m) => m.toJson()).toList(),
    );
  }

  static Future<List<AppNotification>> getNotifications() async {
    final rows = await MockOfflineStore.loadList(_notifKey);
    if (rows.isEmpty) {
      final seed = _seedNotifications();
      await MockOfflineStore.saveList(
        _notifKey,
        seed.map((n) => n.toJson()).toList(),
      );
      return seed;
    }
    return rows.map(AppNotification.fromJson).toList();
  }

  static List<ChatMessage> _seedMessages() => [
        ChatMessage(
          id: '1',
          sender: 'Extension Officer',
          body:
              'Good morning. Maize in NR II should be at knee-high stage — send a photo if you see streaking on leaves.',
          sentAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ChatMessage(
          id: '2',
          sender: 'You',
          body: 'Thank you. I will scout tomorrow morning.',
          sentAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
      ];

  static List<AppNotification> _seedNotifications() => [
        AppNotification(
          id: 'n1',
          type: NotificationType.weather,
          title: 'Heavy rain expected',
          body: '60 mm possible Thursday — check field drainage.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        AppNotification(
          id: 'n2',
          type: NotificationType.pest,
          title: 'Fall armyworm alert',
          body: 'Reports in Mashonaland West. Scout maize whorls daily.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        AppNotification(
          id: 'n3',
          type: NotificationType.market,
          title: 'Tomato price up 12%',
          body: 'Mbare average now \$0.85/kg — consider partial harvest.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
}

enum NotificationType { weather, pest, market, message }

class ChatMessage {
  final String id;
  final String sender;
  final String body;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.body,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'body': body,
        'sentAt': sentAt.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'] as String,
        sender: j['sender'] as String,
        body: j['body'] as String,
        sentAt: DateTime.parse(j['sentAt'] as String),
      );
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as String,
        type: NotificationType.values.byName(j['type'] as String),
        title: j['title'] as String,
        body: j['body'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}
