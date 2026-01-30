import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class TodaysQuestItem extends StatefulWidget {
  final String header;
  final String title;
  final String tagText;
  final List<Color> tagGradient;
  final int xp;

  const TodaysQuestItem({
    super.key,
    required this.header,
    required this.title,
    required this.tagText,
    required this.tagGradient,
    required this.xp,
  });

  @override
  State<TodaysQuestItem> createState() => _TodaysQuestItemState();
}

class _TodaysQuestItemState extends State<TodaysQuestItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF521212).withValues(alpha: .5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() => selected = !selected),
            child: Image.asset(
              selected ? IconPath.goldencircle : IconPath.whitecircle,
              width: 24,
              height: 24,
            ),
          ),

          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.header,
                style: getTextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                widget.title,
                style: getTextStyle(
                  color: const Color(0xFFB43737),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: widget.tagGradient),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.tagText,
                      style: getTextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+${widget.xp}',
                        style: getTextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'XP',
                        style: getTextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(IconPath.star, width: 12, height: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
