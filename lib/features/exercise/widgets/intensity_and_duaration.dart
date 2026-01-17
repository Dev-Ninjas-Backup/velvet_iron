import 'package:flutter/material.dart';

class IntensityAndDuration extends StatefulWidget {
  const IntensityAndDuration({super.key});

  @override
  State<IntensityAndDuration> createState() => _IntensityAndDurationState();
}

class _IntensityAndDurationState extends State<IntensityAndDuration> {
  String _selectedIntensity = "Moderate";
  final List<String> _intensities = ["Low", "Moderate", "High"];

  TextStyle getTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'Serif',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Intensity:", style: getTextStyle()),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A0303),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12, width: 1.11),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedIntensity,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.expand_more,
                          color: Colors.white,
                          size: 18,
                        ),
                        dropdownColor: const Color(0xFF3A0303),
                        items: _intensities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: getTextStyle()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedIntensity = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Space between the two columns
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Duration:", style: getTextStyle()),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A0303),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12, width: 1.11),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            style: getTextStyle(),
                            decoration: const InputDecoration(
                              hintText: "e.g. 30 min",
                              hintStyle: TextStyle(
                                color: Color(0xFF723737),
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Text(
                          "min",
                          style: getTextStyle().copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
