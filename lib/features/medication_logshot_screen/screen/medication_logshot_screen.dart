import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/medication_logshot_controller.dart';
import '../widgets/header_section.dart';
import '../widgets/dose_card_section.dart';
import '../widgets/log_dose_form.dart';
import '../widgets/dose_history_section.dart';

class MedicationLogshotScreen extends StatelessWidget {
  const MedicationLogshotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MedicationLogshotController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E0000),
                  Color(0xFF680B0B),
                ],
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const HeaderSection(),
                  const SizedBox(height: 16),
                  const DoseCardSection(),
                  const SizedBox(height: 24),
                  const LogDoseForm(),
                  const SizedBox(height: 24),
                  const DoseHistorySection(),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
