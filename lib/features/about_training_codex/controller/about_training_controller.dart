// controllers/about_training_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/about_training_codex/model/about_training_model.dart';

class AboutTrainingController extends GetxController {
  List<AboutTrainingModel> get features => AboutTrainingData.features;

  List<AboutTrainingModel> get partnerFeatures => AboutTrainingData.partnerFeatures;

  final scrollController = ScrollController();

  final RxInt selectedSection = 0.obs;

  void selectSection(int index) {
    selectedSection.value = index;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}