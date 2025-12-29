import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';

class MealLog extends StatelessWidget {
  const MealLog({super.key, required this.controller});

  final DailyLogController controller;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              children: [
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF521212),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Daily Logs",
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(ImagePath.magicImage, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Weight Log",
                              isSelected: controller.selectedTab.value == 0,
                              onPressed: () => controller.setTab(0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Mood Log",
                              isSelected: controller.selectedTab.value == 1,
                              onPressed: () => controller.setTab(1),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Meal Log",
                              isSelected: controller.selectedTab.value == 2,
                              onPressed: () => controller.setTab(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Meal Log",
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: AppColors.textFieldFillColor,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF521212),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1.11,
                            color: Colors.white12,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Meal Log", style: getTextStyle(fontSize: 14)),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                "Meal Log content coming soon",
                                style: getTextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
