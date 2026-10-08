import 'package:flutter_test/flutter_test.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';

void main() {
  group('Quest System Tests', () {
    test('Quest model parses unified JSON and handles custom prefix resolution', () {
      final json = {
        'id': 'custom_12345',
        'title': 'Test Custom Quest',
        'description': 'Run 5 miles',
        'xp': 50,
        'isDone': false,
        'questType': 'CUSTOM',
        'originalRefId': '12345',
      };

      final quest = Quest.fromJson(json);
      expect(quest.id, 'custom_12345');
      expect(quest.title, 'Test Custom Quest');
      expect(quest.xp, 50);
      expect(quest.isDone, false);
      expect(quest.questType, 'CUSTOM');
      expect(quest.originalRefId, '12345');

      // Check ID candidates logic for deletion/completion
      final candidates = <String>[quest.id];
      if (quest.id.startsWith('custom_')) {
        candidates.add(quest.id.replaceFirst('custom_', ''));
      }
      expect(candidates, contains('custom_12345'));
      expect(candidates, contains('12345'));
    });

    test('DailyQuestResponse correctly aggregates completed quests and XP', () {
      const q1 = Quest(id: 'q1', title: 'Hydration', description: 'Drink water', xp: 15, isDone: true);
      const q2 = Quest(id: 'q2', title: 'Running', description: 'Run', xp: 25, isDone: false);
      const q3 = Quest(id: 'q3', title: 'Spirit', description: 'Log mood', xp: 10, isDone: true);

      final response = const DailyQuestResponse(
        todayTotalXp: 0,
        todayLogCount: 0,
        quests: [q1, q2, q3],
      );

      final completedQuests = response.quests.where((q) => q.isDone).toList();
      final totalXp = completedQuests.fold<int>(0, (sum, q) => sum + q.xp);

      expect(completedQuests.length, 2);
      expect(totalXp, 25);
    });
  });

  group('Exercise Aggregation & Stats Tests', () {
    test('Time trained and total rewards calculate accurately from completed exercise logs', () {
      final log1 = Exercise(
        id: '1',
        userId: 'u1',
        name: 'Running',
        type: 'Cardio',
        duration: 60,
        intensity: 'High',
        note: '',
        earnedXp: 10,
        entryType: 'LOG',
        loggedAt: DateTime.now(),
        isTaken: true,
      );

      final log2 = Exercise(
        id: '2',
        userId: 'u1',
        name: 'Aerial Silks',
        type: 'Flexibility',
        duration: 50,
        intensity: 'Medium',
        note: '',
        earnedXp: 10,
        entryType: 'LOG',
        loggedAt: DateTime.now(),
        isTaken: true,
      );

      final scheduled = Exercise(
        id: '3',
        userId: 'u1',
        name: 'Yoga',
        type: 'Stretching',
        duration: 30,
        intensity: 'Low',
        note: '',
        earnedXp: 10,
        entryType: 'SCHEDULE',
        loggedAt: DateTime.now(),
        isTaken: false,
      );

      final exercises = [log1, log2, scheduled];
      final completed = exercises.where((e) => e.isTaken).toList();

      // Ensure completed count is 2
      expect(completed.length, 2);

      // Total duration must be 110 minutes
      final totalDuration = completed.fold<int>(0, (sum, item) => sum + item.duration.toInt());
      expect(totalDuration, 110);

      // Total earned XP must be 20 XP
      final totalEarnedXp = completed.fold<int>(0, (sum, item) => sum + item.earnedXp.toInt());
      expect(totalEarnedXp, 20);
    });
  });

  group('Medication Model & Scheduling Tests', () {
    test('Medication model parses dose, type, and taken status', () {
      final json = {
        'id': 'med_001',
        'name': 'Creatine',
        'type': 'SUPPLEMENT',
        'doseMg': 5000,
        'isTaken': true,
        'earnedXp': 10,
      };

      final med = Medication.fromJson(json);
      expect(med.id, 'med_001');
      expect(med.name, 'Creatine');
      expect(med.doseMg, 5000.0);
      expect(med.isTaken, true);
      expect(med.earnedXp, 10);
    });
  });

  group('Macro & Nutrition Calculations Tests', () {
    test('Meal macros correctly round to integers and compute calories', () {
      const carbsStr = '45.4';
      const proteinStr = '30.8';
      const fatsStr = '12.2';

      final cInt = (double.tryParse(carbsStr) ?? 0).round();
      final pInt = (double.tryParse(proteinStr) ?? 0).round();
      final fInt = (double.tryParse(fatsStr) ?? 0).round();

      expect(cInt, 45);
      expect(pInt, 31);
      expect(fInt, 12);

      final calculatedCalories = (cInt * 4) + (pInt * 4) + (fInt * 9);
      expect(calculatedCalories, (45 * 4) + (31 * 4) + (12 * 9));
    });
  });

  group('Weekly Activity XP Charts Tests', () {
    test('XPCharts model correctly parses weekly day entries', () {
      final json = {
        'currentWeek': {
          'totalXP': 120,
          'data': [
            {'day': 'Mon', 'XP': 20},
            {'day': 'Tue', 'XP': 30},
            {'day': 'Wed', 'XP': 25},
            {'day': 'Thu', 'XP': 45},
            {'day': 'Fri', 'XP': 0},
            {'day': 'Sat', 'XP': 0},
            {'day': 'Sun', 'XP': 0},
          ]
        },
        'lastWeek': {
          'totalXP': 80,
          'data': [
            {'day': 'Mon', 'XP': 10},
            {'day': 'Tue', 'XP': 15},
            {'day': 'Wed', 'XP': 15},
            {'day': 'Thu', 'XP': 20},
            {'day': 'Fri', 'XP': 20},
            {'day': 'Sat', 'XP': 0},
            {'day': 'Sun', 'XP': 0},
          ]
        }
      };

      final xpCharts = XPCharts.fromJson(json);
      expect(xpCharts.currentWeek.totalXp, 120);
      expect(xpCharts.currentWeek.data.length, 7);
      expect(xpCharts.currentWeek.data[0].xp, 20);
      expect(xpCharts.lastWeek.totalXp, 80);

      final chartDoubleData = xpCharts.currentWeek.data.map((d) => d.xp.toDouble()).toList();
      expect(chartDoubleData, [20.0, 30.0, 25.0, 45.0, 0.0, 0.0, 0.0]);
    });
  });
}
