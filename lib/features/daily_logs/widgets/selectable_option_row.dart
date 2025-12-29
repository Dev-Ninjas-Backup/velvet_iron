import 'package:flutter/material.dart';

class SelectableOptionRow extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onTap;

  const SelectableOptionRow({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onTap,
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
                  color: const Color(0xFF3A0303),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFDCAA64)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  options[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
