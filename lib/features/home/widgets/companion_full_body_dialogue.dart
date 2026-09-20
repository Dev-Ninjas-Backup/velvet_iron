import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';

class CompanionFullBodyDialogue extends StatefulWidget {
  final String companionName;
  final String? customPosePath;
  final String? quote;
  final String contextMoment; // 'daily_greeting', 'quest_complete', 'level_up', 'streak', etc.
  final int xpReward;
  final VoidCallback? onClaim;
  final String? accessToken;
  final String? refreshToken;

  const CompanionFullBodyDialogue({
    super.key,
    required this.companionName,
    this.customPosePath,
    this.quote,
    this.contextMoment = 'daily_greeting',
    this.xpReward = 25,
    this.onClaim,
    this.accessToken,
    this.refreshToken,
  });

  /// Resolve appropriate high-res character pose based on the companion and the interaction moment
  static String resolvePose({
    required String companionName,
    required String contextMoment,
  }) {
    final key = CompanionDialogueEngine.normalizeCompanionKey(companionName);
    switch (key) {
      case 'riven':
        if (contextMoment == 'daily_greeting') {
          return ImagePath.rivenPose3; // Reading ancient grimoire
        } else if (contextMoment == 'level_up' ||
            contextMoment == 'quest_complete' ||
            contextMoment == 'streak') {
          return ImagePath.rivenPose4; // Arcane purple magic flare
        } else {
          return ImagePath.rivenPose1; // Casual confident stance
        }

      case 'thyra':
        if (contextMoment == 'daily_greeting') {
          return ImagePath.thyraPose3; // Warm welcoming smile, hand on hip
        } else if (contextMoment == 'level_up' ||
            contextMoment == 'quest_complete' ||
            contextMoment == 'streak') {
          return ImagePath.thyraPose1; // Sword drawn ready for victory
        } else {
          return ImagePath.thyraPose2; // Crossed arms resolute
        }

      case 'general_leon':
        if (contextMoment == 'daily_greeting') {
          return ImagePath.leonPose4; // Outstretched hand commander salute
        } else if (contextMoment == 'level_up' ||
            contextMoment == 'quest_complete' ||
            contextMoment == 'streak') {
          return ImagePath.leonPose2; // Crossed arms tactical victory
        } else {
          return ImagePath.leonPose1; // Tactical combat ready
        }

      case 'visepheron':
        if (contextMoment == 'daily_greeting') {
          return ImagePath.visepheronPose1; // Standing majestic dragon
        } else if (contextMoment == 'level_up' ||
            contextMoment == 'quest_complete' ||
            contextMoment == 'streak') {
          return ImagePath.visepheronPose2; // Upright proud roar
        } else {
          return ImagePath.visepheronPose3; // Crouching intense
        }

      default:
        return ImagePath.thyraPose3;
    }
  }

  @override
  State<CompanionFullBodyDialogue> createState() =>
      _CompanionFullBodyDialogueState();
}

class _CompanionFullBodyDialogueState extends State<CompanionFullBodyDialogue>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleClaim(BuildContext context) async {
    if (_isLoading.value) return;

    // If there is an XP reward and credentials, call the backend daily log XP endpoint
    if (widget.xpReward > 0 &&
        widget.accessToken != null &&
        widget.refreshToken != null) {
      _isLoading.value = true;
      try {
        final response = await http.post(
          Uri.parse(Urls.dailyLogsXP),
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${widget.accessToken}',
            'x-refresh-token': widget.refreshToken!,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'xp': widget.xpReward}),
        );

        debugPrint('FullBody XP Claim Response: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          await SharedPreferencesHelper.saveLastDailyLoginTimestamp(
            DateTime.now(),
          );
          await SharedPreferencesHelper.markFullBodyGreetingShownToday();

          // Refresh home profile XP
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().fetchData();
          }

          EasyLoading.showSuccess('+${widget.xpReward} XP Collected!');
        }
      } catch (e) {
        debugPrint('Error claiming daily XP in FullBody dialog: $e');
      } finally {
        _isLoading.value = false;
      }
    } else {
      await SharedPreferencesHelper.markFullBodyGreetingShownToday();
    }

    widget.onClaim?.call();

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();
    final size = MediaQuery.of(context).size;
    final poseAsset = widget.customPosePath ??
        CompanionFullBodyDialogue.resolvePose(
          companionName: widget.companionName,
          contextMoment: widget.contextMoment,
        );

    final displayName =
        CompanionDialogueEngine.getDisplayName(widget.companionName);
    final displayTitle =
        CompanionDialogueEngine.getDisplayTitle(widget.companionName);

    String momentHeadline = 'DAILY GREETING';
    if (widget.contextMoment == 'quest_complete') {
      momentHeadline = 'QUESTS COMPLETED!';
    } else if (widget.contextMoment == 'level_up') {
      momentHeadline = 'LEVEL UP!';
    } else if (widget.contextMoment == 'streak') {
      momentHeadline = 'STREAK MILESTONE!';
    }

    final double cardOverlap = widget.xpReward > 0 ? 250.0 : 200.0;
    final double maxCharacterWidth = size.width - 56.0;
    final double maxCharacterHeight = size.height * 0.44;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 1. Full Body / 3/4 Body Companion Character Artwork
              Positioned(
                top: 36,
                bottom: cardOverlap,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Hero(
                    tag: 'full_body_companion',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeController.activeTheme.accentGoldColor
                                .withValues(alpha: 0.22),
                            blurRadius: 50,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxCharacterWidth,
                          maxHeight: maxCharacterHeight,
                        ),
                        child: Image.asset(
                          poseAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Ornate Dialogue & Reward Card (Grounding the character)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10131C).withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: themeController.activeTheme.accentGoldColor,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.7),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Moment Tag & Companion Identity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: themeController.activeTheme.borderColor
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeController.activeTheme.accentGoldColor
                                    .withValues(alpha: 0.6),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              momentHeadline,
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:
                                    themeController.activeTheme.accentGoldColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Companion Name
                      Text(
                        displayName,
                        style: getTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Companion Title
                      Text(
                        displayTitle,
                        style: getTextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ).copyWith(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // In-Character Quote Bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white12,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.quote ??
                              '"Come now. We have great feats to accomplish today."',
                          style: getTextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.95),
                          ).copyWith(height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Daily Reward XP Badge (if applicable)
                      if (widget.xpReward > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                themeController.activeTheme.accentGoldColor
                                    .withValues(alpha: 0.2),
                                themeController.activeTheme.borderColor
                                    .withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: themeController.activeTheme.accentGoldColor
                                  .withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.workspace_premium,
                                color: Color(0xFFFFD700),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Login Reward: +${widget.xpReward} XP',
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Action Button
                      Obx(
                        () => _isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : CustomButton(
                                label: widget.xpReward > 0
                                    ? 'Claim & Begin Today\'s Quests'
                                    : 'Continue Journey',
                                onPressed: () => _handleClaim(context),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Top Close Button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    SharedPreferencesHelper.markFullBodyGreetingShownToday();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: themeController.activeTheme.accentGoldColor,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
