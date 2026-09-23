import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class PotionFlaskWidget extends StatefulWidget {
  final double fillLevel; // 0.0 to 1.0
  final double fillPercentage;
  final bool isGoalReached;
  final String display;

  const PotionFlaskWidget({
    super.key,
    required this.fillLevel,
    required this.fillPercentage,
    required this.isGoalReached,
    required this.display,
  });

  @override
  State<PotionFlaskWidget> createState() => _PotionFlaskWidgetState();
}

class _PotionFlaskWidgetState extends State<PotionFlaskWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double flaskHeight = 220.0;
    const double flaskWidth = 140.0;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: widget.fillLevel.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animatedFill, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Radiance / Enchantment Glow behind flask
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: flaskWidth + 40,
                height: flaskHeight + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.isGoalReached
                          ? const Color(0xFFE5A93C).withValues(alpha: 0.35)
                          : const Color(0xFF00A2FF).withValues(alpha: 0.22),
                      blurRadius: widget.isGoalReached ? 45 : 30,
                      spreadRadius: widget.isGoalReached ? 12 : 5,
                    ),
                  ],
                ),
              ),

              // Flask Art & Liquid Stack
              SizedBox(
                height: flaskHeight,
                width: flaskWidth,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Liquid Fill layer (masked to the belly of the potion flask)
                    Positioned(
                      bottom: 12,
                      child: Container(
                        width: flaskWidth * 0.76,
                        height: (flaskHeight * 0.62) * animatedFill,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF0052D4),
                              Color(0xFF4364F7),
                              Color(0xFF6FB1FC),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _bubbleController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: _ManaBubblePainter(
                                progress: _bubbleController.value,
                                fillRatio: animatedFill,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Foreground Ornate Flask Artwork
                    Image.asset(
                      ImagePath.potionFlaskBlue,
                      height: flaskHeight,
                      width: flaskWidth,
                      fit: BoxFit.contain,
                    ),

                    // Victory Star Badge when Goal Reached
                    if (widget.isGoalReached)
                      Positioned(
                        top: 10,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE5A93C),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFFD700),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ManaBubblePainter extends CustomPainter {
  final double progress;
  final double fillRatio;

  _ManaBubblePainter({required this.progress, required this.fillRatio});

  @override
  void paint(Canvas canvas, Size size) {
    if (fillRatio <= 0.05) return;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    final randoms = [
      {'x': 0.25, 'speed': 1.0, 'radius': 2.5},
      {'x': 0.50, 'speed': 1.3, 'radius': 3.5},
      {'x': 0.72, 'speed': 0.9, 'radius': 2.0},
      {'x': 0.38, 'speed': 1.5, 'radius': 3.0},
      {'x': 0.82, 'speed': 1.1, 'radius': 2.2},
    ];

    for (final b in randoms) {
      final x = size.width * (b['x'] as double);
      final rawY = (progress * (b['speed'] as double)) % 1.0;
      final y = size.height * (1.0 - rawY);
      final r = (b['radius'] as double);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ManaBubblePainter oldDelegate) => true;
}
