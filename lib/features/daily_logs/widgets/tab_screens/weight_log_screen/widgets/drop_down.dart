import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
class DropDown extends StatelessWidget {
  const DropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Weight Chart",
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: const Color(0xFF992929),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: "this week",
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.white,
              ),
              style: getTextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
              dropdownColor: const Color(0xFF3A0303),
              items: ['this week', 'last week', 'this month']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {},
            ),
          ),
        ),
      ],
    );
  }
}
