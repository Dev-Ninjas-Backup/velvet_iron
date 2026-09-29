import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:velvet_iron/core/services/revenuecat_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class FeedbackController extends GetxController {
  var rating = 5.obs;
  final feedbackTextController = TextEditingController();

  void updateRating(int index) {
    rating.value = index;
  }

  void sendFeedback() {
    Get.snackbar(
      "Success",
      "Thank you for your feedback!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF512212),
      colorText: Colors.white,
    );
  }

  Future<void> joinDiscord() async {
    try {
      final isSubscribed = await RevenueCatService.isPremiumActive();
      if (!isSubscribed) {
        Get.defaultDialog(
          title: 'Guild Hall Access',
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          backgroundColor: const Color(0xFF1B2838),
          middleText:
              'The Guild Hall Discord community is an exclusive sanctuary for active subscribers. Subscribe to join challenges and connect with fellow adventurers.',
          middleTextStyle: const TextStyle(color: Colors.white70, fontSize: 13),
          textConfirm: 'View Plans',
          confirmTextColor: Colors.black,
          buttonColor: const Color(0xFFD6B36A),
          onConfirm: () {
            Get.back();
            Get.toNamed(AppRoute.mySubscriptionScreen);
          },
          textCancel: 'Cancel',
          cancelTextColor: Colors.white60,
        );
        return;
      }

      final url = Uri.parse('https://discord.gg/velvetiron');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint('Error launching Discord: $e');
    }
  }
}
