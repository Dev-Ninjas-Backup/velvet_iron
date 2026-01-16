import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(ImagePath.demoGraph, fit: BoxFit.cover),
      ),
    );
  }
}
