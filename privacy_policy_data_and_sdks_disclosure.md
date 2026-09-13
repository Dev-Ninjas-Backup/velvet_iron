# Velvet Iron — Complete User Data Collection & Third-Party SDK Disclosure

**Document Purpose:** Complete audit and declaration of all user data collected, stored, and processed by the **Velvet Iron** mobile application, along with a comprehensive inventory of all integrated third-party SDKs and services. This document provides the exact information required to author the public Privacy Policy and accurately complete the **Google Play Console Data Safety** questionnaire and **Apple App Store Privacy Labels**.

---

## 1. Application Overview

| Attribute | Details |
| :--- | :--- |
| **Application Name** | Velvet Iron (Velvet and Iron Training Guide) |
| **Package Name / Application ID (Android)** | `com.velvet.velvetiron` |
| **Bundle Identifier (iOS)** | `com.velvet.velvetiron` |
| **Target Platforms** | Android & iOS (Flutter framework) |
| **App Category** | Health & Fitness / Lifestyle / Gamified Wellness |
| **Primary Backend API** | `https://velvet.api.softvence.app` |

---

## 2. Complete Inventory of User Data Collected & Stored

The application collects data across several categories to provide personalized health tracking, medication scheduling, gamified quests, and premium subscription access.

### A. Personal Identification & Account Information
*Collected to create user accounts, authenticate sessions, and deliver profile personalization.*

| Data Field | Description / Technical Key | Stored On Device? | Transmitted to Backend / Third-Party? |
| :--- | :--- | :--- | :--- |
| **Full Name** | User's display name (`name`) | Yes (`SharedPreferences`) | Yes (Velvet Iron Backend API) |
| **Email Address** | User's contact & login email (`email`) | Yes (`SharedPreferences`) | Yes (Velvet Iron Backend API, Firebase Auth) |
| **Username** | Unique public handle (`username`) | Yes (`SharedPreferences`) | Yes (Velvet Iron Backend API) |
| **Password** | Account password for authentication | No (never stored locally in plaintext) | Transmitted securely via HTTPS to Backend for hashing |
| **Profile Photo / Avatar** | Profile avatar image or custom companion image | Yes (cached locally) | Yes (Velvet Iron Backend API) |
| **User ID** | Unique database identifier (`userId`) | Yes (`SharedPreferences`) | Yes (Velvet Iron Backend API, RevenueCat) |
| **Authentication Tokens** | JWT `access_token` and `refresh_token` | Yes (`SharedPreferences`) | Sent in HTTPS Authorization headers |
| **Account Role & Status** | `role`, `emailVerified`, `onBoarded`, `iscomplete` | Yes (`SharedPreferences`) | Yes (Velvet Iron Backend API) |

---

### B. Health, Fitness, Medical & Dietary Information (Sensitive Data)
*Collected solely to deliver the app’s core functionality: health tracking, medication compliance, diet logs, and workout progression.*

| Data Field | Description / Scope | Purpose & Usage |
| :--- | :--- | :--- |
| **Medication Records & Schedules** | • Medication names<br>• Prescribed dosages & frequencies<br>• Scheduled consumption times<br>• Medication intake logs (`taken: true/false`)<br>• Historical medication compliance records | Tracks prescription schedules, alerts the user to take doses on time, and records health compliance history. |
| **Body Weight & Physical Metrics** | • Body weight log entries<br>• Historical weight progress logs<br>• Weekly weight chart statistics | Enables users to track weight progression over time towards fitness targets. |
| **Fitness & Exercise Logs** | • Exercise types and workout routines<br>• Exercise schedules and completion timestamps<br>• Historical workout logs<br>• User-defined fitness goals | Allows users to track physical activities, workouts, and achieve gamified exercise targets. |
| **Nutrition & Macronutrient Data** | • Daily meal logs & schedules (breakfast, lunch, dinner, snacks)<br>• Food items consumed<br>• Macronutrient target goals (daily protein, carbohydrate, fat, and caloric intake) | Provides nutritional tracking, daily calorie/macro balancing, and diet history. |
| **Mental Well-Being & Mood Tracking** | • Daily mood entries & ratings<br>• Historical mood logs over time | Supports mental wellness tracking in combination with physical activity and daily routines. |

> **Note on Health Data Usage:** Health and medical information collected by Velvet Iron is used **strictly for user-facing app functionality and personal health tracking**. It is **never** sold, rented, or used for advertising, marketing, or third-party profiling.

---

### C. Photos, Camera Access & Device Media
*Accessed only upon explicit runtime user permission.*

