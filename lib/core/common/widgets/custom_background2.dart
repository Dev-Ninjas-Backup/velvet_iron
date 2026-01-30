import 'package:flutter/material.dart';

class CustomBackground2 extends StatelessWidget {
  final Widget child;
  final String? imageAsset;

  const CustomBackground2({super.key, required this.child, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
        ),
      ),
      child: Stack(
        children: [
          if (imageAsset != null)
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  imageAsset!,
                  fit: BoxFit.cover,
                  color: const Color(0xFF680B0B).withValues(alpha: 0.5),
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
            ),

          child,
        ],
      ),
    );
  }
}
