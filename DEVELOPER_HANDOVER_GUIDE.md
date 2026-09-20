# Velvet & Iron Training Codex — Developer Handover & Continuity Guide

> **Emergency Note for Any Incoming Developer:**  
> Read this document **before** touching code or communicating with the client. This document outlines the project background, strict client commitments, critical gotchas, and technical architecture so you do not repeat past mistakes.

---

## 1. Project & Client Overview

* **App Name:** **Velvet & Iron Training Codex**
* **Bundle Identifier:** `com.velvet.velvetiron`
* **Client / Product Owner:** Jamie (Velvet and Iron LLC)
* **Target Launch:** October 2026 (Beta release candidate by **September 28, 2026**)
* **Communication Style with Client:** Highly professional, direct, transparent, and date-driven. Jamie expects proactive communication and verifiable test builds rather than vague status updates.

---

## 2. Strict Client Agreements & Commitments

### ⚠️ RULE 1: DO NOT PROMISE OR WORK ON FIGMA
* **Context:** In May 2026, Figma design stopped being updated. On August 6, Jamie sent revised UI specs, quotes, and artwork. The engineering team decided to implement changes **directly in Flutter code** without updating Figma first.
* **Agreement Reached:** Jamie was informed that with only weeks until launch, all development hours are dedicated **100% to Flutter code and live builds**. **Do NOT promise to update Figma frames.** Visual changes are reviewed via live APKs, TestFlight builds, and device screenshots.

### ⚠️ RULE 2: LANGUAGE & TERMINOLOGY
* This app is a gamified fantasy habit and wellness tracker.
* **BANNED TERM:** Do **NOT** use the words `"to-do"` or `"tasks"`.
* **MANDATORY TERM:** Always use **`"Quests"`**. For example, the Home screen empty state must say:  
  `"No quests scheduled for today."` (Never `"No to-dos scheduled"`).

### ⚠️ RULE 3: THE CELESTIAL SUN WATERMARK
* The onboarding screens originally had a celestial sun watermark overlay behind the cards. The client requested this removed so the custom theme background artwork is visible.
* **Do NOT re-add the sun watermark overlay.**

---

## 3. Milestone Delivery Schedule (Binding Deadlines)

Jamie agreed to this schedule and is tracking deliverables against these dates:

| Milestone | Scope of Delivery | Deadline | Status |
| :--- | :--- | :--- | :--- |
| **Milestone 1: Visual & Store Alignment** | • Store listing updated to *"Velvet & Iron Training Codex"*<br>• Figma Welcome Card restored<br>• 4 Path medallions integrated<br>• Character artwork corrected | **Saturday, Sept 19** | **COMPLETED & SIGNED OFF** |
| **Milestone 2: Core Functionality (Logs & Scanner)** | • Barcode scanner with food nutrition API lookup<br>• Full exercise logging and session history persistence<br>• Companion dialogue interactions verified end-to-end | **Wednesday, Sept 23** | ⏳ **IN PROGRESS (Next Up)** |
| **Milestone 3: Quest & Scheduling Systems** | • Custom quest creation (with XP anti-abuse caps)<br>• Recurring medication & workout rules (Daily/Weekly)<br>• Unified quest checklist feed on Home | **Friday, Sept 25** | ⏳ Scheduled |
| **Milestone 4: Full Beta Release Candidate** | • End-to-end regression testing<br>• Feature-complete release candidate submitted to TestFlight & Google Play Internal Testing | **Monday, Sept 28** | ⏳ Scheduled |

---

## 4. Theme System & Companion Artwork Reference

The app has 4 core fantasy themes/paths. Each theme has a corresponding **Path Medallion**, **Jewellery Frame**, **Sigil Diamond**, and **Companion Character**.

