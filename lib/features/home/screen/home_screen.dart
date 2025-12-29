import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/home/widgets/mood_selector.dart';
import 'package:velvet_iron/features/home/widgets/todo_list.dart';
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
            height: 411,

            width: double.infinity,

            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/bgimage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.bgDark.withAlpha(80),
                    const Color.fromARGB(255, 80, 10, 10),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.2, 0.6],
                ),
              ),
            ),
          ),

          /// CONTENT
          Obx(
            () => IndexedStack(
              index: controller.tabIndex.value,
              children: [
                _buildHomeContent(),
                const Center(
                  child: Text(
                    "Daily Log",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Center(
                  child: Text(
                    "Medication",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Center(
                  child: Text(
                    "Exercise",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Center(
                  child: Text("Quests", style: TextStyle(color: Colors.white)),
                ),
                const Center(
                  child: Text("Profile", style: TextStyle(color: Colors.white)),
                ),
              ],
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
