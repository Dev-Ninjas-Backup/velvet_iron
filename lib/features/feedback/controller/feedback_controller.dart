import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void joinDiscord() {
    // print("Joining Discord...");
  }
}
