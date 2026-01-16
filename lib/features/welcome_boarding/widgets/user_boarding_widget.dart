import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to Velvet & Iron',
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Training Codex',
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}

class WelcomeDescription extends StatelessWidget {
  const WelcomeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Your journey to wellness is a heroic quest. Track your progress, complete daily challenges, and unlock achievements as you transform your health and well-being.',
      textAlign: TextAlign.center,
      style: getTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
