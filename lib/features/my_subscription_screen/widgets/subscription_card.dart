import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import '../controller/my_subscription_controller.dart';

class SubscriptionCard extends StatelessWidget {
  final MySubscriptionController controller;
  const SubscriptionCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF7A).withValues(alpha: 0.6),
          width: 1,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF310101),
            Color(0xFF550606),
            Color(0xFF310101),
            Color(0xFF310101),

            Color.fromARGB(255, 101, 69, 21),
            Color.fromARGB(255, 95, 69, 30),
            Color(0xFF550606),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _premiumBadge(),
                const SizedBox(height: 8),
                _info("Last Renewed", controller.renewDate),
                _info("Expire Date", controller.expireDate),
                const SizedBox(height: 10),
                _cancelButton(controller),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF9E6D38),
                    Color(0xFFE9B86E),
                    Color(0xFFE5B46B),
                  ],
                ).createShader(bounds),
                child: Text.rich(
                  TextSpan(
                    text: controller.price,
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: " / per month",
                        style: getTextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black26,
                child: Image.asset(ImagePath.premiumprofile),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _premiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(IconPath.doticon, height: 20, width: 25),
          const SizedBox(width: 4),
          Text(
            "Premium",
            style: getTextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Text(
      "$title: $value",
      style: getTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  Widget _cancelButton(MySubscriptionController controller) {
    return SizedBox(
      width: double.infinity,
      height: 40, // 👈 button height
      child: OutlinedButton(
        onPressed: controller.cancelSubscription,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero, // 👈 extra height remove
        ),
        child: Text(
          "Cancel Subscription",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
