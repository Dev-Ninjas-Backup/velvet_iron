import 'package:flutter/material.dart';

class ExcerciseDropdown extends StatefulWidget {
  final String iconPath;
  const ExcerciseDropdown({super.key, required this.iconPath});

  @override
  State<ExcerciseDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<ExcerciseDropdown> {
  String? selectedValue = "Cardio";
  final List<String> options = ["Cardio", "Push up"];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A0303),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          isExpanded: true,
          dropdownColor: const Color(0xFF3A0303),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Image.asset(
                    widget.iconPath,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
