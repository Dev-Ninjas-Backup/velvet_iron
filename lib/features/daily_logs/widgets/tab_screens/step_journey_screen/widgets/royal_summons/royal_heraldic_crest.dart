import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

/// Official Dravosi Royal Crest supplied by client
class RoyalHeraldicCrest extends StatelessWidget {
  final double size;

  const RoyalHeraldicCrest({super.key, this.size = 115});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        ImagePath.dravosiRoyalCrest,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
