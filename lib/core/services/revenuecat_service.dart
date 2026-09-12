import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const String entitlementId = 'premium';
  static bool _isConfigured = false;

  static bool get isConfigured => _isConfigured;

  /// Initialize RevenueCat SDK
  static Future<void> init() async {
    try {
      String apiKey = dotenv.env['REVENUECAT_API_KEY'] ?? '';
      
      // Clean up any extra quotes or whitespace
      apiKey = apiKey
          .replaceAll("'", "")
          .replaceAll('"', '')
          .replaceAll(';', '')
          .trim();

      if (apiKey.isEmpty) {
        debugPrint('RevenueCat Warning: REVENUECAT_API_KEY is empty in .env');
        return;
      }

      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      _isConfigured = true;
      debugPrint(
        'RevenueCat initialized successfully with key: ${apiKey.length > 8 ? apiKey.substring(0, 8) : apiKey}...',
      );
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  /// Get current offerings
  static Future<Offering?> getCurrentOffering() async {
    try {
      if (!_isConfigured) await init();
      Offerings offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
      return null;
    }
  }

  /// Purchase a package
  static Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      return purchaseResult.customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('User cancelled purchase');
        return null;
      }
      rethrow;
    } catch (e) {
      debugPrint('Error purchasing package: $e');
      rethrow;
    }
  }

  /// Check if user has active entitlement
  static Future<bool> isPremiumActive() async {
    try {
      if (!_isConfigured) await init();
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      debugPrint('Error checking premium entitlement: $e');
      return false;
    }
  }

  /// Get customer info
  static Future<CustomerInfo?> getCustomerInfo() async {
    try {
      if (!_isConfigured) await init();
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('Error getting customer info: $e');
      return null;
    }
  }

  /// Restore purchases
  static Future<CustomerInfo?> restorePurchases() async {
    try {
      if (!_isConfigured) await init();
      return await Purchases.restorePurchases();
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      rethrow;
    }
  }

  /// Log in with User ID
  static Future<void> logIn(String appUserId) async {
    try {
      if (!_isConfigured) await init();
      if (appUserId.isNotEmpty) {
        await Purchases.logIn(appUserId);
      }
    } catch (e) {
      debugPrint('Error logging in to RevenueCat: $e');
    }
  }

  /// Log out
  static Future<void> logOut() async {
    try {
      if (_isConfigured) {
        await Purchases.logOut();
      }
    } catch (e) {
      debugPrint('Error logging out from RevenueCat: $e');
    }
  }
}