| Feature | Permission / SDK Used | Purpose & Handling |
| :--- | :--- | :--- |
| **Camera Hardware** | `android.permission.CAMERA`<br>iOS: `NSCameraUsageDescription`<br>Packages: `camera`, `mobile_scanner`, `image_picker` | • Scanning QR codes to connect features or join communities.<br>• Taking photos of medication ("logshots"), meals, or profile pictures.<br>• Camera frames for barcode scanning are processed **in real-time on-device** and not saved to any server. |
| **Photo Library / Storage** | `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES`<br>iOS: `NSPhotoLibraryUsageDescription`<br>Package: `image_picker` | Used only when the user voluntarily selects a picture from their device gallery to upload as an avatar or attach to a log. |

---

### D. Financial, In-App Purchases & Subscription Data
*Used to manage premium subscriptions and unlock digital features.*

| Data Field | Handled By | Details & Security |
| :--- | :--- | :--- |
| **Subscription Status** | RevenueCat & Velvet Iron Backend | Tracks whether the user holds active `premium` entitlement. |
| **Subscription Plan Type** | RevenueCat (`purchases_flutter`) | Tracks active plan: Monthly (`$14.99/mo`) or Annual (`$119.99/yr`). |
| **Purchase & Expiration Timestamps** | RevenueCat & App Stores | • Initial purchase date<br>• Latest renewal timestamp<br>• Expiration timestamp<br>• Auto-renewal status |
| **Payment Card / Banking Information** | **Google Play Billing** & **Apple App Store** | **NOT COLLECTED OR ACCESSED BY VELVET IRON.** All payment card details, billing addresses, and credit card processing are handled directly and securely by Google and Apple. |

---

### E. Gamification, User Preferences & In-App Activity
*Collected to deliver the app's gamified experience and personalized themes.*

| Data Category | Data Elements | Purpose |
| :--- | :--- | :--- |
| **Gamification Progress** | XP points earned, player level, quest completion status, daily login streak cooldown | Rewards user engagement for consistent health, medication, and workout logging. |
| **App Themes & Companions** | Selected companion character, active UI theme (`Adventurer`, `Mage`, `Gamer`, `Reader`), unlocked companion catalog | Customizes visual interface and audio/visual companion feedback. |
| **User Feedback & Ratings** | User star ratings and text feedback submitted via the in-app feedback screen | Used internally to diagnose issues, resolve bugs, and improve user experience. |

---

### F. Device, Technical & Network Identifiers
*Automatically processed during standard network communication.*

| Data Category | Description | Purpose |
| :--- | :--- | :--- |
| **IP Address** | Internet Protocol address | Standard network transmission to establish secure HTTPS connections with API servers and Firebase. |
| **Network State** | `ACCESS_NETWORK_STATE` | Checks whether the device has an active Wi-Fi or cellular connection to avoid failed network calls. |
| **Deep Link URL Data** | Custom URL scheme (`velvetapp://auth/discord`) | Routes third-party OAuth callbacks (e.g. Discord authentication) back into the app. |
| **Local Storage / Cache** | Platform `SharedPreferences` / Keychain | Securely preserves local session tokens, UI theme choices, and cached profile data on the device. |

---

## 3. Comprehensive List of Integrated Third-Party SDKs & Services

Below is the complete list of all third-party SDKs, libraries, and APIs integrated into the Velvet Iron codebase, their purpose, data shared, and official privacy policies:

### 1. RevenueCat (`purchases_flutter: ^10.12.0`)
* **Provider:** RevenueCat, Inc.
* **Purpose:** In-app purchase management, subscription receipt validation, entitlement verification (`premium`), auto-renewal lifecycle tracking.
* **Data Shared / Collected:**
  * User App ID (`userId` mapped from backend)
  * Purchase receipt and transaction IDs
  * Active subscription tier (`velvet_iron_monthly`, `velvet_iron_annual`)
  * Purchase, renewal, and expiration timestamps
  * Device operating system version and locale
