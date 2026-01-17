import 'package:flutter/material.dart';

class CustomBackgroundWithImage extends StatelessWidget {
  final Widget child;
  final String? imageAsset;

  const CustomBackgroundWithImage({
    super.key,
    required this.child,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
        ),
      ),

      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (imageAsset != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: .99,
                child: Image.asset(
                  imageAsset!,
                  height: 378,
                  width: 411,
                  fit: BoxFit.contain,
                  color: Color(0xFF680B0B),
                ),
              ),
            ),

          child,
        ],
      ),
    );
  }
}