| Theme ID | Path Name | Companion Character | Asset Identifier | Path Medallion Icon |
| :--- | :--- | :--- | :--- | :--- |
| `adventurer` | The Adventurer | **General Leon** | `ImagePath.generalLeon` | D20 Die |
| `reader` | The Scribe | **Riven** | `ImagePath.riven` | Scroll & Quill |
| `mage` | The Mage | **Visepheron** | `ImagePath.visepheron` | Arcane Crystal |
| `gamer` | The Realmwalker | **Thyra** | `ImagePath.thyra` | Teleportation Portal |

> ⚠️ **Past Bug Warning:** Riven's newer artwork was previously mistakenly assigned to Visepheron. Always ensure `riven` uses the Scribe artwork and `visepheron` uses the Mage artwork.

---

## 5. In-App Purchases & RevenueCat (Critical Knowledge)

* **SDK:** `purchases_flutter: ^10.12.0`
* **Entitlement ID:** `premium`
* **Offering ID:** `default`
* **Packages:**
  * Monthly: `$rc_monthly` (Product ID: `velvet_iron_monthly`)
  * Annual: `$rc_annual` (Product ID: `velvet_iron_annual`)

### The iOS StoreKit Paywall Issue:
* **Why StoreKit was not popping up on iOS:**
  1. In **App Store Connect → Business → Agreements**, the **Paid Apps Agreement** is in status **"New"** (unsigned). Apple blocks all StoreKit queries across the entire developer account until the Account Holder clicks "View Terms" and accepts it.
  2. In `onboarding11_controller.dart`, there was a silent bypass bug where if `packageToBuy == null`, it skipped StoreKit and called `completeOnboarding()`.
* **If you are testing subscriptions:**
  * Ensure the Paid Apps Agreement in App Store Connect is **Active**.
  * Never let the app complete onboarding without a verified `customerInfo` when "Premium" is selected.

---

## 6. Architecture & Codebase Map

### Tech Stack
* **Framework:** Flutter (Dart SDK `>=3.0.0`)
* **State Management:** GetX (`GetxController`, `Obx`, `GetBuilder`)
* **Backend:** REST API + Firebase Core / Auth
* **Local Storage:** `shared_preferences` (`SharedPreferencesHelper`)
* **Payments:** RevenueCat (`RevenueCatService`)
* **Environment Variables:** `flutter_dotenv` (`.env`)

### Key Directories & Files
* `lib/main.dart` — App bootstrap, dotenv initialization, RevenueCat init.
* `lib/core/utils/app_theme/controller/app_theme_controller.dart` — Global active theme and gradient controller.
* `lib/core/services/revenuecat_service.dart` — RevenueCat wrapper (`purchasePackage`, `getCurrentOffering`).
* `lib/features/home/screen/home_screen.dart` — Home dashboard with Welcome Card and "Today's Quests".
* `lib/features/home/widgets/popup_dialogue.dart` — Companion dialogue bubble engine.
* `lib/features/qr_code_scan/` — Barcode scanner and food nutrition lookup.
* `lib/features/daily_logs/` — Daily logs for weight, mood, hydration, and workouts.
* `lib/features/onboarding_screens/` — 11 onboarding steps. Step 11 is the subscription screen.
* `lib/features/quests/` — Codex quests and custom user quest creation.

---

## 7. How to Build & Test

### Android (APK & AAB)
```bash
# Debug APK
flutter build apk --debug

# Release APK for tester distribution
flutter build apk --release

# Production App Bundle for Google Play
flutter build appbundle --release
```

### iOS (TestFlight / IPA)
```bash
# Build iOS bundle
flutter build ios --release

# Pod management
cd ios && pod install && cd ..
```
* Note: Bundle ID is `com.velvet.velvetiron`. Display name is configured in `ios/Runner/Info.plist` as `Velvet & Iron Training Codex`.

---

## 8. Daily Workflow & Communication Rule
* If you run into a backend or third-party blocker (e.g. Apple StoreKit delay or API outage), **flag it immediately** to the project lead or client.
* Never leave the client without an update at the end of a scheduled milestone day.
