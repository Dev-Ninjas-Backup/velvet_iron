import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Ornate Fantasy Plaque Button (Dark Navy Velvet core with Gold Filigree Bevel Border)
class FantasyPlaqueButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const FantasyPlaqueButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<FantasyPlaqueButton> createState() => _FantasyPlaqueButtonState();
}

class _FantasyPlaqueButtonState extends State<FantasyPlaqueButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Outer burnished gold frame
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFDF7A),
                Color(0xFFC79E45),
                Color(0xFF7A5517),
                Color(0xFFC79E45),
                Color(0xFFFFDF7A),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: const Color(0xFFC79E45).withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                // Inner dark velvet navy inlay
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E283F),
                    Color(0xFF0F1524),
                    Color(0xFF0A0E18),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle inner gold border
                  Container(
                    margin: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                  ),

                  // Button Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFFFD54F),
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.label,
                        style: GoogleFonts.cinzel(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFE082),
                          letterSpacing: 1.6,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              blurRadius: 4,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFFFD54F),
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
