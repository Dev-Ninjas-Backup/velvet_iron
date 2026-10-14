import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'companion_reminders_v2';
  static const String _channelName = 'Companion Reminders';
  static const String _channelDescription =
      'Daily reminders to check in with your companion and log your journey.';

  /// Primary ID for daily companion reminder
  static const int _dailyReminderNotificationId = 1001;
  static const int _baseReminderNotificationId = 1000;

  static const String reminderEnabledKey = 'companion_reminder_enabled';

  /// Curated fantasy-themed companion reminder messages
  static const List<String> reminderMessages = [
    "The campfire is burning, traveler. Come reflect on today's journey.",
    "Another day draws to a close. Your companion awaits you at camp.",
    "The stars are rising over the realm. Have you recorded today's victories?",
    "Your journey continues tomorrow, but tonight, the campfire awaits.",
    "Even the greatest warriors must rest. Return to camp and reflect on your progress.",
  ];

  static bool _isInitialized = false;

  /// Initialize local notification plugin and schedule daily check-in
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      try {
        final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
        final timeZoneName = timeZoneInfo.identifier;
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        debugPrint(
          '[NotificationService] Local timezone set to: $timeZoneName',
        );
      } catch (tzErr) {
        debugPrint(
          '[NotificationService] FlutterTimezone error: $tzErr, matching offset...',
        );
        final offset = DateTime.now().timeZoneOffset;
        for (final loc in tz.timeZoneDatabase.locations.values) {
          if (loc.currentTimeZone.offset == offset.inMilliseconds) {
            tz.setLocalLocation(loc);
            debugPrint(
              '[NotificationService] Local timezone matched: ${loc.name}',
            );
            break;
          }
        }
      }

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true,
            defaultPresentBanner: true,
            defaultPresentList: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint(
            '[NotificationService] Notification tapped: ${details.payload}',
          );
        },
      );

      // Create Android Notification Channel and request runtime permissions
      if (!kIsWeb && Platform.isAndroid) {
        const androidChannel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

        final androidPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        await androidPlugin?.createNotificationChannel(androidChannel);
        await androidPlugin?.requestNotificationsPermission();
        try {
          await androidPlugin?.requestExactAlarmsPermission();
        } catch (e) {
          debugPrint(
            '[NotificationService] requestExactAlarmsPermission error: $e',
          );
        }

        final enabled = await androidPlugin?.areNotificationsEnabled();
        debugPrint(
          '[NotificationService] Android notifications enabled status: $enabled',
        );
      }

      // Request iOS Notification Permissions
      if (!kIsWeb && Platform.isIOS) {
        final iosPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

        final granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint(
          '[NotificationService] iOS notification permissions granted: $granted',
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

  /// Determines safe AndroidScheduleMode based on device permissions
  static Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    if (kIsWeb || !Platform.isAndroid) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact = await androidPlugin?.canScheduleExactNotifications();
      if (canExact == true) {
        return AndroidScheduleMode.exactAllowWhileIdle;
      } else {
        return AndroidScheduleMode.inexactAllowWhileIdle;
      }
    } catch (e) {
      debugPrint(
        '[NotificationService] Error checking exact alarm capability: $e',
      );
    }
    return AndroidScheduleMode.exactAllowWhileIdle;
  }

  /// Safely schedule zoned notification with graceful fallback to inexact alarms
  static Future<void> _safeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    final scheduleMode = await _resolveAndroidScheduleMode();
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
      );
    } catch (scheduleErr) {
      debugPrint(
        '[NotificationService] zonedSchedule error with $scheduleMode: $scheduleErr. Retrying with inexact...',
      );
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
      );
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

  /// Schedule daily notification at 8:00 PM
  /// Uses DateTimeComponents.time for rock-solid recurring delivery across all devices.
  static Future<void> scheduleDailyCompanionReminder({
    int hour = 20,
    int minute = 0,
  }) async {
    try {
      if (!_isInitialized) await init();

      // Cancel existing reminder IDs to avoid duplicate alerts
      await cancelDailyReminder();

      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime firstScheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If scheduled time has already passed today, start from tomorrow
      if (firstScheduled.isBefore(now)) {
        firstScheduled = firstScheduled.add(const Duration(days: 1));
      }

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ),
      );

      // Schedule daily recurring reminder (at 8:00 PM)
      final messageIndex =
          (firstScheduled.weekday - 1) % reminderMessages.length;
      final message = reminderMessages[messageIndex];

      await _safeZonedSchedule(
        id: _dailyReminderNotificationId,
        title: 'Your Companion Awaits',
        body: message,
        scheduledDate: firstScheduled,
        details: details,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint(
        '[NotificationService] Scheduled daily reminder (ID $_dailyReminderNotificationId) for ${firstScheduled.toIso8601String()}: "$message"',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error scheduling daily reminder: $e');
    }
  }

  /// Cancel all scheduled daily companion reminders
  static Future<void> cancelDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(_dailyReminderNotificationId);
      for (int i = 1; i <= 7; i++) {
        await _notificationsPlugin.cancel(_baseReminderNotificationId + i);
      }
      for (int i = 1; i <= 20; i++) {
        await _notificationsPlugin.cancel(2000 + i);
      }
      await _notificationsPlugin.cancel(997);
      await _notificationsPlugin.cancel(998);
      await _notificationsPlugin.cancel(999);
      debugPrint('[NotificationService] Cancelled daily companion reminders');
    } catch (e) {
      debugPrint('[NotificationService] Error cancelling reminder: $e');
    }
  }

  /// Show an instant test notification
  static Future<void> showTestNotification({
    String title = 'Your Companion Awaits',
    String? body,
  }) async {
    try {
      if (!_isInitialized) await init();

      final msg = body ?? reminderMessages[0];

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ),
      );

      await _notificationsPlugin.show(999, title, msg, details);
      debugPrint(
        '[NotificationService] Showed instant test notification: $msg',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error showing test notification: $e');
    }
  }

  /// Schedule a quick test notification in N seconds (useful for verifying real-device background wake up)
  static Future<void> scheduleTestReminder({
    int secondsFromNow = 10,
    String title = 'Companion Test Reminder',
    String? body,
  }) async {
    try {
      if (!_isInitialized) await init();

      final now = tz.TZDateTime.now(tz.local);
      final scheduledDate = now.add(Duration(seconds: secondsFromNow));
      final msg = body ?? reminderMessages[0];

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ),
      );

      await _safeZonedSchedule(
        id: 998,
        title: title,
        body: msg,
        scheduledDate: scheduledDate,
        details: details,
      );

      debugPrint(
        '[NotificationService] Scheduled test notification (ID 998) for ${scheduledDate.toIso8601String()} ($secondsFromNow s from now)',
      );
    } catch (e) {
      debugPrint(
        '[NotificationService] Error scheduling test notification: $e',
      );
    }
  }

  /// Schedule a notification reminder for a scheduled workout or medication
  static Future<void> scheduleItemReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    try {
      if (!_isInitialized) await init();

      final now = tz.TZDateTime.now(tz.local);
      final tzScheduled = tz.TZDateTime.from(scheduledAt, tz.local);

      if (tzScheduled.isBefore(now)) {
        debugPrint(
          '[NotificationService] Scheduled time has already passed: $scheduledAt',
        );
        return;
      }

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_activities',
          'Scheduled Activities',
          channelDescription:
              'Reminders for your scheduled workouts and medications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ),
      );

      await _safeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzScheduled,
        details: details,
      );

      debugPrint(
        '[NotificationService] Scheduled reminder ID $id for ${tzScheduled.toIso8601String()}',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error scheduling item reminder: $e');
    }
  }

  /// Cancel a scheduled item reminder by notification ID
  static Future<void> cancelItemReminder(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('[NotificationService] Cancelled item reminder ID: $id');
    } catch (e) {
      debugPrint('[NotificationService] Error cancelling item reminder: $e');
    }
  }
}
