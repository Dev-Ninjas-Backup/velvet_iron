import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_history_item.dart';
import 'package:velvet_iron/features/daily_logs/widgets/mood_option_widget.dart';
import 'package:velvet_iron/features/daily_logs/widgets/selectable_option_row.dart';

class MoodLog extends StatelessWidget {
  const MoodLog({super.key, required this.controller});

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
                        "How are you feeling?",
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Mood:",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    controller.moods.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: MoodOptionWidget(
                                        icon: controller.moods[index].icon,
                                        title: controller.moods[index].title,
                                        isSelected:
                                            controller.selectedMood.value ==
                                            index,
                                        onTap: () =>
                                            controller.selectMood(index),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Energy Level:",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => SelectableOptionRow(
                                options: controller.energyLevels,
                                selectedIndex: controller.selectedEnergy.value,
                                onTap: controller.selectEnergy,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Hunger Level:",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => SelectableOptionRow(
                                options: controller.hungerLevels,
                                selectedIndex: controller.selectedHunger.value,
                                onTap: controller.selectHunger,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Note (optional):",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              maxLines: 3,
                              cursorColor: const Color(0xFFDCAA64),
                              style: getTextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: "How are you feeling today?",
                                hintStyle: getTextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF723737),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF3A0303),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDCAA64),
                                    width: 1.11,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDCAA64),
                                    width: 1.11,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDCAA64),
                                    width: 1.11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomButton(
                              label: "Log Entry (+10 XP)",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Log History",
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const LogHistoryItem(),
                      const SizedBox(height: 6),
                      const LogHistoryItem(),
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
