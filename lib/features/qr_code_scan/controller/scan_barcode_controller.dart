import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBarcodeController extends GetxController {
  // Single shared MobileScannerController — used directly by CameraBox
  late MobileScannerController mobileScannerController;

  final carbs = TextEditingController();
  final protein = TextEditingController();
  final fats = TextEditingController();

  String lastScannedValue = '';
  bool isProcessing = false;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[ScanBarcodeController] onInit called');
    _initMobileScanner();
  }

  void _initMobileScanner() {
    mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    debugPrint('[ScanBarcodeController] MobileScannerController initialized');
  }

  /// Called from CameraBox when a barcode is detected.
  void onBarcodeDetected(String rawValue) {
    debugPrint('[onBarcodeDetected] Raw value: "$rawValue"');

    if (rawValue == lastScannedValue) {
      debugPrint('[onBarcodeDetected] Duplicate scan — ignored');
      return;
    }
    if (isProcessing) {
      debugPrint('[onBarcodeDetected] Already processing — skipped');
      return;
    }

    isProcessing = true;
    lastScannedValue = rawValue;

    mobileScannerController.stop();
    debugPrint('[onBarcodeDetected] Scanner paused');

    // FIX: Look up nutrition from Open Food Facts API
    _fetchNutritionFromApi(rawValue);
  }

  Future<void> _fetchNutritionFromApi(String barcode) async {
    debugPrint('[_fetchNutritionFromApi] Looking up barcode: $barcode');

    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
      );

      final response = await http.get(uri);
      debugPrint(
        '[_fetchNutritionFromApi] Status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('[_fetchNutritionFromApi] Full response: $data');

        if (data['status'] == 1) {
          final nutriments = data['product']['nutriments'];
          debugPrint('[_fetchNutritionFromApi] Nutriments: $nutriments');

          // Values are per 100g — adjust key names if needed
          final carbsVal = nutriments['carbohydrates_100g']?.toString() ?? '';
          final proteinVal = nutriments['proteins_100g']?.toString() ?? '';
          final fatsVal = nutriments['fat_100g']?.toString() ?? '';

          debugPrint(
            '[_fetchNutritionFromApi] carbs=$carbsVal, protein=$proteinVal, fats=$fatsVal',
          );

          carbs.text = carbsVal;
          protein.text = proteinVal;
          fats.text = fatsVal;

          update();
        } else {
          debugPrint(
            '[_fetchNutritionFromApi] ❌ Product not found in database',
          );
        }
      } else {
        debugPrint(
          '[_fetchNutritionFromApi] ❌ HTTP error: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('[_fetchNutritionFromApi] ❌ Exception: $e');
    } finally {
      // FIX: Reset so the same barcode can be scanned again if needed
      lastScannedValue = '';
      isProcessing = false;

      mobileScannerController.start();
      debugPrint('[_fetchNutritionFromApi] Scanner resumed');
    }
  }

  void setNutritionFromBarcode(String scannedValue) {
    debugPrint('[setNutritionFromBarcode] Parsing: "$scannedValue"');

    bool parsed = false;

    // Format 1: carbs=10&protein=5&fats=2
    if (!parsed && scannedValue.contains('=')) {
      debugPrint('[setNutritionFromBarcode] Trying URL/query format...');
      parsed = _parseUrlFormat(scannedValue);
    }

    // Format 2: carbs:10,protein:5,fats:2
    if (!parsed && scannedValue.contains(':')) {
      debugPrint('[setNutritionFromBarcode] Trying colon format...');
      parsed = _parseColonFormat(scannedValue);
    }

    // Format 3: {"carbs":10,"protein":5,"fats":2}
    if (!parsed && (scannedValue.contains('{') || scannedValue.contains('"'))) {
      debugPrint('[setNutritionFromBarcode] Trying JSON format...');
      parsed = _parseJsonFormat(scannedValue);
    }

    if (parsed) {
      debugPrint(
        '[setNutritionFromBarcode] ✅ Success — '
        'carbs="${carbs.text}", protein="${protein.text}", fats="${fats.text}"',
      );
    } else {
      debugPrint(
        '[setNutritionFromBarcode] ❌ No format matched for: "$scannedValue"',
      );
    }

    update(); // Rebuild all GetBuilder<ScanBarcodeController> widgets
  }

  // Returns true if at least one field was filled
  bool _parseUrlFormat(String value) {
    try {
      final carbsMatch = RegExp(
        r'carbs[=:]([0-9.]+)',
        caseSensitive: false,
      ).firstMatch(value);
      final proteinMatch = RegExp(
        r'protein[=:]([0-9.]+)',
        caseSensitive: false,
      ).firstMatch(value);
      final fatsMatch = RegExp(
        r'fats[=:]([0-9.]+)',
        caseSensitive: false,
      ).firstMatch(value);

      debugPrint(
        '[_parseUrlFormat] carbs=${carbsMatch?.group(1)}, protein=${proteinMatch?.group(1)}, fats=${fatsMatch?.group(1)}',
      );

      if (carbsMatch != null) carbs.text = carbsMatch.group(1) ?? '';
      if (proteinMatch != null) protein.text = proteinMatch.group(1) ?? '';
      if (fatsMatch != null) fats.text = fatsMatch.group(1) ?? '';

      return carbsMatch != null || proteinMatch != null || fatsMatch != null;
    } catch (e) {
      debugPrint('[_parseUrlFormat] Error: $e');
      return false;
    }
  }

  bool _parseColonFormat(String value) {
    try {
      final carbsMatch = RegExp(r'[Cc]arbs:([0-9.]+)').firstMatch(value);
      final proteinMatch = RegExp(r'[Pp]rotein:([0-9.]+)').firstMatch(value);
      final fatsMatch = RegExp(r'[Ff]ats:([0-9.]+)').firstMatch(value);

      debugPrint(
        '[_parseColonFormat] carbs=${carbsMatch?.group(1)}, protein=${proteinMatch?.group(1)}, fats=${fatsMatch?.group(1)}',
      );

      if (carbsMatch != null) carbs.text = carbsMatch.group(1) ?? '';
      if (proteinMatch != null) protein.text = proteinMatch.group(1) ?? '';
      if (fatsMatch != null) fats.text = fatsMatch.group(1) ?? '';

      return carbsMatch != null || proteinMatch != null || fatsMatch != null;
    } catch (e) {
      debugPrint('[_parseColonFormat] Error: $e');
      return false;
    }
  }

  bool _parseJsonFormat(String value) {
    try {
      final carbsMatch = RegExp(r'"carbs"\s*:\s*([0-9.]+)').firstMatch(value);
      final proteinMatch = RegExp(
        r'"protein"\s*:\s*([0-9.]+)',
      ).firstMatch(value);
      final fatsMatch = RegExp(r'"fats"\s*:\s*([0-9.]+)').firstMatch(value);

      debugPrint(
        '[_parseJsonFormat] carbs=${carbsMatch?.group(1)}, protein=${proteinMatch?.group(1)}, fats=${fatsMatch?.group(1)}',
      );

      if (carbsMatch != null) carbs.text = carbsMatch.group(1) ?? '';
      if (proteinMatch != null) protein.text = proteinMatch.group(1) ?? '';
      if (fatsMatch != null) fats.text = fatsMatch.group(1) ?? '';

      return carbsMatch != null || proteinMatch != null || fatsMatch != null;
    } catch (e) {
      debugPrint('[_parseJsonFormat] Error: $e');
      return false;
    }
  }

  void save() {
    debugPrint(
      '[ScanBarcodeController] save() — '
      'carbs="${carbs.text}", protein="${protein.text}", fats="${fats.text}"',
    );
    Get.back();
  }

  @override
  void onClose() {
    debugPrint('[ScanBarcodeController] onClose — disposing');
    mobileScannerController.dispose();
    carbs.dispose();
    protein.dispose();
    fats.dispose();
    super.onClose();
  }
}
