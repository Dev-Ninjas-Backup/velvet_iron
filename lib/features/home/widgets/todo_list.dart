import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';

class TodoSection extends StatelessWidget {
  const TodoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final themeController = Get.find<AppThemeController>();

    return GetBuilder<AppThemeController>(
      builder: (_) {
        final activeTheme =
            themeController.currentTheme.value ?? AppThemeModel.adventurerTheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "To-do Lists",
                  style: getTextStyle(color: Colors.white, fontSize: 18),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: activeTheme.borderColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(
                      () => DropdownButton<String>(
                        value: homeController.selectedTodoFilter.value,
                        dropdownColor: activeTheme.cardBackgroundColor,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(
                            "assets/icons/dropdown.png",
                            width: 22,
                            height: 22,
                            color: Colors.white,
                          ),
                        ),
                        style: getTextStyle(color: Colors.white),
                        items: ['Today', 'Weekly', 'Monthly'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            homeController.selectedTodoFilter.value = newValue;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: homeController.todos
                    .map((todo) => _TodoTile(todo: todo, theme: activeTheme))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TodoTile extends StatelessWidget {
  final HomeScreenModel todo;
  final dynamic theme;

  const _TodoTile({required this.todo, required this.theme});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();

    return Obx(() {
      final themeId = themeController.activeTheme.id;
      final dotIcon = themeId == 'adventurer'
          ? IconPath.doticonAdventure
          : themeId == 'mage'
          ? IconPath.doticonMage
          : themeId == 'gamer'
          ? IconPath.doticonGamer
          : IconPath.doticonReader;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.cardBackgroundColor.withValues(alpha: .7),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Image.asset(
              todo.isChecked.value ? dotIcon : IconPath.whitecircle,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: getTextStyle(color: Colors.white, fontSize: 12),
                    // overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    todo.sub,
                    style: getTextStyle(color: theme.textColor, fontSize: 11),
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "+${todo.xp} XP",
                      style: getTextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      theme.id == 'adventurer'
                          ? IconPath.starAdventure
                          : theme.id == 'mage'
                          ? IconPath.starMage
                          : theme.id == 'gamer'
                          ? IconPath.starGamer
                          : IconPath.starReader,
                      width: 12,
                      height: 12,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(todo.time, style: getTextStyle(color: theme.textColor)),
              ],
            ),
          ],
        ),
      );
    });
  }
}
