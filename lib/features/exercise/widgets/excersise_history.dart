import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class ExcersiseHistory extends StatelessWidget {
  final String title, sub, time;
  final String iconPath;
  final RxBool isSelected;

  const ExcersiseHistory({
    super.key,
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                isSelected.toggle();
              },
              child: Image.asset(
                isSelected.value ? IconPath.goldencircle : IconPath.whitecircle,
                width: 22,
                height: 22,
              ),
            ),

            const SizedBox(width: 8),

            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sub,
                    style: getTextStyle(
                      color: const Color.fromARGB(255, 149, 4, 4),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Image.asset(IconPath.star, width: 16, height: 16),
                    const SizedBox(width: 4),
                    Text("+10 XP", style: getTextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(time, style: getTextStyle(color: const Color(0xFF914C4C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
