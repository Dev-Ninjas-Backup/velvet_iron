import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class DateAndTimePicker extends StatefulWidget {
  const DateAndTimePicker({super.key});

  @override
  State<DateAndTimePicker> createState() => _DateAndTimePickerState();
}

class _DateAndTimePickerState extends State<DateAndTimePicker> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date",
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              _buildPickerField(
                controller: _dateController,
                hint: "Choose",
                iconPath: IconPath.calendar,
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Time",
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              _buildPickerField(
                controller: _timeController,
                hint: "Choose",
                iconPath: IconPath.clock,
                onTap: () => _selectTime(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickerField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 40,

      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        style: getTextStyle(fontSize: 12, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF723737),
          ),
          filled: true,
          fillColor: const Color(0xFF3A0303),
          contentPadding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: 8,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              iconPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Color(0xFFDCAA64), width: 1.11),
          ),
        ),
      ),
    );
  }
}
