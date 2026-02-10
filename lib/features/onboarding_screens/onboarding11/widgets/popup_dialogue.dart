import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class PopUpDialogue extends StatelessWidget {
  const PopUpDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final Size size = MediaQuery.of(context).size;

        const double baseWidth = 411.42857142857144;
        const double baseHeight = 923.4285714285714;

        double w(double value) => value * size.width / baseWidth;
        double h(double value) => value * size.height / baseHeight;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: h(75),
                left: 0,
                right: 0,
                child: Image.asset('assets/images/top.png'),
              ),
              Positioned(
                top: h(450),
                left: w(42),
                right: w(42),
                child: Image.asset('assets/images/bottom.png'),
              ),
              Positioned(
                top: h(220),
                left: w(5),
                right: w(5),
                child: Container(
                  height: h(380),
                  width: w(320),
                  padding: EdgeInsets.only(
                    top: h(102),
                    right: w(24),
                    bottom: h(25),
                    left: w(24),
                  ),
                  decoration: BoxDecoration(
                    gradient: themeController.activeTheme.backgroundGradient,
                    borderRadius: BorderRadius.circular(w(40)),
                    border: Border.all(
                      color: themeController.activeTheme.accentGoldColor,
                      width: w(4),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: h(220),
                left: 0,
                right: 0,
                child: Image.asset('assets/images/jwellery.png'),
              ),
              Positioned(
                top: h(135),
                left: 0,
                right: 0,
                child: Image.asset('assets/images/topframe.png'),
              ),
              ////
              Positioned(
                top: h(220),
                left: w(5),
                right: w(5),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: h(45)),
                      Image.asset('assets/images/middleframe.png'),
                      SizedBox(height: h(12)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Congratulations!",
                          style: getTextStyle(
                            fontSize: w(26),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: h(12)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(16)),
                        child: Text(
                          "Your subscription is activated and will expire at Sept 15,2025. You can renew or cancel anytime from your profile settings",
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            fontSize: w(12),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: h(40)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(30)),
                        child: CustomButton(
                          label: 'Finish & Claim ( 25XP)',
                          onPressed: () =>
                              Get.toNamed(AppRoute.getHomeScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ////
            ],
          ),
        );
      },
    );
  }
}