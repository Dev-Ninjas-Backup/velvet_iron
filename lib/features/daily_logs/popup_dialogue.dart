import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class PopUpDialogue extends StatelessWidget {
  final VoidCallback? onCollectRewards;

  const PopUpDialogue({super.key, this.onCollectRewards});

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
              // Frames remain outside the main container
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
              // Main container with all content inside
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
                      // Diamond
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
                        '“Discipline is the blade - sharpen it daily.”',
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
                      // Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(6)),
                        child: CustomButton(
                          label: 'Collect Rewards',
                          onPressed:
                              onCollectRewards ??
                              () => Get.toNamed(AppRoute.getHomeScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Top frame should be in front
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
