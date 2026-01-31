import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class StepsTextWidget11 extends StatelessWidget {
  const StepsTextWidget11({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 11 / 11',
            style: getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Image.asset(IconPath.trophy, width: 8, height: 14),
              SizedBox(width: 1.5),
              Text(
                '+10 XP',
                style: getTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressBarWidget11 extends StatelessWidget {
  const ProgressBarWidget11({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController11());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(
        () => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                Container(color: Colors.white.withValues(alpha: 0.2)),
                FractionallySizedBox(
                  widthFactor: controller.progressValue,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFDE7BB),
                          Color(0xFF9E6D38),
                          Color(0xFFE9B86E),
                          Color(0xFF9D6933),
                          Color(0xFFFEE9BF),
                          Color(0xFF683E23),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingHeaderWidget11 extends StatelessWidget {
  const OnboardingHeaderWidget11({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        "Choose package to experience the full potential",
        textAlign: TextAlign.center,
        style: getTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PackageSelectionWidget extends StatelessWidget {
  const PackageSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController11>();

    return Obx(
      () => Column(
        children: [
          GestureDetector(
            onTap: () => controller.selectPackage(PackageType.free),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF350404).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: controller.selectedPackage.value == PackageType.free
                    ? Border.all(color: const Color(0xFFDCAA64), width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  _buildFigmaRadioButton(
                    selected:
                        controller.selectedPackage.value == PackageType.free,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Free Trial',
                    style: getTextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const Spacer(),
                  _buildGradientText('Free Trial', fontSize: 20),
                  Text(
                    ' / 3 days',
                    style: getTextStyle(fontSize: 12, color: Colors.white54),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF4E0101), Color(0xFF2A0101)],
                ),
                border: Border.all(
                  color: const Color(0xFFDCAA64).withValues(alpha: 0.5),
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
                              _buildGradientText('USD \$9.00', fontSize: 24),
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
                                              : Colors.white54,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildFigmaToggle(controller),
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
                                              : Colors.white54,
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
                    flex:
                        1, 
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
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  ImagePath.premiumprofile,
                                  fit: BoxFit.cover,
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
  }

  Widget _buildFigmaRadioButton({required bool selected}) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFFDCAA64) : Colors.white,
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? const Color(0xFFDCAA64) : Colors.transparent,
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFFFDE7BB), Color(0xFF9E6D38)],
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaToggle(OnboardingController11 controller) {
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFDE7BB), Color(0xFF9E6D38)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientText(String text, {required double fontSize}) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFDE7BB), Color(0xFF9E6D38)],
      ).createShader(bounds),
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

class GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;

  GradientBorderPainter({required this.strokeWidth, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MembershipBenefitsWidget extends StatelessWidget {
  const MembershipBenefitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController11>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(IconPath.membershipIcon, height: 20, width: 20),
            SizedBox(width: 8),
            Text(
              'Membership Benefits',
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...controller.benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    benefit,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PopUpDialogue extends StatelessWidget {
  const PopUpDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    const double baseWidth = 411.42857142857144;
    const double baseHeight = 923.4285714285714;

    double w(double value) => value * size.width / baseWidth;
    double h(double value) => value * size.height / baseHeight;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: h(75),
            left: 0,
            right: 0,
            child: Image.asset('assets/images/top.png'),
          ),
          Positioned(
            top: h(450),
            left: w(42),
            right: w(42),
            child: Image.asset('assets/images/bottom.png'),
          ),
          Positioned(
            top: h(220),
            left: w(5),
            right: w(5),
            child: Container(
              height: h(380),
              width: w(320),
              padding: EdgeInsets.only(
                top: h(102),
                right: w(24),
                bottom: h(25),
                left: w(24),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(49, 1, 1, 1),
                    Color.fromRGBO(85, 6, 6, 1),
                    Color.fromRGBO(49, 1, 1, 1),
                    Color.fromRGBO(49, 1, 1, 1),
                    Color.fromRGBO(85, 6, 6, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(w(40)),
                border: Border.all(
                  color: const Color.fromRGBO(233, 184, 110, 1),
                  width: w(4),
                ),
              ),
            ),
          ),
          Positioned(
            top: h(220),
            left: 0,
            right: 0,
            child: Image.asset('assets/images/jwellery.png'),
          ),
          Positioned(
            top: h(135),
            left: 0,
            right: 0,
            child: Image.asset('assets/images/topframe.png'),
          ),
          ////
          Positioned(
            top: h(220),
            left: w(5),
            right: w(5),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: h(45)),
                  Image.asset('assets/images/middleframe.png'),
                  SizedBox(height: h(12)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Congratulations!",
                      style: getTextStyle(
                        fontSize: w(26),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: h(12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(16)),
                    child: Text(
                      "Your subscription is activated and will expire at Sept 15,2025. You can renew or cancel anytime from your profile settings",
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: w(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: h(40)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(30)),
                    child: CustomButton(
                      label: 'Finish & Claim ( 25XP)',
                      onPressed: () => Get.toNamed(AppRoute.getHomeScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ////
        ],
      ),
    );
  }
}
