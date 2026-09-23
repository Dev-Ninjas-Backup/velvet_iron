import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/daily_log_tab_bar.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/water_log_screen/controller/water_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/water_log_screen/widgets/potion_flask_widget.dart';

class WaterLogScreen extends StatelessWidget {
  final DailyLogController dailyLogController;
  final BottomNavController navController;

  const WaterLogScreen({
    super.key,
    required this.dailyLogController,
    required this.navController,
  });

  void _showGoalModal(BuildContext context, WaterLogController controller) {
    final theme = Get.find<AppThemeController>().activeTheme;
    final textController = TextEditingController(
      text: controller.goal.value.toStringAsFixed(
        controller.goal.value.truncateToDouble() == controller.goal.value ? 0 : 1,
      ),
    );
    final selectedUnit = controller.unit.value.obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.dropdownBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: theme.borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hydration Target Goal',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Set your daily potion goal and choose your preferred unit (US Fluid Ounces or Milliliters).',
                style: getTextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Daily Goal',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: theme.cardBackgroundColor.withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.accentGoldColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => Row(
                      children: [
                        _buildUnitButton('OZ', selectedUnit, theme),
                        const SizedBox(width: 6),
                        _buildUnitButton('ML', selectedUnit, theme),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Save Target Goal',
                onPressed: () {
                  final val = double.tryParse(textController.text.trim());
                  if (val != null && val > 0) {
                    controller.updateGoal(newGoal: val, newUnit: selectedUnit.value);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitButton(String label, RxString selected, dynamic theme) {
    final isSelected = selected.value == label;
    return GestureDetector(
      onTap: () => selected.value = label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? theme.accentGoldColor : theme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.accentGoldColor : theme.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showCustomLogModal(BuildContext context, WaterLogController controller) {
    final theme = Get.find<AppThemeController>().activeTheme;
    final textController = TextEditingController();
    final selectedUnit = controller.unit.value.obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.dropdownBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: theme.borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Log Custom Amount',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Enter volume',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: theme.cardBackgroundColor.withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.accentGoldColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => Row(
                      children: [
                        _buildUnitButton('OZ', selectedUnit, theme),
                        const SizedBox(width: 6),
                        _buildUnitButton('ML', selectedUnit, theme),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Log Drink (+5 XP)',
                onPressed: () {
                  final val = double.tryParse(textController.text.trim());
                  if (val != null && val > 0) {
                    controller.logCustomWater(val, customUnit: selectedUnit.value);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WaterLogController());

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final theme = themeController.activeTheme;

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
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
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Get.back();
                        } else {
                          navController.changeTabIndex(0);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.todoSubtitleColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 5-Tab Bar
                DailyLogTabBar(controller: dailyLogController),
                const SizedBox(height: 16),

                // Potion Flask Hero Visual
                Obx(
                  () => PotionFlaskWidget(
                    fillLevel: controller.fillLevel.value,
                    fillPercentage: controller.fillPercentage.value,
                    isGoalReached: controller.isGoalReached.value,
                    display: controller.display.value,
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Info Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00A2FF).withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.local_drink_rounded,
                          color: Color(0xFF6FB1FC),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mana Infusion',
                              style: getTextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Obx(
                              () => Text(
                                controller.display.value,
                                style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: controller.isGoalReached.value
                                ? const Color(0xFFE5A93C).withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.isGoalReached.value
                                  ? const Color(0xFFE5A93C)
                                  : Colors.white24,
                            ),
                          ),
                          child: Text(
                            '${controller.fillPercentage.value.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: controller.isGoalReached.value
                                  ? const Color(0xFFE5A93C)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                        onPressed: () => _showGoalModal(context, controller),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Add Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Add Potion',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showCustomLogModal(context, controller),
                      icon: const Icon(Icons.add, size: 16, color: Color(0xFF6FB1FC)),
                      label: Text(
                        'Custom',
                        style: getTextStyle(
                          fontSize: 13,
                          color: const Color(0xFF6FB1FC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Quick Add Buttons
                Obx(
                  () => Row(
                    children: controller.quickAdds.map((amt) {
                      final u = controller.unit.value.toLowerCase();
                      final amtStr = amt.toStringAsFixed(amt.truncateToDouble() == amt ? 0 : 1);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () => controller.quickAddWater(amt),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF0052D4),
                                    Color(0xFF4364F7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF6FB1FC).withValues(alpha: 0.5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0052D4).withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '+$amtStr $u',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Today's Drink Timeline
                Text(
                  "Today's Hydration Logs",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.todayLogs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: theme.cardBackgroundColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.borderColor.withValues(alpha: 0.5)),
                      ),
                      child: Center(
                        child: Text(
                          'No potion logs recorded yet today.\nTake a drink to begin restoring mana!',
                          textAlign: TextAlign.center,
                          style: getTextStyle(fontSize: 12, color: Colors.white54),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: controller.todayLogs.map((log) {
                      final timeStr = DateFormat('hh:mm a').format(log.loggedAt.toLocal());
                      final amtStr = log.amount.toStringAsFixed(
                        log.amount.truncateToDouble() == log.amount ? 0 : 1,
                      );
                      final u = log.unit.toLowerCase();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0052D4),
                              ),
                              child: const Icon(
                                Icons.water_drop,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$amtStr $u',
                                    style: getTextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    timeStr,
                                    style: getTextStyle(fontSize: 11, color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5A93C).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${log.earnedXp} XP',
                                style: const TextStyle(
                                  color: Color(0xFFE5A93C),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => controller.deleteLog(log.id),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
