import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/home/widgets/mood_selector.dart';
import 'package:velvet_iron/features/home/widgets/todo_list.dart';
import 'package:velvet_iron/features/medication_logshot_screen/screen/medication_logshot_screen.dart';
import 'package:velvet_iron/features/daily_logs/screen/daily_log_screen.dart';
import '../widgets/header_section.dart';
import '../widgets/welcome_card.dart';
import '../widgets/weight_progress.dart';
import '../../bottom_nav/screen/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/magicImage.png',
              width: 378,
              height: 411,
            ),
          ),

          Obx(
            () => Padding(
              padding: const EdgeInsets.only(bottom: 115),
              child: IndexedStack(
                index: controller.tabIndex.value,
                children: [
                  _buildHomeContent(),
                  const DailyLogScreen(),
                  MedicationLogshotScreen(),
                  const Center(
                    child: Text(
                      "Exercise",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Quests",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(bottom: 20, left: 0, right: 0, child: BottomNav()),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderSection(),
            SizedBox(height: 20),
            WelcomeCard(),
            SizedBox(height: 26),
            WeightProgress(),
            SizedBox(height: 26),
            MoodSelector(),
            SizedBox(height: 26),
            TodoSection(),
          ],
        ),
      ),
    );
  }
}
