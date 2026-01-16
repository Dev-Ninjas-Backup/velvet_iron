import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/login/screen/login_screen.dart';
import 'package:velvet_iron/features/auth/set_password/screen/set_password_screen.dart';
import 'package:velvet_iron/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:velvet_iron/features/daily_logs/screen/daily_log_screen.dart';
import 'package:velvet_iron/features/exercise/screen/exercise_screen.dart';
import 'package:velvet_iron/features/home/screen/home_screen.dart';
import 'package:velvet_iron/features/medication_screen/screen/medication_screen.dart';
import 'package:velvet_iron/features/onboarding2/screen/onboarding_screen.dart';
import 'package:velvet_iron/features/onboarding3/screen/onboarding_screen.dart';
import 'package:velvet_iron/features/onboarding4/screen/onboarding4_screen.dart';
import 'package:velvet_iron/features/onboarding5/screen/onboarding5_screen.dart';
import 'package:velvet_iron/features/splash/screen/splash_screen.dart';
import 'package:velvet_iron/features/user_onboarding/onboarding1/screen/onboading1_screen.dart';
import 'package:velvet_iron/features/welcome_boarding/screen/user_boarding_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String setPasswordScreen = "/setPasswordScreen";
  static String homeScreen = "/homeScreen";
  static String bottomNavScreen = "/bottomNavScreen";
  static String medicationLogshotScreen = "/medicationLogshotScreen";
  static String dailyLogScreen = "/dailyLogScreen";
  static String medicationScreen = "/medicationScreen";
  static String exerciseScreen = '/exerciseScreen';
  static String welcomeScreen = '/welcomeScreen';
  static String onboadingScreen1 = '/onboadingScreen1';
  static String onboadingScreen2 = '/onboadingScreen2';
  static String onboardingScreen3 = '/onboardingScreen3';
  static String onboardingScreen4 = '/onboardingScreen4';
  static String onboardingScreen5 = '/onboardingScreen5';

  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getSetPasswordScreen() => setPasswordScreen;
  static String getHomeScreen() => homeScreen;
  static String getBottomNavScreen() => bottomNavScreen;
  static String getMedicationLogshotScreen() => medicationLogshotScreen;
  static String getdailyLogScreen() => dailyLogScreen;
  static String getmedicationScreen() => medicationScreen;
  static String getexerciseScreen() => exerciseScreen;
  static String getwelcomeScreen() => welcomeScreen;
  static String getonboadingScreen1() => onboadingScreen1;
  static String getonboadingScreen2() => onboadingScreen2;
  static String getonboardingScreen3() => onboardingScreen3;
  static String getonboardingScreen4() => onboardingScreen4;
  static String getonboardingScreen5() => onboardingScreen5;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: setPasswordScreen, page: () => SetPasswordScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: bottomNavScreen, page: () => HomeScreen()),
    GetPage(name: dailyLogScreen, page: () => DailyLogScreen()),
    GetPage(name: medicationScreen, page: () => MedicationScreen()),
    GetPage(name: exerciseScreen, page: () => ExerciseScreen()),
    GetPage(name: welcomeScreen, page: () => WelcomeScreen()),
    GetPage(name: onboadingScreen1, page: () => OnboadingScreen1()),
    GetPage(name: onboadingScreen2, page: () => OnboardingScreen2()),
    GetPage(name: onboardingScreen3, page: () => OnboardingScreen3()),
    GetPage(name: onboardingScreen4, page: () => OnboardingScreen4()),
    GetPage(name: onboardingScreen5, page: () => OnboardingScreen5()),
  ];
}
