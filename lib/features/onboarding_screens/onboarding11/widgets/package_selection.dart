import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';

class PackageSelectionWidget extends StatelessWidget {
  const PackageSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController11>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(
          () => Column(
            children: [
              GestureDetector(
                onTap: () => controller.selectPackage(PackageType.free),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: themeController.activeTheme.borderColor,
                    borderRadius: BorderRadius.circular(20),
                    border: controller.selectedPackage.value == PackageType.free
                        ? Border.all(
                            color: themeController.activeTheme.borderColor,
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      _buildFigmaRadioButton(
                        selected:
                            controller.selectedPackage.value ==
                            PackageType.free,
                        themeController: themeController,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Free Trial',
                        style: getTextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const Spacer(),
                      _buildGradientText(
                        'Free Trial',
                        fontSize: 20,
                        themeController: themeController,
                      ),
                      Text(
                        ' / 3 days',
                        style: getTextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => controller.selectPackage(PackageType.premium),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: themeController.activeTheme.backgroundGradient,
                    border: Border.all(
                      color: themeController.activeTheme.borderColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildFigmaRadioButton(
                                    selected:
                                        controller.selectedPackage.value ==
                                        PackageType.premium,
                                    themeController: themeController,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Premium',
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  _buildGradientText(
                                    'USD \$9.00',
                                    fontSize: 24,
                                    themeController: themeController,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '/ per months',
                                    style: getTextStyle(
                                      fontSize: 10,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Text(
                                    'Billing: ',
                                    style: getTextStyle(fontSize: 14),
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Monthly',
                                            style: getTextStyle(
                                              fontSize: 13,
                                              color:
                                                  controller
                                                          .selectedBilling
                                                          .value ==
                                                      BillingType.monthly
                                                  ? const Color(0xFFDCAA64)
                                                  : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildFigmaToggle(
                                            controller,
                                            themeController,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Annually',
                                            style: getTextStyle(
                                              fontSize: 13,
                                              color:
                                                  controller
                                                          .selectedBilling
                                                          .value ==
                                                      BillingType.annually
                                                  ? const Color(0xFFDCAA64)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 160,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            image: DecorationImage(
                              image: AssetImage(IconPath.serIcon),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                right: 10,
                                child: Container(
                                  height: 95,
                                  width: 95,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFDCAA64),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      ImagePath.premiumprofile,
                                      fit: BoxFit.cover,
                                      color: themeController
                                          .activeTheme
                                          .accentGoldColor,
                                      colorBlendMode: BlendMode.overlay,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFigmaRadioButton({
    required bool selected,
    required AppThemeController themeController,
  }) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? themeController.activeTheme.borderColor
              : Colors.white,
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? themeController.activeTheme.borderColor
                : Colors.transparent,
            gradient: selected
                ? themeController.activeTheme.progressBarGradient
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaToggle(
    OnboardingController11 controller,
    AppThemeController themeController,
  ) {
    bool isAnnually = controller.selectedBilling.value == BillingType.annually;
    return GestureDetector(
      onTap: () {
        controller.selectBilling(
          isAnnually ? BillingType.monthly : BillingType.annually,
        );
      },
      child: Container(
        width: 40,
        height: 20,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF350404),
          border: Border.all(color: Colors.white24),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isAnnually ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: themeController.activeTheme.progressBarGradient,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientText(
    String text, {
    required double fontSize,
    required AppThemeController themeController,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          themeController.activeTheme.progressBarGradient.createShader(bounds),
      child: Text(
        text,
        style: getTextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
