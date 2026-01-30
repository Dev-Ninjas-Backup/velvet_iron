import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String iconPath;
  final String header;
  final String points;

  const ProgressCard({
    super.key,
    required this.iconPath,
    required this.header,
    required this.points,
  });

  TextStyle getTextStyle({
    double size = 14,
    FontWeight weight = FontWeight.normal,
  }) {
    return TextStyle(color: Colors.white, fontSize: size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF521212).withValues(alpha: .5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 36, height: 36, fit: BoxFit.contain),
          const SizedBox(width: 8), // Gap: 8px
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: getTextStyle(size: 14, weight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  points,
                  style: getTextStyle(size: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
