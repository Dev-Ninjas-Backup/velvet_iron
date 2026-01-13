import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';

class LogYourWeightCard extends StatelessWidget {
  const LogYourWeightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF521212),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weight (lbs):",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: TextFormField(
              style: getTextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Enter current weight",
                hintStyle: getTextStyle(
                  fontSize: 12,
                  color: const Color(0xFF723737),
                ),
                filled: true,
                fillColor: const Color(0xFF3A0303),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "lbs",
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color(0xFF992929),
                    width: 1.11,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color(0xFFDCAA64),
                    width: 1.11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Note (optional):",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 69,
            child: TextFormField(
              maxLines: 3,
              style: getTextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Feeling good today...",
                hintStyle: getTextStyle(
                  fontSize: 12,
                  color: const Color(0xFF723737),
                ),
                filled: true,
                fillColor: const Color(0xFF3A0303),
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
                  borderSide: const BorderSide(
                    color: Color(0xFFDCAA64),
                    width: 1.11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(label: "Log Weight (+5 XP)", onPressed: () {}),
        ],
      ),
    );
  }
}
