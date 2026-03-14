import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/about_training_codex/model/about_training_model.dart';

class AboutTrainingController extends GetxController {
  List<AboutTrainingModel> get features => AboutTrainingData.features;
  List<AboutTrainingModel> get partnerFeatures =>
      AboutTrainingData.partnerFeatures;

  final scrollController = ScrollController();

  final RxInt selectedSection = 0.obs;
  final RxSet<int> expandedSections = <int>{0, 1}.obs;
  final RxMap<int, Set<int>> selectedFeatureIndices = <int, Set<int>>{
    0: {},
    1: {},
  }.obs;

  void selectSection(int index) {
    selectedSection.value = index;
  }

  void toggleSection(int sectionIndex) {
    if (expandedSections.contains(sectionIndex)) {
      expandedSections.remove(sectionIndex);
    } else {
      expandedSections.add(sectionIndex);
    }
  }

  void toggleFeature(int sectionIndex, int featureIndex) {
    selectedFeatureIndices[sectionIndex] ??= <int>{};
    if (selectedFeatureIndices[sectionIndex]!.contains(featureIndex)) {
      selectedFeatureIndices[sectionIndex]!.remove(featureIndex);
    } else {
      selectedFeatureIndices[sectionIndex]!.add(featureIndex);
    }
    // Trigger update
    selectedFeatureIndices.refresh();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
