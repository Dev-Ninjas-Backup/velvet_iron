import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WeightLogController extends GetxController {
  final currentWeight = "0".obs;
  final targetWeight = "0".obs;
  final weightIcon = "".obs;
  final totalChange = "0".obs;
  final entriesLogged = "0".obs;

  late TextEditingController weightController;
  late TextEditingController noteController;

  @override
  void onInit() {
    super.onInit();
    weightController = TextEditingController();
    noteController = TextEditingController();
  }

  void updateWeightData(String weight, String target, String icon) {
    currentWeight.value = weight;
    targetWeight.value = target;
    weightIcon.value = icon;
  }

  void updateWeightLogSummary(String totalChange, String entries) {
    this.totalChange.value = totalChange;
    entriesLogged.value = entries;
  }

  @override
  void onClose() {
    weightController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
