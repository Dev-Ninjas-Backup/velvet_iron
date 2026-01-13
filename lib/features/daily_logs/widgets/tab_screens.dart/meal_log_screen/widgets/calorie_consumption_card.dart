import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class IconPath {
  static const String goldencircle = 'assets/icons/goldencircle.png';
  static const String whitecircle = 'assets/icons/whitecircle.png';
}

class CalorieConsumptionCard extends StatefulWidget {
  const CalorieConsumptionCard({super.key});

  @override
  State<CalorieConsumptionCard> createState() => _CalorieConsumptionCardState();
}

class _CalorieConsumptionCardState extends State<CalorieConsumptionCard> {
  List<int> selectedDays = [0, 1, 2, 3];
  String selectedPeriod = "this week";
  bool isLoading = true;

  final List<String> weekDays = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color brightColor = Color(0xFFE09A9A);
    const Color darkBackground = Color(0xFF380404);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF521212),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Calories Consumption",
                style: getTextStyle(fontSize: 16, color: Colors.white),
              ),
              const Spacer(),
              Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: darkBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF5D2B2B), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    isDense: true,
                    dropdownColor: darkBackground,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: brightColor,
                    ),
                    items: ["this day", "this week", "this month"].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: getTextStyle(fontSize: 10, color: brightColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => selectedPeriod = newValue);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(weekDays.length, (index) {
              final bool isSelected = selectedDays.contains(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedDays.remove(index);
                    } else {
                      selectedDays.add(index);
                    }
                  });
                },
                child: Container(
                  width: 43,
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A0303),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFDCAA64)
                          : Colors.transparent,
                      width: 0.6,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        isSelected
                            ? IconPath.goldencircle
                            : IconPath.whitecircle,
                        width: 18,
                        height: 18,
                      ),
                      Text(
                        weekDays[index],
                        style: getTextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Calories",
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Text(
                "796 g",
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF723737),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.6,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFDE7BB),
                          Color(0xFF9E6D38),
                          Color(0xFFE9B86E),
                          Color(0xFFE5B46B),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
