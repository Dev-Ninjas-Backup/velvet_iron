import 'package:flutter/material.dart';

/// 3D Realistic Cylindrical Scroll Roll at Top and Bottom with Turned Finials
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
          // Left Wooden Turned Finial / Knob
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
                    Color(0xFF8B602A),
                    Color(0xFFD4AF37),
                    Color(0xFF573812),
                  ],
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // Right Wooden Turned Finial / Knob
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
                    Color(0xFF8B602A),
                    Color(0xFFD4AF37),
                    Color(0xFF573812),
                  ],
                ),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // Central Curled Parchment Spindle Body
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
                end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
                colors: const [
                  Color(0xFF6F4B1E), // Dark curl back
                  Color(0xFFDFBA76), // Lit edge
                  Color(0xFFFAF0D7), // Specular highlight ridge
                  Color(0xFFDFBA76), // Mid tone
                  Color(0xFF5E3D13), // Deep curl underside shadow
                ],
                stops: const [0.0, 0.22, 0.50, 0.78, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 6,
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
