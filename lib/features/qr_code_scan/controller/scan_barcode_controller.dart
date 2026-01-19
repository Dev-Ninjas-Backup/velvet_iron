import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanBarcodeController extends GetxController {
  CameraController? cameraController;

  final carbs = TextEditingController();
  final protein = TextEditingController();
  final fats = TextEditingController();

  bool loadingCamera = true;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await cameraController!.initialize();
    } catch (_) {}
    loadingCamera = false;
    update();
  }

  void save() {
    Get.back();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    carbs.dispose();
    protein.dispose();
    fats.dispose();
    super.onClose();
  }
}
