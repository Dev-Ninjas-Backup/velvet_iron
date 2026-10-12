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

  static const String _channelId = 'companion_reminders';
  static const String _channelName = 'Companion Reminders';
  static const String _channelDescription =
      'Daily reminders to check in with your companion and log your journey.';

  /// Base ID for daily companion reminders (IDs 1001 - 1007 for each weekday)
  static const int _baseReminderNotificationId = 1000;
  static const int _legacyReminderNotificationId = 1001;

  static const String reminderEnabledKey = 'companion_reminder_enabled';

  /// Curated fantasy-themed companion reminder messages rotating throughout the week
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
          importance: Importance.high,
          playSound: true,
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
      }

      // Request iOS Notification Permissions
      if (!kIsWeb && Platform.isIOS) {
        final iosPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

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
      }
    } catch (e) {
      debugPrint(
        '[NotificationService] Error checking exact alarm capability: $e',
      );
    }
    return AndroidScheduleMode.inexactAllowWhileIdle;
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
      // Fallback to inexactAllowWhileIdle if exact failed due to SecurityException
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

  /// Schedule daily notification at the specified local time (default: 8:00 PM / 20:00)
  /// Automatically rotates across fantasy-themed companion reminder messages each day of the week.
  static Future<void> scheduleDailyCompanionReminder({
    int hour = 20,
    int minute = 00,
  }) async {
    try {
      if (!_isInitialized) await init();

      // First cancel existing daily reminder IDs to avoid duplicate alerts
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

      // Schedule 7 recurring weekly reminders (one for each weekday)
      // to ensure a continuous rotating sequence of fantasy messages.
      for (int i = 0; i < 7; i++) {
        final targetDate = firstScheduled.add(Duration(days: i));
        final notifId = _baseReminderNotificationId + targetDate.weekday;
        final message =
            reminderMessages[(targetDate.weekday - 1) %
                reminderMessages.length];

        await _safeZonedSchedule(
          id: notifId,
          title: 'Your Companion Awaits',
          body: message,
          scheduledDate: targetDate,
          details: details,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );

        debugPrint(
          '[NotificationService] Scheduled reminder for weekday ${targetDate.weekday} at ${targetDate.toIso8601String()}: "$message"',
        );
      }
    } catch (e) {
      debugPrint('[NotificationService] Error scheduling daily reminder: $e');
    }
  }

  /// Cancel all scheduled daily companion reminders
  static Future<void> cancelDailyReminder() async {
    try {
      for (int i = 1; i <= 7; i++) {
        await _notificationsPlugin.cancel(_baseReminderNotificationId + i);
      }
      await _notificationsPlugin.cancel(_legacyReminderNotificationId);
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

      await _notificationsPlugin.show(999, title, msg, details);
      debugPrint(
        '[NotificationService] Showed instant test notification: $msg',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error showing test notification: $e');
    }
  }

  /// Schedule a quick test notification in N seconds (useful for verifying background delivery)
  static Future<void> scheduleTestReminder({
    int secondsFromNow = 5,
    String title = 'Your Companion Awaits',
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
        id: 998,
        title: title,
        body: msg,
        scheduledDate: scheduledDate,
        details: details,
      );

      debugPrint(
        '[NotificationService] Scheduled test notification for ${scheduledDate.toIso8601String()} ($secondsFromNow s from now)',
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
