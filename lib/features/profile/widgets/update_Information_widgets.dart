import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';

class UpdateInformationWidget extends StatelessWidget {
  const UpdateInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

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
                color: const Color(0xFF6B1717).withValues(alpha: 0.5),
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
                ),
                const SizedBox(height: 16),

                _buildLabel('Username:'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.usernameController,
                  hintText: 'Enter username/email',
                ),
                const SizedBox(height: 16),

                //  Gender Section
                _buildLabel('Gender'),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(controller.genders.length, (index) {
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
                                      controller.selectedGender.value == index
                                      ? const Color(0xFFDCAA64)
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
                                        controller.selectedGender.value == index
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFFFDE7BB),
                                              Color(0xFF9E6D38),
                                              Color(0xFFE9B86E),
                                              Color(0xFF9D6933),
                                              Color(0xFFFEE9BF),
                                              Color(0xFF683E23),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
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

                // Date of Birth Section
                _buildLabel('Date of Birth:'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildDropdown(
                        value: controller.selectedMonth,
                        items: controller.months,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _buildDropdown(
                        value: controller.selectedDay,
                        items: controller.days,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _buildDropdown(
                        value: controller.selectedYear,
                        items: controller.years,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Update Password Button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDCAA64)),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A0303).withValues(alpha: 100),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF6B1717).withValues(alpha: 0.5),
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
  }) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF3A0303).withValues(alpha: 100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF6B1717).withValues(alpha: 100),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value.value,
            isExpanded: true,
            dropdownColor: const Color(0xFF3A0303),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Color(0xFF6B1717),
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
