import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AppThemeController(), permanent: true);
  }
}
