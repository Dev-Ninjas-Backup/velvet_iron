import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';

class CompanionDialogueEngine {
  static final CompanionDialogueEngine _instance =
      CompanionDialogueEngine._internal();
  factory CompanionDialogueEngine() => _instance;
  CompanionDialogueEngine._internal();

  Map<String, dynamic> _quoteDatabase = {};
  bool _isLoaded = false;
  final Random _random = Random();

  // LRU recent quotes cache to prevent repetitive lines
  final Map<String, List<String>> _recentQuotes = {};
  static const int _lruHistoryLimit = 5;

  /// Load dialogue database from bundled JSON
  Future<void> init() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString(
        'assets/dialogue/companion_quotes.json',
      );
      _quoteDatabase = jsonDecode(jsonString) as Map<String, dynamic>;
      _isLoaded = true;
    } catch (e) {
      _quoteDatabase = {};
    }
  }

  /// Normalize any backend or legacy companion name to the 4 canonical launch characters
  static String normalizeCompanionKey(String rawName) {
    final lower = rawName.toLowerCase();
    if (lower.contains('thyra') || lower.contains('kael') || lower.contains('shield')) {
      return 'thyra';
    } else if (lower.contains('leon') || lower.contains('bram') || lower.contains('ironledger')) {
      return 'general_leon';
    } else if (lower.contains('visepheron') || lower.contains('pyraxis') || lower.contains('mage')) {
      return 'visepheron';
    } else {
      return 'riven';
    }
  }

  /// Get companion display name
  static String getDisplayName(String rawName) {
    final key = normalizeCompanionKey(rawName);
    switch (key) {
      case 'thyra':
        return 'Thyra';
      case 'general_leon':
        return 'General Leon';
      case 'visepheron':
        return 'Visepheron';
      case 'riven':
      default:
        return 'Riven';
    }
  }

  /// Get companion official title from character quote packs
  static String getDisplayTitle(String rawName) {
    final key = normalizeCompanionKey(rawName);
    switch (key) {
      case 'thyra':
        return 'Shield of the Realm';
      case 'general_leon':
        return 'Commander of the Legions';
      case 'visepheron':
        return 'Ancient Dragon';
      case 'riven':
      default:
        return 'High Lord of the Forsaken Court';
    }
  }

  /// Get companion official voice description from quote packs
  static String getVoiceDescription(String rawName) {
    final key = normalizeCompanionKey(rawName);
    switch (key) {
      case 'thyra':
        return 'Warm, formidable paladin and warrior. Protective, honorable, grounded, encouraging. Speaks to the user as an equal warrior; firm without shame or drill-sergeant cruelty.';
      case 'general_leon':
        return 'Disciplined, tactical, concise, dry humor. High standards without cruelty. Treats rest and setbacks as strategic variables, not moral failures. Praise is sparse and earned.';
      case 'visepheron':
        return 'Ancient, wise, patient, dryly amused, slightly paternal without infantilizing. Speaks with elegant gravity. Has witnessed kingdoms rise and fall; values persistence over urgency.';
      case 'riven':
      default:
        return 'Seductive, sarcastic, clever, slightly dangerous, occasionally unhinged, secretly supportive. Praise is often disguised as teasing. Gender-neutral and orientation-neutral.';
    }
  }

  /// Get companion portrait image asset path
  static String getPortraitPath(String rawName) {
    final key = normalizeCompanionKey(rawName);
    switch (key) {
      case 'thyra':
        return ImagePath.thyra;
      case 'general_leon':
        return ImagePath.generalLeon;
      case 'visepheron':
        return ImagePath.visepheron;
      case 'riven':
      default:
        return ImagePath.riven;
    }
  }

  /// Get companion full body image asset path
  static String getFullBodyPath(String rawName) {
    final key = normalizeCompanionKey(rawName);
    switch (key) {
      case 'thyra':
        return ImagePath.thyraFull;
      case 'general_leon':
        return ImagePath.generalLeonFull;
      case 'visepheron':
        return ImagePath.visepheronFull;
      case 'riven':
      default:
        return ImagePath.rivenFull;
    }
  }

  /// Display an in-character HUD toast for any event in the app
  static Future<void> showDialogueSnackbar({
    required String trigger,
    String? companionName,
    Duration duration = const Duration(seconds: 5),
  }) async {
    try {
      final homeController = Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : null;
      final cached = await SharedPreferencesHelper.getActiveCompanion();
      final effectiveName = companionName ??
          homeController?.activeCompanionName.value ??
          cached?['name'] ??
          'Thyra';

      final quote = await CompanionDialogueEngine().getDialogue(
        trigger: trigger,
        companionName: effectiveName,
      );
      final portrait = getPortraitPath(effectiveName);
      final displayName = getDisplayName(effectiveName);
      final displayTitle = getDisplayTitle(effectiveName);

      debugPrint(
        '[CompanionDialogueEngine] Displaying banner for $displayName: "$quote"',
      );

      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: EdgeInsets.zero,
        borderRadius: 16,
        duration: duration,
        animationDuration: const Duration(milliseconds: 350),
        messageText: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B1E29), Color(0xFF10121A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFECC266), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFFECC266).withValues(alpha: 0.18),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Prominent Companion Bust (72x72)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFECC266), width: 2),
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFECC266).withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    portrait,
                    fit: BoxFit.cover,
                    width: 72,
                    height: 72,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      color: Color(0xFFECC266),
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Companion Dialogue Content
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              color: Color(0xFFECC266),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECC266).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFECC266).withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            displayTitle,
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"$quote"',
                      style: const TextStyle(
                        color: Color(0xFFF1E5CD),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.25,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('[CompanionDialogueEngine] Error showing snackbar: $e');
    }
  }

  /// Fetch a contextual dialogue line for the active companion
  Future<String> getDialogue({
    required String trigger,
    String? companionName,
  }) async {
    if (!_isLoaded) await init();

    // Determine companion
    String effectiveName = companionName ?? '';
    if (effectiveName.isEmpty) {
      effectiveName = await SharedPreferencesHelper.getActiveThemeName() ?? 'Riven';
    }
    final charKey = normalizeCompanionKey(effectiveName);

    final charData = _quoteDatabase[charKey] as Map<String, dynamic>?;
    if (charData == null || charData['triggers'] == null) {
      return _defaultFallback(charKey, trigger);
    }

    final triggersMap = charData['triggers'] as Map<String, dynamic>;

    // 5% Easter egg chance for Rare Lines on milestone/open triggers
    if (_random.nextDouble() < 0.05 && triggersMap.containsKey('Rare Lines')) {
      final rareList = List<String>.from(triggersMap['Rare Lines'] as List);
      if (rareList.isNotEmpty) {
        return rareList[_random.nextInt(rareList.length)];
      }
    }

    // Intelligent contextual trigger resolution (e.g. morning vs night for open)
    String effectiveTrigger = trigger;
    if (trigger.toLowerCase().contains('open') ||
        trigger.toLowerCase().contains('welcome')) {
      final hour = DateTime.now().hour;
      if (hour >= 5 && hour < 11 && _random.nextBool() && triggersMap.containsKey('Morning')) {
        effectiveTrigger = 'Morning';
      } else if ((hour >= 21 || hour < 4) &&
          _random.nextBool() &&
          triggersMap.containsKey('Night / Signing Off')) {
        effectiveTrigger = 'Night / Signing Off';
      }
    }

    // Match requested trigger
    List<String>? candidates;
    for (var entry in triggersMap.entries) {
      if (entry.key.toLowerCase().contains(effectiveTrigger.toLowerCase()) ||
          effectiveTrigger.toLowerCase().contains(entry.key.toLowerCase())) {
        candidates = List<String>.from(entry.value as List);
        break;
      }
    }

    if (candidates == null || candidates.isEmpty) {
      // Try App Open
      candidates = List<String>.from(triggersMap['App Open / Welcome Back'] ?? []);
    }

    if (candidates.isEmpty) {
      return _defaultFallback(charKey, trigger);
    }

    // Filter by LRU cache
    final cacheKey = '$charKey:$trigger';
    final recent = _recentQuotes[cacheKey] ?? [];
    final available = candidates.where((q) => !recent.contains(q)).toList();

    final selectedList = available.isNotEmpty ? available : candidates;
    final selectedQuote = selectedList[_random.nextInt(selectedList.length)];

    // Update LRU cache
    recent.add(selectedQuote);
    if (recent.length > _lruHistoryLimit) {
      recent.removeAt(0);
    }
    _recentQuotes[cacheKey] = recent;

    return selectedQuote;
  }

  String _defaultFallback(String charKey, String trigger) {
    switch (charKey) {
      case 'thyra':
        return 'Stand tall and hold the line. Discipline is your armor.';
      case 'general_leon':
        return 'Orders received. Execute with precision and purpose.';
      case 'visepheron':
        return 'Knowledge without application is illusion. Forge your power.';
      case 'riven':
      default:
        return 'Back again? Come along, your empire won\'t build itself.';
    }
  }
}
