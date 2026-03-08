import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

// ─── XP Service (inline) ────────────────────────────────────────────────────

class _XpService {
  static Future<Map<String, dynamic>> addDailyRewardXP({
    required String accessToken,
    required String refreshToken,
  }) async {
    const String addXP = Urls.addXP;
    try {
      final response = await http.post(
        Uri.parse(addXP),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'xp': 25, 'reason': 'Daily reward collected'}),
      );

      final isSuccess =
          response.statusCode == 200 || response.statusCode == 201;
      debugPrint('XP Response Status: ${response.statusCode}');
      debugPrint('XP Response Body: ${response.body}');

      Map<String, dynamic>? profileData;
      if (isSuccess) {
        try {
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          profileData =
              decoded['logEntry']?['profile'] as Map<String, dynamic>?;
        } catch (e) {
          debugPrint('Failed to parse profile data: $e');
        }
      }

      return {
        'success': isSuccess,
        'statusCode': response.statusCode,
        'body': response.body,
        'profile': profileData,
      };
    } catch (e) {
      debugPrint('XP Service Error: $e');
      return {'success': false, 'statusCode': -1, 'body': 'Error: $e'};
    }
  }
}

// ─── PopUpDialogue ───────────────────────────────────────────────────────────

class PopUpDialogue extends StatefulWidget {
  final VoidCallback? onCollectRewards;
  final String accessToken;
  final String refreshToken;

  const PopUpDialogue({
    super.key,
    this.onCollectRewards,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  State<PopUpDialogue> createState() => _PopUpDialogueState();
}

class _PopUpDialogueState extends State<PopUpDialogue> {
  bool _isLoading = false;

  Future<void> _handleCollectRewards() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final response = await _XpService.addDailyRewardXP(
      accessToken: widget.accessToken,
      refreshToken: widget.refreshToken,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final isSuccess = response['success'] as bool;

    if (isSuccess) {
      debugPrint('✓ XP successfully collected!');
      widget.onCollectRewards?.call();

      final profileData = response['profile'] as Map<String, dynamic>?;
      final totalXp = profileData?['totalEarnXp'] ?? 25;
      final level = profileData?['level'] ?? 1;

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✓ You earned 25 XP!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Total XP: $totalXp | Level: $level',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // ✅ Use addPostFrameCallback to avoid WindowOnBackDispatcher warning.
      // Calling Navigator.pop() directly inside setState/async can race with
      // Flutter's back-gesture dispatcher — deferring to the next frame is safe.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // rootNavigator: true ensures the Dialog itself is popped,
          // not just an inner nested navigator.
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    } else {
      debugPrint(
        '✗ Failed to collect XP. Status: ${response['statusCode']}, Body: ${response['body']}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to collect rewards. Status: ${response['statusCode']}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final Size size = MediaQuery.of(context).size;

        const double baseWidth = 411.42857142857144;
        const double baseHeight = 923.4285714285714;

        double w(double value) => value * size.width / baseWidth;
        double h(double value) => value * size.height / baseHeight;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Jewellery frame behind main container
              Positioned(
                top: h(220),
                left: 0,
                right: 0,
                child: Image.asset(
                  themeController.activeTheme.id == 'adventurer'
                      ? ImagePath.jwelleryAdventure
                      : themeController.activeTheme.id == 'mage'
                      ? ImagePath.jwelleryMage
                      : themeController.activeTheme.id == 'gamer'
                      ? ImagePath.jwelleryGamer
                      : ImagePath.jwelleryReader,
                ),
              ),

              // Main container
              Positioned(
                top: h(220),
                left: w(5),
                right: w(5),
                child: Container(
                  height: h(325),
                  width: w(270),
                  padding: EdgeInsets.only(
                    top: h(33),
                    right: w(12),
                    bottom: h(15),
                    left: w(12),
                  ),
                  decoration: BoxDecoration(
                    color: themeController.activeTheme.popupBackgroundColor,
                    gradient:
                        themeController.activeTheme.popupBackgroundColor == null
                        ? themeController.activeTheme.backgroundGradient
                        : null,
                    borderRadius: BorderRadius.circular(w(40)),
                    border: Border.all(
                      color: themeController.activeTheme.accentGoldColor,
                      width: w(4),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Diamond icon
                      Image.asset(
                        themeController.activeTheme.id == 'adventurer'
                            ? ImagePath.diamondAdventurer
                            : themeController.activeTheme.id == 'mage'
                            ? ImagePath.diamondMage
                            : themeController.activeTheme.id == 'gamer'
                            ? ImagePath.diamondGamer
                            : ImagePath.diamondReader,
                        width: 60,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: h(16)),

                      // Header
                      Text(
                        'DAILY REWARDS',
                        style: getTextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        '"Discipline is the blade - sharpen it daily."',
                        style: getTextStyle(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: .85),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: h(8)),

                      // XP Box
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: w(220)),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: themeController
                                  .activeTheme
                                  .cardBackgroundColor
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+25 XP',
                              style: getTextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h(10)),

                      // Collect Rewards button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(6)),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : CustomButton(
                                label: 'Collect Rewards',
                                onPressed: _handleCollectRewards,
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top frame — rendered last so it sits in front
              Positioned(
                top: h(157),
                left: 0,
                right: 0,
                child: Image.asset(
                  themeController.activeTheme.id == 'adventurer'
                      ? ImagePath.topframeAdventurer
                      : themeController.activeTheme.id == 'mage'
                      ? ImagePath.topframeMage
                      : themeController.activeTheme.id == 'gamer'
                      ? ImagePath.topframeGamer
                      : ImagePath.topframeReader,
                  width: w(290),
                  height: h(98),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
