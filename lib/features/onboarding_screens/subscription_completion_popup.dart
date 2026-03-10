import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class SubscriptionCompletionPopup extends StatefulWidget {
  final VoidCallback? onCollectRewards;
  final String? selectedCompanionName;
  final String? selectedCompanionImage;

  const SubscriptionCompletionPopup({
    super.key,
    this.onCollectRewards,
    this.selectedCompanionName,
    this.selectedCompanionImage,
  });

  @override
  State<SubscriptionCompletionPopup> createState() =>
      _SubscriptionCompletionPopupState();
}

class _SubscriptionCompletionPopupState
    extends State<SubscriptionCompletionPopup> {
  bool _isLoading = false;

  Future<void> _handleCollectRewards() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      setState(() => _isLoading = false);

      widget.onCollectRewards?.call();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      EasyLoading.showError('Something went wrong. Please try again.');
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
                            ? ImagePath.congratulations
                            : themeController.activeTheme.id == 'mage'
                            ? ImagePath.congratulations
                            : themeController.activeTheme.id == 'gamer'
                            ? ImagePath.congratulations
                            : ImagePath.congratulations,
                        width: 60,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: h(16)),

                      // Header
                      Text(
                        'Congratulations!',
                        style: getTextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        '"Your subscription is activated and will expire at Sept 15,2025. You can renew or cancel anytime from your profile settings ."',
                        style: getTextStyle(
                          fontSize: 12,
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
                          ),
                        ),
                      ),
                      SizedBox(height: h(10)),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(6)),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : CustomButton(
                                label: 'Finish & Claim ( 25XP)',
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
                        width: w(120),
                        height: h(95),
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
