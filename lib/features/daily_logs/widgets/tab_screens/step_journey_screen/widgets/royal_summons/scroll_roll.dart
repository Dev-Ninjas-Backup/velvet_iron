import 'package:flutter/material.dart';

/// Antique Carved Dark Timber & Aged Bronze Scroll Rods
class ScrollRoll extends StatelessWidget {
  final bool isTop;

  const ScrollRoll({super.key, required this.isTop});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Left Antique Carved Wooden Turned Finial / Knob
          Positioned(
            left: 0,
            child: Container(
              width: 14,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2A170A), // Deep aged dark walnut
                    Color(0xFF6B421E), // Polished timber highlight
                    Color(0xFF8A6234), // Subtle antique bronze sheen
                    Color(0xFF251407), // Shadowed underside
                  ],
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
                border: Border.all(
                  color: const Color(0xFF8A6234).withValues(alpha: 0.4),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.65),
                    blurRadius: 5,
                    offset: const Offset(-1, 2),
                  ),
                ],
              ),
            ),
          ),

          // Right Antique Carved Wooden Turned Finial / Knob
          Positioned(
            right: 0,
            child: Container(
              width: 14,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2A170A), // Deep aged dark walnut
                    Color(0xFF6B421E), // Polished timber highlight
                    Color(0xFF8A6234), // Subtle antique bronze sheen
                    Color(0xFF251407), // Shadowed underside
                  ],
                ),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
                border: Border.all(
                  color: const Color(0xFF8A6234).withValues(alpha: 0.4),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.65),
                    blurRadius: 5,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),

          // Central Antique Rolled Parchment Cylinder Body
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
                end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
                colors: const [
                  Color(0xFF2B1607), // Deep shadow curl
                  Color(0xFF5E3917), // Rich aged timber
                  Color(0xFF9E7743), // Weathered antique parchment ridge
                  Color(0xFF6B441F), // Shadowed wood
                  Color(0xFF1E0E04), // Underside depth shadow
                ],
                stops: const [0.0, 0.20, 0.48, 0.78, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.75),
                  blurRadius: 8,
                  offset: Offset(0, isTop ? 4 : -4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
