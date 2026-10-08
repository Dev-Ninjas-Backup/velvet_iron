import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/revenuecat_service.dart';

class SubscriptionLegalDisclaimer extends StatelessWidget {
  final bool showDisclosure;
  final bool showRestore;
  final TextStyle? linkStyle;
  final TextStyle? disclosureStyle;

  const SubscriptionLegalDisclaimer({
    super.key,
    this.showDisclosure = true,
    this.showRestore = true,
    this.linkStyle,
    this.disclosureStyle,
  });

  static Future<void> launchUrlSafe(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('[SubscriptionLegalDisclaimer] Error launching URL: $e');
    }
  }

  static Future<void> restorePurchasesAction() async {
    try {
      EasyLoading.show(status: 'Restoring purchases...');
      final info = await RevenueCatService.restorePurchases();
      EasyLoading.dismiss();
      final hasActive =
          info?.entitlements.all[RevenueCatService.entitlementId]?.isActive ??
          false;
      if (hasActive) {
        EasyLoading.showSuccess('Subscription restored successfully!');
      } else {
        EasyLoading.showInfo('No active subscription found to restore.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Could not restore purchases: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLinkStyle = linkStyle ??
        const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          decoration: TextDecoration.underline,
        );

    final effectiveDisclosureStyle = disclosureStyle ??
        const TextStyle(
          color: Colors.white54,
          fontSize: 10,
          height: 1.4,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clickable Links Row (Terms of Use (EULA) | Privacy Policy | Restore Purchases)
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            GestureDetector(
              onTap: () => launchUrlSafe(Urls.appleEulaUrl),
              child: Text(
                'Terms of Use (EULA)',
                style: effectiveLinkStyle,
              ),
            ),
            const Text('•', style: TextStyle(color: Colors.white38, fontSize: 10)),
            GestureDetector(
              onTap: () => launchUrlSafe(Urls.privacyPolicyUrl),
              child: Text(
                'Privacy Policy',
                style: effectiveLinkStyle,
              ),
            ),
            if (showRestore) ...[
              const Text('•', style: TextStyle(color: Colors.white38, fontSize: 10)),
              GestureDetector(
                onTap: restorePurchasesAction,
                child: Text(
                  'Restore Purchases',
                  style: effectiveLinkStyle,
                ),
              ),
            ],
          ],
        ),

        if (showDisclosure) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period. You can manage or cancel your subscription in your App Store Account Settings anytime after purchase.',
              textAlign: TextAlign.center,
              style: effectiveDisclosureStyle,
            ),
          ),
        ],
      ],
    );
  }
}
