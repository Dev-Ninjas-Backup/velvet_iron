import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({super.key, this.onChanged, this.controller});

  final Function(String)? onChanged;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return SizedBox(
          height: 69,
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 3,
            style: getTextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "How are you feeling today?",
              hintStyle: getTextStyle(
                fontSize: 12,
                color: themeController.activeTheme.todoTimeColor,
              ),
              filled: true,
              fillColor: themeController.activeTheme.textfieldColor,
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white12,
                  width: 1.11,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: themeController.activeTheme.accentGoldColor,
                  width: 1.11,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
