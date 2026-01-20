import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class SelectCompanion extends StatelessWidget {
  const SelectCompanion({
    super.key,
    required this.leadingIcon,
    required this.avatar,
    required this.name,
    this.badgeText,
  });

  final Widget leadingIcon;
  final Widget avatar;
  final String name;
  final String? badgeText; // optional
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 18, height: 19, child: leadingIcon),
          const SizedBox(width: 12),
          SizedBox(width: 40, height: 40, child: avatar),
          const SizedBox(width: 12),
          Text(
            name,
            style: getTextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),

          const Spacer(),

          // Optional badge
          if (badgeText != null)
            Container(
              height: 24,
              width: 98,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1, color: Colors.transparent),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF9E6D38),
                    Color(0xFFE9B86E),
                    Color(0xFF9D6933),
                    Color(0xFF683E23),
                  ],
                ),
              ),
              child: Text(
                badgeText!,
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
