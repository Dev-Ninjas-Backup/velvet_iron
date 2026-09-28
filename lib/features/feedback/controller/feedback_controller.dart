import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
