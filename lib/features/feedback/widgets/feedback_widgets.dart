import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/feedback/controller/feedback_controller.dart';

class FeedbackAppBar extends StatelessWidget {
  final double size;

  const FeedbackAppBar({this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF512212), Color(0xFF512212)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: size * 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Feedback & Support',
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class FeedbackWidget extends StatelessWidget {
  const FeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedbackController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feedback',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Text(
                'Rating: ',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),

              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => controller.updateRating(index + 1),
                    child: Obx(
                      () => Container(
                        height: 18,
                        width: 18,
                        margin: const EdgeInsets.only(right: 3),
                        child: Image.asset(
                          IconPath.ratings,
                          color: controller.rating.value > index
                              ? const Color(0xFFE2B05E)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  'Rating: (${controller.rating.value})',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            'Feedback:',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF3A0303).withValues(alpha: 1.0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6B1717), width: 1),
            ),
            child: TextField(
              controller: controller.feedbackTextController,
              maxLines: 5,
              style: getTextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: "Describe your opinion...",
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpAndSupportWidget extends StatelessWidget {
  const HelpAndSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedbackController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help & Support',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Join our discord community channel for instant help & more connectivity with a wide range of people like you.',
            style: getTextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => controller.joinDiscord(),
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(IconPath.discordwhite, height: 18.38, width: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Join Discord Community',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}