* **Privacy Policy:** [https://www.revenuecat.com/privacy/](https://www.revenuecat.com/privacy/)

---

### 2. Google Firebase Core & Firebase Authentication (`firebase_core: ^4.6.0`, `firebase_auth: ^6.2.0`)
* **Provider:** Google LLC / Alphabet Inc.
* **Purpose:** Core cloud infrastructure and secure authentication bridge for Google accounts.
* **Data Shared / Collected:**
  * Google User ID (UID), Email address, Display name, Profile photo URL
  * IP address, device model, operating system version, authentication timestamps
* **Privacy Policy:** [https://firebase.google.com/support/privacy](https://firebase.google.com/support/privacy)

---

### 3. Google Sign-In SDK (`google_sign_in: ^7.2.0`)
* **Provider:** Google LLC / Alphabet Inc.
* **Purpose:** Enables users to register and sign in seamlessly using their Google accounts (Single Sign-On).
* **Data Shared / Collected:**
  * Google account public profile information (Name, Email address, Profile avatar)
  * Google OAuth2 authentication tokens
* **Privacy Policy:** [https://policies.google.com/privacy](https://policies.google.com/privacy)

---

### 4. Google Play In-App Billing / Apple StoreKit
* **Provider:** Google LLC (Android) / Apple Inc. (iOS)
* **Purpose:** Securely processes credit card and payment transactions for in-app subscriptions.
* **Data Shared / Collected:**
  * Payment method, billing details, device purchase tokens, transaction receipts.
* **Privacy Policies:**
  * Google Play: [https://policies.google.com/privacy](https://policies.google.com/privacy)
  * Apple: [https://www.apple.com/legal/privacy/](https://www.apple.com/legal/privacy/)

---

### 5. Discord OAuth & Community API (`app_links: ^6.3.2`, `url_launcher: ^6.3.2`)
* **Provider:** Discord Inc.
* **Purpose:** Optional Discord authentication and connecting users to the Velvet Iron Discord community.
* **Data Shared / Collected:**
  * Discord User ID, Discord username, avatar URL, and verified email (if granted by user).
  * OAuth2 callback token returned via deep link (`velvetapp://auth/discord`).
* **Privacy Policy:** [https://discord.com/privacy](https://discord.com/privacy)

---

### 6. Google Fonts (`google_fonts: ^6.3.3`)
* **Provider:** Google LLC
* **Purpose:** Dynamically loads brand typography (e.g. Outfit, Inter, Roboto) for app styling.
* **Data Shared / Collected:**
  * Device IP address and HTTP User-Agent when fetching font files from Google's CDN. No cookies or personal accounts are sent.
* **Privacy Policy:** [https://policies.google.com/privacy](https://policies.google.com/privacy)

---

### 7. Google ML Kit / Mobile Scanner & Camera (`mobile_scanner: ^5.1.0`, `camera: ^0.10.5+5`, `image_picker: ^1.2.1`)
* **Provider:** Google LLC & Flutter Community
* **Purpose:** Real-time on-device barcode/QR code detection and image capturing for logs.
* **Data Shared / Collected:**
  * **On-device only:** Camera stream frames are analyzed locally on the device hardware. Image data is not transmitted to Google or external parties; only photos deliberately taken or selected by the user are uploaded to the Velvet Iron backend.

---

### 8. Velvet Iron Dedicated Backend API (`https://velvet.api.softvence.app`)
* **Provider:** Velvet Iron (Hosted securely)
* **Purpose:** Primary application database server storing user accounts, health logs, medication schedules, workout history, macro goals, and gamification state.
* **Data Shared / Collected:** All user-submitted profile and health log data listed in Section 2.
* **Security Measures:** Encrypted in transit via HTTPS/TLS; secured with JWT authentication tokens.

---

## 4. Google Play Console "Data Safety" Section — Quick Cheat Sheet

Use the exact answers below when filling out the **Google Play Console Data Safety** form:

### General Questions
* **Does your app collect or share any of the required user data types?** ➔ **Yes**
* **Is all of the user data collected by your app encrypted in transit?** ➔ **Yes** (All communication uses HTTPS/TLS 1.3)
* **Do you provide a way for users to request that their data be deleted?** ➔ **Yes** (Users can request account and data deletion via app settings or contacting support)

### Data Types Breakdown for Google Play Console

| Google Play Data Category | Collected? | Shared with 3rd Parties? | Purpose |
| :--- | :---: | :---: | :--- |
| **Personal Info ➔ Name** | Yes | No | Account management, Personalization |
| **Personal Info ➔ Email address** | Yes | Yes (Firebase / RevenueCat) | Account management, Authentication |
| **Personal Info ➔ User IDs** | Yes | Yes (Firebase / RevenueCat) | Account management, Analytics |
| **Health and Fitness ➔ Fitness info** | Yes | No | App functionality (Exercise & workout tracking) |
| **Health and Fitness ➔ Health info** | Yes | No | App functionality (Medication & weight tracking) |
| **Financial Info ➔ Purchase history** | Yes | Yes (RevenueCat / Google Play) | App functionality, Subscription management |
| **Photos and Videos ➔ Photos** | Yes (Optional) | No | App functionality (Profile avatar, medication logshot) |
| **App Activity ➔ Other user-generated content** | Yes | No | App functionality (Mood logs, meal logs, feedback) |

---

## 5. User Rights & Data Protection (GDPR / CCPA Compliance)

1. **Right to Access & Portability:** Users can view all of their logged health, medication, workout, and nutritional records directly within the app.
2. **Right to Rectification:** Users can update their profile information, recalculate macro/fitness goals, and edit logs at any time.
3. **Right to Erasure (Account & Data Deletion):** Users have the right to request full deletion of their account, profile data, and historical logs.
4. **Data Security:** All sensitive health, medication, and user credentials are encrypted in transit using SSL/TLS encryption. Passwords are never stored in plaintext.
5. **No Third-Party Advertising or Sale of Data:** Velvet Iron **does not sell, rent, or lease** personal or health data to third-party data brokers or advertising networks.
