import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

// ─── Constants ───────────────────────────────────────────────────────────────
const int dailyLoginXpAmount = 25;

// ─── XP Service (inline) ────────────────────────────────────────────────────

class _XpService {
  static Future<Map<String, dynamic>> addDailyRewardXP({
    required String accessToken,
    required String refreshToken,
  }) async {
    const String dailyLoginXP = Urls.dailyLogsXP;
    try {
      final response = await http.post(
        Uri.parse(dailyLoginXP),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'xp': dailyLoginXpAmount}),
      );

      debugPrint('Daily Login XP Response Status: ${response.statusCode}');
      debugPrint('Daily Login XP Response Body: ${response.body}');

      Map<String, dynamic> decoded = {};
      String backendMessage = '';
      Map<String, dynamic>? profileData;

      try {
        decoded = jsonDecode(response.body) as Map<String, dynamic>;
        backendMessage = decoded['message'] as String? ?? '';

        if (response.statusCode == 200 || response.statusCode == 201) {
          profileData =
              decoded['logEntry']?['profile'] as Map<String, dynamic>?;
        }
      } catch (e) {
        debugPrint('Failed to parse response: $e');
      }

      final isSuccess =
          response.statusCode == 200 || response.statusCode == 201;

      return {
        'success': isSuccess,
        'statusCode': response.statusCode,
        'body': response.body,
        'profile': profileData,
        'message': backendMessage,
      };
    } catch (e) {
      debugPrint('XP Service Error: $e');
      return {
        'success': false,
        'statusCode': -1,
        'body': 'Error: $e',
        'message': 'Network error occurred',
      };
    }
  }
}

// ─── PopUpDialogue ───────────────────────────────────────────────────────────

class PopUpDialogue extends StatefulWidget {
  final VoidCallback? onCollectRewards;
  final String accessToken;
  final String refreshToken;
  final String? selectedCompanionName;
  final String? selectedCompanionImage;

  const PopUpDialogue({
    super.key,
    this.onCollectRewards,
    required this.accessToken,
    required this.refreshToken,
    this.selectedCompanionName,
    this.selectedCompanionImage,
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
    final backendMessage = response['message'] as String? ?? '';

    if (isSuccess) {
      debugPrint('✓ XP successfully collected!');

      // Save the current timestamp for 24-hour cooldown
      await SharedPreferencesHelper.saveLastDailyLoginTimestamp(DateTime.now());

      widget.onCollectRewards?.call();

      // Show success toast with backend message or default message
      final message = backendMessage.isNotEmpty
          ? backendMessage
          : '✓ You earned $dailyLoginXpAmount XP!';

      EasyLoading.showSuccess(message, duration: const Duration(seconds: 3));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    } else {
      debugPrint(
        '✗ Failed to collect XP. Status: ${response['statusCode']}, Body: ${response['body']}',
      );

      // Show backend error message or generic error
      final errorMessage = backendMessage.isNotEmpty
          ? backendMessage
          : 'Failed to collect rewards. Status: ${response['statusCode']}';

      EasyLoading.showError(errorMessage);
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

                      Text(
                        'DAILY REWARDS',
                        style: getTextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        '"Discipline is the blade - sharpen it daily."',
                        style: getTextStyle(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: .85),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: h(8)),

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
                              '+$dailyLoginXpAmount XP',
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
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
                    // Companion image displayed in the center of topframe
                    if (widget.selectedCompanionImage != null &&
                        widget.selectedCompanionImage!.isNotEmpty)
                      Image.asset(
                        widget.selectedCompanionImage!,
                        width: w(80),
                        height: h(80),
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
