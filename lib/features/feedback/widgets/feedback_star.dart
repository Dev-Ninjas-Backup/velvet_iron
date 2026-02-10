import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/feedback/controller/feedback_controller.dart';

class FeedbackWidget extends StatelessWidget {
  const FeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedbackController>();
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
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
                                  ? themeController.activeTheme.accentGoldColor
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
                  color: themeController.activeTheme.cardBackgroundColor
                      .withValues(alpha: 1.0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeController.activeTheme.borderColor,
                    width: 1,
                  ),
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
      },
    );
  }
}