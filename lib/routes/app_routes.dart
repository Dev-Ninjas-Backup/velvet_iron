import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/login/screen/login_screen.dart';
import 'package:velvet_iron/features/auth/set_password/screen/set_password_screen.dart';
import 'package:velvet_iron/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:velvet_iron/features/splash/screen/splash_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String setPasswordScreen = "/setPasswordScreen";

  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getSetPasswordScreen() => setPasswordScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: setPasswordScreen, page: () => SetPasswordScreen()),
  ];
}
