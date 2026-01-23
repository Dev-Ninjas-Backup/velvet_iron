import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding11/controller/onboarding11_controller.dart';

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
          // Free Trial Option
          GestureDetector(
            onTap: () => controller.selectPackage(PackageType.free),
            child: Container(
              height: 57,
              decoration: BoxDecoration(
                color: Color.fromRGBO(53, 4, 4, 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  controller.selectedPackage.value == PackageType.free
                      ? CustomPaint(
                          size: Size(20, 20),
                          painter: GradientBorderPainter(
                            strokeWidth: 1.5,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFDE7BB),
                                Color(0xFF9E6D38),
                                Color(0xFFE9B86E),
                                Color(0xFFE5B46B),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFDE7BB),
                                    Color(0xFF9E6D38),
                                    Color(0xFFE9B86E),
                                    Color(0xFFE5B46B),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                          ),
                        ),
                  SizedBox(width: 12),
                  Text(
                    'Free Trail',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  controller.selectedPackage.value == PackageType.free
                      ? ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Color.fromRGBO(253, 231, 187, 1),
                              Color.fromRGBO(158, 109, 56, 1),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Free Trail',
                            style: getTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Free Trail',
                          style: getTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 249, 248, 246),
                          ),
                        ),
                  SizedBox(width: 4),
                  Text(
                    '/3 days',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Premium Option
          GestureDetector(
            onTap: () => controller.selectPackage(PackageType.premium),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8B5A3C).withValues(alpha: 0.6),
                    Color(0xFF6B4226).withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFFD4AF7A).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              controller.selectedPackage.value ==
                                      PackageType.premium
                                  ? CustomPaint(
                                      size: Size(20, 20),
                                      painter: GradientBorderPainter(
                                        strokeWidth: 1.5,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFDE7BB),
                                            Color(0xFF9E6D38),
                                            Color(0xFFE9B86E),
                                            Color(0xFFE5B46B),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFFDE7BB),
                                                Color(0xFF9E6D38),
                                                Color(0xFFE9B86E),
                                                Color(0xFFE5B46B),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                              SizedBox(width: 10),
                              Text(
                                'Premium',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'USD \$9.00',
                                style: getTextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'per monthly',
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Billing:',
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              SizedBox(width: 12),
                              Obx(
                                () => GestureDetector(
                                  onTap: () => controller.selectBilling(
                                    BillingType.monthly,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Monthly',
                                        style: getTextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              controller
                                                      .selectedBilling
                                                      .value ==
                                                  BillingType.monthly
                                              ? Color(0xFFD4AF7A)
                                              : Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              controller
                                                      .selectedBilling
                                                      .value ==
                                                  BillingType.monthly
                                              ? Color(0xFFD4AF7A)
                                              : Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Obx(
                                () => GestureDetector(
                                  onTap: () => controller.selectBilling(
                                    BillingType.annually,
                                  ),
                                  child: Text(
                                    'Annually',
                                    style: getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          controller.selectedBilling.value ==
                                              BillingType.annually
                                          ? Color(0xFFD4AF7A)
                                          : Colors.white.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFD4AF7A), width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          ImagePath.premiumprofile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                      fontSize: 14,
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
