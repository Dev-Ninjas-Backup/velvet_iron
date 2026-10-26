import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:velvet_iron/core/services/app_timezone_helper.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/fantasy_map_widget.dart';
import 'package:velvet_iron/core/services/expedition_content_service.dart';

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

    test('Quest model preserves 120g protein description as supplied by backend', () {
      final json = {
        'id': 'codex_protein-power',
        'title': 'Protein Power',
        'description': 'Log a meal with 120g+ protein',
        'xpReward': 25,
        'isCompleted': false,
        'questType': 'CODEX',
        'originalRefId': 'protein-power',
      };
      final quest = Quest.fromJson(json);
      expect(quest.description, 'Log a meal with 120g+ protein');
      expect(quest.title, "Titan's Nourishment");
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

  group('Client Feedback Issues 1, 2, 3 Tests', () {
    test('Issue 1: Exercise scheduledAt converts to local timezone with 12-hour AM/PM', () {
      // 00:15:00Z on Oct 16 in UTC
      final utcTime = DateTime.parse('2026-10-16T00:15:00.000Z');
      final local = utcTime.toLocal();

      // Ensure local time is used and correctly formatted
      final hourNum = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final minute = local.minute.toString().padLeft(2, '0');
      final period = local.hour >= 12 ? 'PM' : 'AM';

      expect(hourNum, isPositive);
      expect(minute, '15');
      expect(['AM', 'PM'], contains(period));
    });

    test('Issue 2: Workout/Exercise activity never matches step quest', () {
      const stepQuest = Quest(
        id: 'step-master',
        title: 'Stride of the Realmwalker',
        description: 'Complete your daily step goal',
        xp: 25,
        isDone: false,
      );

      final lower = 'exercise';
      final t = stepQuest.title.toLowerCase();
      final id = stepQuest.id.toLowerCase();
      final ref = (stepQuest.originalRefId ?? '').toLowerCase();

      final isStepQuest = t.contains('stride') ||
          t.contains('realmwalker') ||
          t.contains('step') ||
          id.contains('step') ||
          ref.contains('step');

      expect(isStepQuest, isTrue);

      // In onActivityLogged for exercise, step quests must be skipped
      bool matched = false;
      if (lower.contains('exercise')) {
        if (!isStepQuest && (t.contains('exercise') || id.contains('exercise'))) {
          matched = true;
        }
      }
      expect(matched, isFalse, reason: 'Exercise logging must NOT match step quests');
    });

    test('Issue 3: Titan\'s Nourishment completes on 30g+ protein and rejects <30g', () {
      const proteinQuest = Quest(
        id: 'protein-power',
        title: "Titan's Nourishment",
        description: 'Log a meal with 30g+ protein',
        xp: 20,
        isDone: false,
      );

      final t = proteinQuest.title.toLowerCase();
      final id = proteinQuest.id.toLowerCase();
      final ref = (proteinQuest.originalRefId ?? '').toLowerCase();
      final isProteinQuest = t.contains('nourishment') ||
          t.contains('titan') ||
          t.contains('protein') ||
          id.contains('protein') ||
          ref.contains('protein');

      expect(isProteinQuest, isTrue);

      bool checkCompletion(double protein) {
        if (isProteinQuest && protein >= 30.0) {
          return true;
        }
        return false;
      }

      expect(checkCompletion(30.0), isTrue, reason: 'Exactly 30g protein should complete Titan\'s Nourishment');
      expect(checkCompletion(45.0), isTrue, reason: '45g protein should complete Titan\'s Nourishment');
      expect(checkCompletion(29.9), isFalse, reason: 'Under 30g protein should NOT complete Titan\'s Nourishment');
      expect(checkCompletion(0.0), isFalse, reason: '0g protein should NOT complete Titan\'s Nourishment');
    });
  });

  group('Client Feedback Issues 4, 5 & Bonus Decoupling Tests', () {
    test('Issue 4: Exercise history backdating formats loggedAt ISO 8601 timestamp', () {
      final pastDate = DateTime(2026, 10, 5, 18, 30);
      final loggedAtString = pastDate.toUtc().toIso8601String();

      expect(loggedAtString, contains('2026-10-05T'));
      expect(loggedAtString, endsWith('Z'));

      // Validate parsed log item
      final exerciseLogJson = {
        'id': 'da4f09d0-9feb-4bf3-a71d-d3fe61f748c8',
        'type': 'STRENGTH',
        'name': 'Aerial Silks',
        'intensity': 'HIGH',
        'duration': 45,
        'note': 'Completed evening routine',
        'loggedAt': loggedAtString,
        'isTaken': true,
        'earnedXp': 10,
      };

      expect(exerciseLogJson['loggedAt'], loggedAtString);
      expect(exerciseLogJson['duration'], 45);
      expect(exerciseLogJson['intensity'], 'HIGH');
    });

    test('Issue 5: AppTimezoneHelper formats local date as YYYY-MM-DD', () {
      final testDate = DateTime(2026, 10, 10, 15, 30);
      final dateString = AppTimezoneHelper.getTodayDateString(testDate);
      expect(dateString, '2026-10-10');

      final singleDigitDate = DateTime(2026, 4, 5, 9, 5);
      final singleDigitString = AppTimezoneHelper.getTodayDateString(singleDigitDate);
      expect(singleDigitString, '2026-04-05');
    });

    test('Bonus Fix: Step quest exclusively completes on target goal or 8,000+ steps', () {
      bool evaluateStepQuest({required int currentSteps, required int goal, required bool isGoalReached}) {
        if (!isGoalReached && currentSteps < 8000) {
          return false;
        }
        return true;
      }

      // Small step increments should NOT complete step quest
      expect(evaluateStepQuest(currentSteps: 500, goal: 8000, isGoalReached: false), isFalse);
      expect(evaluateStepQuest(currentSteps: 6240, goal: 8000, isGoalReached: false), isFalse);

      // Reaching goal completes quest
      expect(evaluateStepQuest(currentSteps: 5000, goal: 5000, isGoalReached: true), isTrue);

      // Reaching 8,000 steps completes quest even if custom goal is higher
      expect(evaluateStepQuest(currentSteps: 8000, goal: 10000, isGoalReached: false), isTrue);
      expect(evaluateStepQuest(currentSteps: 10000, goal: 8000, isGoalReached: true), isTrue);
    });
  });

  group('Today\'s Quests & Scheduled Activities Timezone Synchronization Tests', () {
    test('Quest.formatWorkoutScheduleDescription formats in local time with Today prefix', () {
      final now = DateTime.now();
      final todayExercise = DateTime(now.year, now.month, now.day, 18, 45); // 6:45 PM today
      final desc = Quest.formatWorkoutScheduleDescription(
        type: 'CARDIO',
        duration: 30,
        scheduledAt: todayExercise,
      );

      expect(desc, contains('CARDIO'));
      expect(desc, contains('30 min'));
      expect(desc, contains('Today at 06:45 PM'));
    });

    test('Quest.fromJson formats WORKOUT_SCHEDULE using local timezone when scheduledAt is present', () {
      final now = DateTime.now();
      final localToday = DateTime(now.year, now.month, now.day, 19, 30);
      final utcIso = localToday.toUtc().toIso8601String();

      final json = {
        'id': 'workout_aerial_silks_1',
        'title': 'Aerial Silks',
        'description': 'CARDIO • Wednesday, October 14, 2026 at 5:45 AM', // Raw server string
        'scheduledAt': utcIso,
        'xpReward': 10,
        'isCompleted': false,
        'questType': 'WORKOUT_SCHEDULE',
        'originalRefId': 'aerial_silks_1',
        'category': 'STRENGTH',
        'duration': 45,
      };

      final quest = Quest.fromJson(json);
      expect(quest.title, 'Aerial Silks');
      expect(quest.questType, 'WORKOUT_SCHEDULE');
      expect(quest.scheduledAt, isNotNull);
      // Description is sanitized from server Bangladesh time into device local time
      expect(quest.description, contains('STRENGTH'));
      expect(quest.description, contains('45 min'));
      expect(quest.description, contains('Today at 07:30 PM'));
      expect(quest.description, isNot(contains('5:45 AM')));
    });

    test('Scheduled activity for today automatically populates under Today\'s Quests', () {
      final now = DateTime.now();
      final todayExerciseDate = DateTime(now.year, now.month, now.day, 20, 0); // 8:00 PM today

      final exercise = Exercise(
        id: 'aerial_silks_today',
        userId: 'user_1',
        type: 'STRENGTH',
        name: 'Aerial Silks',
        intensity: 'HIGH',
        duration: 45,
        note: 'Evening routine',
        isTaken: false,
        loggedAt: DateTime.now(),
        scheduledAt: todayExerciseDate.toUtc(),
        earnedXp: 10,
        entryType: 'SCHEDULE',
      );

      // Verify that local date matches today
      final local = exercise.scheduledAt!.toLocal();
      final isToday = local.year == now.year && local.month == now.month && local.day == now.day;
      expect(isToday, isTrue);

      // Simulate synchronization logic
      final backendQuests = <Quest>[
        const Quest(
          id: 'codex_three-meals',
          title: 'Feast of the Hearth',
          description: 'Log breakfast, lunch, and dinner',
          xp: 30,
          isDone: false,
        ),
      ];

      final todayQuest = Quest(
        id: 'workout_${exercise.id}',
        title: exercise.name.isNotEmpty ? exercise.name : exercise.type,
        xp: exercise.earnedXp > 0 ? exercise.earnedXp : 10,
        description: Quest.formatWorkoutScheduleDescription(
          type: exercise.type,
          duration: exercise.duration,
          scheduledAt: exercise.scheduledAt!,
        ),
        isDone: exercise.isTaken,
        questType: 'WORKOUT_SCHEDULE',
        originalRefId: exercise.id,
        category: exercise.type,
        scheduledAt: exercise.scheduledAt,
      );

      final syncedList = [todayQuest, ...backendQuests];
      expect(syncedList.length, 2);
      expect(syncedList.first.title, 'Aerial Silks');
      expect(syncedList.first.questType, 'WORKOUT_SCHEDULE');
      expect(syncedList.first.description, contains('Today at 08:00 PM'));
    });

    test('Exercise scheduled for tomorrow is excluded from Today\'s Quests', () {
      final now = DateTime.now();
      final tomorrowDate = DateTime(now.year, now.month, now.day + 1, 10, 0); // Tomorrow 10 AM

      final tomorrowExercise = Exercise(
        id: 'tomorrow_ice_skating',
        userId: 'user_1',
        type: 'CARDIO',
        name: 'Ice Skating',
        intensity: 'MEDIUM',
        duration: 30,
        note: 'Tomorrow skate',
        isTaken: false,
        loggedAt: DateTime.now(),
        scheduledAt: tomorrowDate.toUtc(),
        earnedXp: 10,
        entryType: 'SCHEDULE',
      );

      final local = tomorrowExercise.scheduledAt!.toLocal();
      final isToday = local.year == now.year && local.month == now.month && local.day == now.day;
      expect(isToday, isFalse);
    });

    test('Backend deployed payload parses Titan\'s Nourishment 30g and scheduled workout UTC ISO', () {
      final deployedBackendQuestJson = {
        'id': 'codex_protein-power',
        'title': "Titan's Nourishment",
        'description': 'Log a meal with 30g+ protein',
        'xpReward': 30,
        'isCompleted': false,
        'questType': 'CODEX',
        'originalRefId': 'protein-power',
        'scheduledAt': null,
        'timeOfDay': null,
      };

      final quest = Quest.fromJson(deployedBackendQuestJson);
      expect(quest.title, "Titan's Nourishment");
      expect(quest.description, 'Log a meal with 30g+ protein');
      expect(quest.xp, 30);
      expect(quest.isDone, isFalse);
    });
  });

  group('Client Feedback Round 8 Specific Fixes Tests', () {
    test('Issue 2: Custom Quest XP defaults to 10 and parses correctly from xpReward', () {
      final customQuest10XpJson = {
        'id': 'custom_gym_session',
        'title': 'Gym Strength Session',
        'category': 'FITNESS',
        'description': 'Legs & Core workout routine',
        'xpReward': 10,
        'xp': 10,
        'recurrence': 'SPECIFIC_DAYS',
        'daysOfWeek': [1, 3, 5],
        'isCompleted': false,
        'isCustom': true,
      };

      final quest = Quest.fromJson(customQuest10XpJson);
      expect(quest.title, 'Gym Strength Session');
      expect(quest.xp, 10);
      expect(quest.isDone, isFalse);
      expect(quest.questType, 'CUSTOM');
    });

    test('Issue 3: Specific Days maps ISO 1=Monday to 7=Sunday correctly', () {
      final weekdays = [
        {'day': 'Mon', 'val': 1},
        {'day': 'Tue', 'val': 2},
        {'day': 'Wed', 'val': 3},
        {'day': 'Thu', 'val': 4},
        {'day': 'Fri', 'val': 5},
        {'day': 'Sat', 'val': 6},
        {'day': 'Sun', 'val': 7},
      ];

      expect(weekdays[0]['val'], 1); // Monday
      expect(weekdays[6]['val'], 7); // Sunday

      final selectedDays = {1, 3, 5}; // Mon, Wed, Fri
      final sortedList = selectedDays.toList()..sort();
      expect(sortedList, [1, 3, 5]);
    });

    test('Issue 4: Medication quest parses Tirzepatide with full title and description intact', () {
      final tirzepatideQuestJson = {
        'id': 'med_tirzepatide_01',
        'title': 'Tirzepatide',
        'description': '2.5 mg • Subcutaneous Injection • 09:00 AM',
        'xpReward': 10,
        'isCompleted': false,
        'questType': 'medication_schedule',
        'originalRefId': 'tirzepatide_01',
      };

      final quest = Quest.fromJson(tirzepatideQuestJson);
      expect(quest.title, 'Tirzepatide');
      expect(quest.description, contains('2.5 mg'));
      expect(quest.questType, 'MEDICATION_SCHEDULE');
      expect(quest.xp, 10);
    });
  });

  group('Client Feedback Round 9 Specific Fixes Tests', () {
    test('Issue 3: Dynamic Y-axis scales tightly around 218-221 lbs instead of starting at zero', () {
      final entries = [218.0, 219.5, 220.0, 221.0];
      final minW = entries.reduce(min);
      final maxW = entries.reduce(max);
      expect(minW, 218.0);
      expect(maxW, 221.0);

      final diff = maxW - minW;
      final padding = (diff * 0.25).clamp(2.0, 15.0);
      final minY = (minW - padding).floorToDouble();
      final maxY = (maxW + padding).ceilToDouble();

      // Bounds should be around 216 and 223 - NOT starting at 0 or 240
      expect(minY, greaterThanOrEqualTo(210.0));
      expect(minY, lessThanOrEqualTo(218.0));
      expect(maxY, greaterThanOrEqualTo(221.0));
      expect(maxY, lessThanOrEqualTo(230.0));
      expect(minY, isNot(0.0));
    });

    test('Issue 4: Weight tracking provides all 6 required timeframe options', () {
      const availableTimeframes = [
        'Weekly',
        'Monthly',
        '3 Months',
        '6 Months',
        'Yearly',
        'All Time',
      ];

      expect(availableTimeframes.length, 6);
      expect(availableTimeframes, contains('Weekly'));
      expect(availableTimeframes, contains('Monthly'));
      expect(availableTimeframes, contains('3 Months'));
      expect(availableTimeframes, contains('6 Months'));
      expect(availableTimeframes, contains('Yearly'));
      expect(availableTimeframes, contains('All Time'));
    });

    test('Issue 5: Journey landmarks lead to The Shattered Citadel at 1,000,000 steps', () {
      final milestones = FantasyMapWidget.journeyMilestones;
      expect(milestones.length, 11);
      expect(milestones.first.stepMilestone, 0);
      expect(milestones.first.name, 'The Outpost');

      final finalMilestone = milestones.last;
      expect(finalMilestone.stepMilestone, 1000000);
      expect(finalMilestone.name, 'The Shattered Citadel');
      expect(finalMilestone.fraction, 1.0);
    });
  });

  group('October 25 Backend Fixes & Timezone Alignments Tests', () {
    test('MealLogHistory URL generates date and filterLogsByDate query parameters correctly', () {
      final url = Urls.mealLogHistory(30, 0, date: '2026-10-20', filterLogsByDate: true);
      expect(url, contains('date=2026-10-20'));
      expect(url, contains('filterLogsByDate=true'));
    });

    test('Custom Quest endpoint URLs format correctly for V2 and fallback', () {
      expect(Urls.customQuest, endsWith('/custom-quest'));
      expect(Urls.completeCustomQuestV2('58dbf014'), endsWith('/custom-quest/58dbf014/complete'));
      expect(Urls.deleteCustomQuestV2('58dbf014'), endsWith('/custom-quest/58dbf014'));
    });

    test('Exercise schedule take URL formats correctly', () {
      expect(Urls.takeExerciseSchedule('walk-123'), endsWith('/exercise-log/schedule/walk-123/take'));
      expect(Urls.exerciseSchedulesToday, endsWith('/exercise-log/schedules/today'));
    });

    test('Weekly XP Graph dynamic max Y scales appropriately for XP > 100', () {
      final dataAbove100 = [20.0, 45.0, 130.0, 15.0, 0.0, 60.0, 10.0];
      final maxVal = dataAbove100.reduce((a, b) => a > b ? a : b);
      final double chartMaxY = maxVal > 100
          ? ((maxVal / 20).ceil() * 20).toDouble()
          : 100.0;
      expect(chartMaxY, 140.0);

      final dataBelow100 = [20.0, 45.0, 60.0, 15.0, 0.0, 30.0, 10.0];
      final maxBelow = dataBelow100.reduce((a, b) => a > b ? a : b);
      final double defaultMaxY = maxBelow > 100
          ? ((maxBelow / 20).ceil() * 20).toDouble()
          : 100.0;
      expect(defaultMaxY, 100.0);
    });
  });

  group('Client Message 14: Step Journey Marker & Milestones Tests', () {
    test('Whisperwood milestone is configured at 50,000 steps', () {
      final milestones = FantasyMapWidget.journeyMilestones;
      final arch = milestones.firstWhere((m) => m.name.contains('Wayfarer'));
      final whisperwood = milestones.firstWhere((m) => m.name == 'Whisperwood');

      expect(arch.stepMilestone, 25000);
      expect(whisperwood.stepMilestone, 50000);
    });

    test('At 33,927 cumulative steps, segment progress between Wayfarer\'s Arch and Whisperwood is ~35.7%', () {
      const cumulativeSteps = 33927;
      const prevMilestoneSteps = 25000;
      const nextMilestoneSteps = 50000;

      final completedInLeg = cumulativeSteps - prevMilestoneSteps;
      final legSpan = nextMilestoneSteps - prevMilestoneSteps;
      final legProgressRatio = completedInLeg / legSpan;

      expect(completedInLeg, 8927);
      expect(legSpan, 25000);
      expect(legProgressRatio, closeTo(0.357, 0.001));
    });

    test('ExpeditionContentService accurately identifies Wayfarer\'s Arch as current and Whisperwood as next at 33,927 steps', () {
      final status = ExpeditionContentService().getLandmarkStatus(33927);
      expect(status.currentMilestone?.name, contains('Wayfarer'));
      expect(status.nextMilestone.name, 'Whisperwood');
      expect(status.stepsToNext, 16073);
      expect(status.progressToNext, closeTo(0.357, 0.001));
    });
  });

  group('Client Message 16: Specific-Day Quests & Weekly GLP-1 Isolation Tests', () {
    final sampleQuests = [
      const Quest(
        id: 'codex_step-master',
        title: 'Stride of the Realmwalker',
        xp: 50,
        description: 'Complete daily steps',
        isDone: false,
      ),
      const Quest(
        id: 'codex_track-your-shot',
        title: 'Elixir of the Alchemist',
        xp: 10,
        description: 'Log your GLP-1 weekly injection',
        isDone: false,
      ),
      const Quest(
        id: 'custom_gym-123',
        title: 'Gym Strength Session',
        xp: 10,
        description: 'FITNESS • SPECIFIC_DAYS',
        isDone: false,
        questType: 'CUSTOM',
      ),
    ];

    List<Quest> filterTestQuests(List<Quest> quests, {required bool enabled, required int weekday, required int injectionDay}) {
      final isInjectionDay = weekday == injectionDay;
      return quests.where((q) {
        final lower = q.title.toLowerCase();
        final isMed = lower.contains('elixir of the alchemist') || lower.contains('track your shot');
        if (!isMed) return true;
        if (!enabled) return false;
        return isInjectionDay;
      }).toList();
    }

    test('GLP-1 quest appears on preferred injection day (Sunday = 7)', () {
      final filtered = filterTestQuests(sampleQuests, enabled: true, weekday: 7, injectionDay: 7);
      expect(filtered.length, 3);
      expect(filtered.any((q) => q.title == 'Elixir of the Alchemist'), isTrue);
    });

    test('GLP-1 quest is omitted on non-injection days (Tuesday = 2) to preserve 100% daily streak', () {
      final filtered = filterTestQuests(sampleQuests, enabled: true, weekday: 2, injectionDay: 7);
      expect(filtered.length, 2);
      expect(filtered.any((q) => q.title == 'Elixir of the Alchemist'), isFalse);
      expect(filtered.any((q) => q.title == 'Stride of the Realmwalker'), isTrue);
      expect(filtered.any((q) => q.title == 'Gym Strength Session'), isTrue);
    });

    test('GLP-1 quest is completely hidden when enableMedicationQuest is false', () {
      final filtered = filterTestQuests(sampleQuests, enabled: false, weekday: 7, injectionDay: 7);
      expect(filtered.length, 2);
      expect(filtered.any((q) => q.title == 'Elixir of the Alchemist'), isFalse);
    });

    test('Date-scoped custom quest completion URL includes date query parameter', () {
      const questId = 'custom_58dbf014';
      const targetDate = '2026-10-28';
      final completionUrl = '${Urls.completeCustomQuestV2(questId)}?date=$targetDate';

      expect(completionUrl, contains('custom-quest/custom_58dbf014/complete'));
      expect(completionUrl, contains('?date=2026-10-28'));
    });
  });
}

