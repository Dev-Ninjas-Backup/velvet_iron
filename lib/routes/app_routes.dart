import 'package:get/get.dart';
import 'package:velvet_iron/features/splash/screen/splash_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";

  static String getSplashScreen() => splashScreen;
  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
  ];
}
