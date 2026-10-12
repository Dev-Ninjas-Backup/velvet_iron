import 'package:flutter_test/flutter_test.dart';
import 'package:velvet_iron/core/services/notification_service.dart';

void main() {
  group('NotificationService Rotation and Configuration Tests', () {
    test('Notification messages list has exactly 5 curated fantasy variations', () {
      expect(NotificationService.reminderMessages.length, 5);
      expect(
        NotificationService.reminderMessages[0],
        "The campfire is burning, traveler. Come reflect on today's journey.",
      );
      expect(
        NotificationService.reminderMessages[1],
        "Another day draws to a close. Your companion awaits you at camp.",
      );
      expect(
        NotificationService.reminderMessages[2],
        "The stars are rising over the realm. Have you recorded today's victories?",
      );
      expect(
        NotificationService.reminderMessages[3],
        "Your journey continues tomorrow, but tonight, the campfire awaits.",
      );
      expect(
        NotificationService.reminderMessages[4],
        "Even the greatest warriors must rest. Return to camp and reflect on your progress.",
      );
    });

    test('Weekday to message rotation maps predictably across 7 days', () {
      // Monday = weekday 1 -> message index 0
      // Tuesday = weekday 2 -> message index 1
      // Wednesday = weekday 3 -> message index 2
      // Thursday = weekday 4 -> message index 3
      // Friday = weekday 5 -> message index 4
      // Saturday = weekday 6 -> message index 0
      // Sunday = weekday 7 -> message index 1
      final messages = NotificationService.reminderMessages;
      for (int weekday = 1; weekday <= 7; weekday++) {
        final messageIndex = (weekday - 1) % messages.length;
        expect(messages[messageIndex], isNotEmpty);
      }

      expect(messages[(1 - 1) % messages.length], contains("The campfire is burning"));
      expect(messages[(2 - 1) % messages.length], contains("Another day draws to a close"));
      expect(messages[(3 - 1) % messages.length], contains("The stars are rising"));
      expect(messages[(4 - 1) % messages.length], contains("Your journey continues tomorrow"));
      expect(messages[(5 - 1) % messages.length], contains("Even the greatest warriors must rest"));
      expect(messages[(6 - 1) % messages.length], contains("The campfire is burning"));
      expect(messages[(7 - 1) % messages.length], contains("Another day draws to a close"));
    });
  });
}
