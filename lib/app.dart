import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/routes/app_routes.dart';
import 'core/bindings/controller_binder.dart';
import 'core/localization/app_translations.dart';

class VelvetIron extends StatelessWidget {
  final Locale? initialLocale;

  const VelvetIron({super.key, this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          initialRoute: AppRoute.getthemeOnboardingScreen(),
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          themeMode: ThemeMode.system,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
