import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  
  final userName = 'Unbound'.obs;
  final userLevel = 1.obs;
  final currentXP = 220.obs;
  final maxXP = 500.obs;
  
 
  final upcomingLog = 'Breakfast'.obs;
  final upcomingLogXP = 10.obs;
  final upcomingLogTime = 'Wed - 8:30 AM'.obs; 
  
 
  
  final appVersion = 'v1.0'.obs;
  
 
  String get progressText => 'Progress to level ${userLevel.value + 1}';
  String get xpText => '${currentXP.value}/${maxXP.value} XP';
  double get progressPercentage => currentXP.value / maxXP.value;
  
  
  void navigateToProfile() {
    Get.toNamed('/profile');
  }

  void navigateToDailyMacroGoal(){
    Get.toNamed('/dailyMacroGoal');
  
  }
  
  void navigateToThemes() {
    Get.toNamed('/themes');
  }
  
  void navigateToFeedback() {
    Get.toNamed('/feedback');
  }
  
  void navigateToAbout() {
    Get.toNamed('/about');
  }
  
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
             
              Get.offAllNamed('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  void skipUpcomingLog() {
   
    Get.snackbar('Skipped', 'Log skipped successfully');
  }
}