import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_history_item.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_your_weight.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/weight_log_screen/widgets/drop_down.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/weight_log_screen/widgets/graph.dart';
import 'package:velvet_iron/features/daily_logs/widgets/weight_status_card.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class WeightLog extends StatelessWidget {
  const WeightLog({
    super.key,
    required this.controller,
    required this.navController,
  });
  final DailyLogController controller;
  final BottomNavController navController;
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              children: [
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // Navigate to Home screen tab
                    navController.changeTabIndex(0);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF521212),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Daily Logs",
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(ImagePath.magicImage, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Weight Log",
                              isSelected: controller.selectedTab.value == 0,
                              onPressed: () => controller.setTab(0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Mood Log",
                              isSelected: controller.selectedTab.value == 1,
                              onPressed: () => controller.setTab(1),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Meal Log",
                              isSelected: controller.selectedTab.value == 2,
                              onPressed: () => controller.setTab(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: WeightStatusCard(
                              iconPath: IconPath.steelyard,
                              weightValue: "72 lbs",
                              label: "Current Weight",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: WeightStatusCard(
                              iconPath: IconPath.updown,

                              weightValue: "1.54 lbs",

                              label: "Total Change",
                            ),
                          ),

                          const SizedBox(width: 10),
                          Expanded(
                            child: WeightStatusCard(
                              iconPath: IconPath.clock,
                              weightValue: "12",
                              label: "Entries Logged",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      DropDown(),
                      SizedBox(height: 8),
                      Graph(),
                      SizedBox(height: 20),
                      Text(
                        "Log Your Weight",
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      LogYourWeightCard(),
                      SizedBox(height: 20),

                      Text(
                        "Log History",
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      LogHistoryItem(
                        title: "16.1 lbs",
                        xpText: "+10 XP",
                        iconPath: IconPath.whiteSteelyard,
                        secondText: "0.5 lbs increased",
                        thirdText: "Feeling good today...",
                        dateTimeText: "15 Dec, Wed - 09:30 AM",
                      ),

                      SizedBox(height: 10),
                      LogHistoryItem(
                        title: "16.1 lbs",
                        xpText: "+10 XP",
                        iconPath: IconPath.whiteSteelyard,
                        secondText: "0.5 lbs increased",
                        thirdText: "",
                        dateTimeText: "15 Dec, Wed - 09:30 AM",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
