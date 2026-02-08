import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class UpdateInformationWidget extends StatelessWidget {
  const UpdateInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Information:',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: themeController.activeTheme.borderColor.withValues(
                      alpha: 0.5,
                    ),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Full Name:'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.fullNameController,
                      hintText: 'Enter full name',
                      themeController: themeController,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Username:'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.usernameController,
                      hintText: 'Enter username/email',
                      themeController: themeController,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Gender'),
                    const SizedBox(height: 10),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(controller.genders.length, (
                          index,
                        ) {
                          return GestureDetector(
                            onTap: () => controller.selectGender(index),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          controller.selectedGender.value ==
                                              index
                                          ? themeController
                                                .activeTheme
                                                .accentGoldColor
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient:
                                            controller.selectedGender.value ==
                                                index
                                            ? themeController
                                                  .activeTheme
                                                  .progressBarGradient
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  controller.genders[index],
                                  style: getTextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Date of Birth:'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildDropdown(
                            value: controller.selectedMonth,
                            items: controller.months,
                            themeController: themeController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _buildDropdown(
                            value: controller.selectedDay,
                            items: controller.days,
                            themeController: themeController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _buildDropdown(
                            value: controller.selectedYear,
                            items: controller.years,
                            themeController: themeController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    OutlinedButton(
                      onPressed: () =>
                          Get.toNamed(AppRoute.getupdatePasswordScreen()),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: themeController.activeTheme.accentGoldColor,
                        ),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Update Password',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required AppThemeController themeController,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeController.activeTheme.dropdownBackgroundColor.withValues(
          alpha: 100,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: themeController.activeTheme.borderColor.withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: controller,
        style: getTextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: getTextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required RxString value,
    required List<String> items,
    required AppThemeController themeController,
  }) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 45,
        decoration: BoxDecoration(
          color: themeController.activeTheme.dropdownBackgroundColor.withValues(
            alpha: 100,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: themeController.activeTheme.borderColor.withValues(
              alpha: 100,
            ),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value.value,
            isExpanded: true,
            dropdownColor: themeController.activeTheme.dropdownBackgroundColor,
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: themeController.activeTheme.borderColor,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: getTextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) value.value = newValue;
            },
          ),
        ),
      ),
    );
  }
}
