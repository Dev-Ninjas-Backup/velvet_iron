import 'package:flutter/material.dart';

class SelectableOptionRow extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onTap;
  final List<IconData>? icons;
  final List<String>? assetIcons;

  const SelectableOptionRow({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onTap,
    this.icons,
    this.assetIcons,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(options.length, (index) {
          final selected = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFFDE7BB),
                            Color(0xFF9E6D38),
                            Color(0xFFE9B86E),
                            Color(0xFF9D6933),
                            Color(0xFFFEE9BF),
                            Color(0xFF683E23),
                          ],
                        )
                      : null,
                  color: selected ? null : const Color(0xFF3A0303),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFDCAA64)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (assetIcons != null && index < assetIcons!.length)
                      Image.asset(assetIcons![index], width: 12, height: 13)
                    else if (icons != null && index < icons!.length)
                      Icon(icons![index], color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      options[index],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
