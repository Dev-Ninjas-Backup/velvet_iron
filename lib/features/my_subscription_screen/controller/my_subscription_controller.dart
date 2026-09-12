import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velvet_iron/core/services/revenuecat_service.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class MySubscriptionController extends GetxController {
  RxBool isPremium = false.obs;
  RxBool isLoading = false.obs;

  RxString planName = "Free Plan".obs;
  RxString price = "Free".obs;
  RxString billingPeriod = "".obs;
  RxString renewDate = "".obs;
  RxString expireDate = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionStatus();
  }

  Future<void> fetchSubscriptionStatus() async {
    try {
      isLoading.value = true;

      // Identify user in RevenueCat if logged in
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId != null && userId.isNotEmpty) {
        await RevenueCatService.logIn(userId);
      }

      final customerInfo = await RevenueCatService.getCustomerInfo();
      final entitlement =
          customerInfo?.entitlements.all[RevenueCatService.entitlementId];

      DateTime? exp;
      DateTime? pur;

      if (entitlement != null) {
        if (entitlement.expirationDate != null) {
          try {
            exp = DateTime.parse(entitlement.expirationDate!);
          } catch (_) {}
        }

        if (entitlement.latestPurchaseDate.isNotEmpty) {
          try {
            pur = DateTime.parse(entitlement.latestPurchaseDate);
          } catch (_) {}
        }
      }

      // Verify if active and not passed expiration time
      final isActuallyActive = entitlement != null &&
          entitlement.isActive &&
          (exp == null || exp.toUtc().isAfter(DateTime.now().toUtc()));

      if (isActuallyActive) {
        isPremium.value = true;
        planName.value = "Premium";

        // Check if annual or monthly
        if (entitlement.productIdentifier.contains('annual')) {
          price.value = "USD \$119.99";
          billingPeriod.value = "/ per year";
        } else {
          price.value = "USD \$14.99";
          billingPeriod.value = "/ per month";
        }

        // If expiration is on the same day (sandbox/testing), show the time
        final isSameDay = pur != null &&
            exp != null &&
            pur.year == exp.year &&
            pur.month == exp.month &&
            pur.day == exp.day;

        final dateFormat = isSameDay
            ? DateFormat('MMM dd, yyyy (h:mm a)')
            : DateFormat('MMM dd, yyyy');

        if (exp != null) {
          expireDate.value = dateFormat.format(exp.toLocal());
        }

        if (pur != null) {
          renewDate.value = dateFormat.format(pur.toLocal());
        }
      } else {
        isPremium.value = false;
        planName.value = "Free Plan";
        price.value = "Free";
        billingPeriod.value = "";
        renewDate.value = "";
        expireDate.value = "";
      }
    } catch (e) {
      debugPrint('Error fetching subscription status: $e');
      isPremium.value = false;
      planName.value = "Free Plan";
      price.value = "Free";
      billingPeriod.value = "";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelSubscription() async {
    // Official Apple & Google Play store subscription management URLs
    final Uri url = Platform.isIOS
        ? Uri.parse("https://apps.apple.com/account/subscriptions")
        : Uri.parse("https://play.google.com/store/account/subscriptions");

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        EasyLoading.showInfo(
          "Please manage subscriptions from your App Store / Google Play account.",
        );
      }
    } catch (e) {
      EasyLoading.showError("Could not open store subscription settings");
    }
  }

  Future<void> renewSubscription() async {
    try {
      EasyLoading.show(status: 'Checking subscription...');
      final customerInfo = await RevenueCatService.restorePurchases();
      final entitlement =
          customerInfo?.entitlements.all[RevenueCatService.entitlementId];

      if (entitlement != null && entitlement.isActive) {
        EasyLoading.showSuccess("Subscription active!");
        await fetchSubscriptionStatus();
      } else {
        EasyLoading.showInfo(
          "No active subscription found. You can subscribe anytime.",
        );
      }
    } catch (e) {
      EasyLoading.showError("Error: ${e.toString()}");
    }
  }
}
