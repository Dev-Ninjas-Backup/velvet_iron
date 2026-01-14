import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class CustomDropdown extends StatefulWidget {
  final String iconPath;
  const CustomDropdown({super.key, required this.iconPath});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue = "Injection";
  final List<String> options = ["Injection", "Ozempic"];

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
          value: "Injection",
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          isExpanded: true,
          dropdownColor: const Color(0xFF3A0303),
          onChanged: (String? newValue) {},
          items: <String>["Injection", "Ozempic"].map<DropdownMenuItem<String>>(
            (String value) {
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
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
