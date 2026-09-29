import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'companion_reminders';
  static const String _channelName = 'Companion Reminders';
  static const String _channelDescription =
      'Daily reminders to check in with your companion and log your journey.';
  static const int _dailyReminderNotificationId = 1001;

  static const String reminderEnabledKey = 'companion_reminder_enabled';

  static bool _isInitialized = false;

  /// Initialize local notification plugin and schedule daily check-in
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('[NotificationService] Notification tapped: ${details.payload}');
        },
      );

      // Create Android Notification Channel
      if (!kIsWeb && Platform.isAndroid) {
        final androidChannel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          playSound: true,
        );

        final androidPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        await androidPlugin?.createNotificationChannel(androidChannel);
        await androidPlugin?.requestNotificationsPermission();
      }

      // Request iOS Notification Permissions
      if (!kIsWeb && Platform.isIOS) {
        final iosPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

        await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      _isInitialized = true;
      debugPrint('[NotificationService] Initialized successfully');

      // Schedule daily reminder if enabled
      final isEnabled = await isReminderEnabled();
      if (isEnabled) {
        await scheduleDailyCompanionReminder();
      }
    } catch (e) {
      debugPrint('[NotificationService] Initialization error: $e');
    }
  }

  /// Check if companion reminder is enabled
  static Future<bool> isReminderEnabled() async {
    final enabled = await SharedPreferencesHelper.getBool(reminderEnabledKey);
    return enabled ?? true; // Default to true for V1 retention
  }

  /// Toggle daily reminder on or off
  static Future<void> toggleReminder(bool enabled) async {
    await SharedPreferencesHelper.setBool(reminderEnabledKey, enabled);
    if (enabled) {
      await scheduleDailyCompanionReminder();
    } else {
      await cancelDailyReminder();
    }
  }

  /// Schedule daily notification at the specified local time (defaults to 8:00 PM)
  static Future<void> scheduleDailyCompanionReminder({
    int hour = 20,
    int minute = 0,
  }) async {
    try {
      if (!_isInitialized) await init();

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If scheduled time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        _dailyReminderNotificationId,
        'Your Companion Awaits',
        "Your companion is waiting for you. Return to the Codex to continue today's journey.",
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // repeats daily at the same time
      );

      debugPrint(
        '[NotificationService] Scheduled daily reminder for ${scheduledDate.toIso8601String()}',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error scheduling daily reminder: $e');
    }
  }

  /// Cancel the scheduled daily reminder
  static Future<void> cancelDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(_dailyReminderNotificationId);
      debugPrint('[NotificationService] Cancelled daily reminder');
    } catch (e) {
      debugPrint('[NotificationService] Error cancelling reminder: $e');
    }
  }

  /// Show an instant test notification
  static Future<void> showTestNotification({
    String title = 'Your Companion Awaits',
    String body =
        "Your companion is waiting for you. Return to the Codex to continue today's journey.",
  }) async {
    try {
      if (!_isInitialized) await init();

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        999,
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('[NotificationService] Error showing test notification: $e');
    }
  }
}
