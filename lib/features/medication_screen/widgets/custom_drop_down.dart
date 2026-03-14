import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';

class CustomDropdown extends StatelessWidget {
  final String iconPath;
  const CustomDropdown({super.key, required this.iconPath});

  static const List<String> options = [
    "--",
    "INJECTION",
    "CAPSULE",
    "LIQUID",
    "TABLET",
  ];

  @override
  Widget build(BuildContext context) {
    final MedicationController controller = Get.find();
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(
          () => Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              color: themeController.activeTheme.textfieldColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedType.value == ''
                    ? null
                    : controller.selectedType.value,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                isExpanded: true,
                dropdownColor:
                    themeController.activeTheme.dropdownBackgroundColor,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.updateType(newValue);
                  }
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  if (value == "--") {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Image.asset(
                          IconPath.todo2,
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
