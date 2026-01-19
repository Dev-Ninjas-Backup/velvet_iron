import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class RedGoldenPopupScreen extends StatelessWidget {
  const RedGoldenPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color: #350404E0
      backgroundColor: const Color(0xE0350404),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 55,
          right: 16,
          bottom: 16,
          left: 16,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1st: Red Container
              // Width: 319px, Height: 339px
              Image.asset(
                ImagePath.redContainer,
                width: 319,
                height: 339,
                fit: BoxFit.fill,
              ),

              // 2nd: Red Frame
              // Positioned at the top of the 1st image
              // Width: 291px, Height: 105px
              Positioned(
                top: 0,
                child: Image.asset(ImagePath.redFrame, width: 291, height: 105),
              ),

              // 3rd: Golden Circle Outline & Character
              // Positioned in the middle of the 2nd image (the frame)
              Positioned(
                top: 0,
                child: Container(
                  width: 98.56,
                  height: 104.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      // Using the gold colors provided for the border/outline
                      color: const Color(0xFFE9B86E),
                    ),
                    // Applying the provided color palette to the circle
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFDE7BB),
                        Color(0xFF9E6D38),
                        Color(0xFFE9B86E),
                        Color(0xFFE5B46B),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      ImagePath.charecterOne,
                      width: 98.56,
                      height: 104.85,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
