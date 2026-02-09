import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class WelcomeController extends GetxController {
  Future<void> onContinuePressed() async {
    try {
      EasyLoading.show(status: 'Preparing your quest...');

      await Future.delayed(const Duration(seconds: 1));

      EasyLoading.dismiss();
      Get.toNamed(AppRoute.getthemeOnboardingScreen());
    } catch (e) {
      EasyLoading.showError('Failed to start journey');
    }
  }
}
