import 'package:flutter_timezone/flutter_timezone.dart';

class AppTimezoneHelper {
  static String? _cachedTimezone;

  /// Returns user's IANA timezone identifier (e.g. "America/New_York")
  static Future<String> getTimezoneName() async {
    if (_cachedTimezone != null && _cachedTimezone!.isNotEmpty) {
      return _cachedTimezone!;
    }
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final identifier = tzInfo.identifier;
      if (identifier.isNotEmpty) {
        _cachedTimezone = identifier;
        return _cachedTimezone!;
      }
    } catch (_) {}

    try {
      final now = DateTime.now();
      _cachedTimezone = now.timeZoneName.isNotEmpty ? now.timeZoneName : 'UTC';
      return _cachedTimezone!;
    } catch (_) {
      return 'UTC';
    }
  }

  /// Returns today's date string in user's local timezone (format: YYYY-MM-DD)
  static String getTodayDateString([DateTime? date]) {
    final local = (date ?? DateTime.now()).toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Returns standard headers containing x-timezone
  static Future<Map<String, String>> getTimezoneHeaders() async {
    final tz = await getTimezoneName();
    return {
      'x-timezone': tz,
    };
  }
}
