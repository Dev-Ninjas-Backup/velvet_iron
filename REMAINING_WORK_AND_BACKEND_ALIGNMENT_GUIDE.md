# Velvet & Iron — Remaining Work & Backend Alignment Guide

> **Purpose of this Document:**  
> This document maps out all remaining deliverables across **Milestones 2, 3, and 4**. It clearly divides the work into:
> 1. **Work that can be completed on the Frontend NOW** (100% independent of the backend).
> 2. **Work that requires the Backend** (specifications, expected schemas, and logic).
> 3. **Backend Handover Comparison Matrix** (to cross-reference against whatever document/endpoints the backend developer delivers).

---

## 1. Work Can Be Done on Frontend IMMEDIATELY (Zero Backend Dependency)

The following items do not require any backend updates and can be built, polished, and tested directly in Flutter:

### A. StoreKit / Apple In-App Purchase Flow (Immediate Critical Fix)
* **Status:** Blocked on the Apple side until the client signs the Paid Apps Agreement in App Store Connect, but the Flutter code has bugs that must be fixed now:
* **Fix 1:** In `onboarding11_controller.dart`, remove the silent bypass where `packageToBuy == null` completes onboarding. Show a clear error dialog (`"Unable to connect to App Store subscriptions. Please check your internet or try again."`) to prevent false subscription confirmations.
* **Fix 2:** In `onboarding11_screen.dart`, fix the inverted UI order. Trigger Apple StoreKit first when tapping "Continue Subscription", and show the *"Congratulations! Your subscription is activated"* popup **only after** StoreKit confirms the payment.
* **Fix 3:** In `revenuecat_service.dart`, add fallback offering lookup (`offerings.current ?? offerings.all.values.firstOrNull`).

---

### B. Milestone 2: Barcode Scanner & Nutrition Lookup (Due Sept 23)
* **Current State:** The scanner is wired to the **Open Food Facts API** (`world.openfoodfacts.org`), which is a free, public, third-party database. It does **not** rely on the Velvet & Iron custom backend.
* **Frontend Tasks to Complete:**
  1. Polish camera overlay and viewfinder in `lib/features/qr_code_scan/`.
  2. Implement clear fallback UI when a barcode is not found in the public database (allow manual food name and macro entry).
  3. Support serving size multipliers (e.g. 1 serving vs 100g).
  4. Save scanned meals to the local meal log state / SharedPreferences.

---

### C. Milestone 2: Exercise Session Tracking & Timer (Due Sept 23)
* **Frontend Tasks to Complete:**
  1. Build/polish the workout timer (Play, Pause, Resume, Reset, Finish).
  2. Implement set, rep, and weight input counters for logged exercises.
  3. Add local caching (`SharedPreferences`) for exercise logs so that completed workouts are saved and displayed locally even if the backend is offline or in progress.

---

### D. Milestone 2: Companion Dialogue System End-to-End (Due Sept 23)
* **Current State:** The 800+ quote library is already bundled locally in `assets/dialogue/companion_quotes.json`. Dialogue triggers are evaluated **100% on-device** in Flutter.
* **Frontend Tasks to Complete:**
  1. Verify dialogue popups across all in-app triggers:
     - App launch / greetings (Morning, Afternoon, Evening).
     - Logging a meal / scanning food.
     - Logging a workout / finishing exercise.
     - Logging hydration / drinking water.
     - Completing a quest.
     - Tapping the companion character on the Home Screen.

---

### E. Milestone 3: Custom Quest Creator UI & Local Mock (Due Sept 25)
* **Frontend Tasks to Complete (Mock Layer):**
  1. Build the full UI modal / screen for creating custom quests:
     - Quest Name text field.
     - Category picker (Fitness, Nutrition, Mindfulness, General).
     - Recurrence selector (Daily, Weekly, Specific Days, One-time).
     - Reminder time & notification toggle.
     - XP preview with anti-abuse cap (e.g. max 10–15 XP).
  2. Wire custom quest creation to **local storage (`SharedPreferences`)**.
  3. Allow the client to create, view, and check off custom quests right now on their device. When the backend developer delivers the API, we simply swap the local storage call with the HTTP request.

---

### F. Milestone 3: Recurring Medication & Exercise Pickers (Due Sept 25)
* **Frontend Tasks to Complete:**
  1. Add recurrence selector in the Medication screen (Daily, Weekly, Specific Days).
  2. Add action menus for each scheduled item (Edit, Pause, Delete).
  3. Store schedule rules locally until the backend recurrence endpoints are connected.

---

## 2. Work That REQUIRES the Backend Team

The following features depend on database schema changes and API endpoints from the backend developer:

| Feature Area | Why Backend is Required | Required Endpoint / Logic |
| :--- | :--- | :--- |
| **Custom Quests CRUD** | Need database collection to persist user-created quests across devices and logins. | • `POST /quests/custom`<br>• `GET /quests/custom`<br>• `PATCH /quests/custom/:id`<br>• `DELETE /quests/custom/:id`<br>• `PATCH /quests/custom/:id/complete` |
| **Recurring Schedules** | Currently, backend only accepts a single date/time. Needs recurrence rules (Daily, Weekly) and reminder triggers. | • `recurrence` field in `/medication` and `/exercise-log/schedule`<br>• Edit, Pause, and Delete endpoints |
| **XP Award Timing Fix** | Currently, scheduling a meal/workout immediately gives +10 XP. XP must only be awarded when actually completed. | Backend database logic change in completion endpoints |
| **Independent Calorie Goal** | Backend currently calculates calories via `4P + 4C + 9F`. Must allow a user-defined manual calorie target. | Allow manual `calorieGoal` in user profile schema |
| **Companion Database Seeds** | Companion names, titles, and unlock thresholds must match official launch characters. | Seed updates for Riven, Thyra, General Leon, Visepheron |

---

## 3. Backend Handover Comparison Matrix

When the backend developer delivers their documentation and endpoints, use this checklist to cross-reference their deliverables against our requirements:

### Checklist 1: Custom Quests API

| Requirement | Expected Specification | Backend Developer Delivered | Match? (Yes/No) | Notes / Adjustments |
| :--- | :--- | :--- | :--- | :--- |
| **Create Custom Quest** | `POST /quests/custom`<br>Body: `{ name, category, recurrence, daysOfWeek, scheduledTime, xp }` | *(Fill from Backend Doc)* | [ ] | |
| **Fetch User Quests** | `GET /quests/custom?date=YYYY-MM-DD`<br>Returns: array of active quests for that date | *(Fill from Backend Doc)* | [ ] | |
| **Complete Quest** | `PATCH /quests/custom/:id/complete`<br>Marks done and awards XP | *(Fill from Backend Doc)* | [ ] | |
| **Edit Quest** | `PUT` or `PATCH /quests/custom/:id` | *(Fill from Backend Doc)* | [ ] | |
| **Pause / Resume Quest** | `PATCH /quests/custom/:id/pause` or `isPaused` flag | *(Fill from Backend Doc)* | [ ] | |
| **Delete Quest** | `DELETE /quests/custom/:id` | *(Fill from Backend Doc)* | [ ] | |
| **XP Anti-Abuse Cap** | Server must cap custom quest XP (e.g. max 15 XP each, max 50 XP/day) | *(Fill from Backend Doc)* | [ ] | |

---

### Checklist 2: Recurring Schedules (Medication & Exercise)

| Requirement | Expected Specification | Backend Developer Delivered | Match? (Yes/No) | Notes / Adjustments |
| :--- | :--- | :--- | :--- | :--- |
| **Recurrence Field** | Supports `"NONE"`, `"DAILY"`, `"WEEKLY"`, `"SPECIFIC_DAYS"` | *(Fill from Backend Doc)* | [ ] | |
| **Days of Week** | Accepts array `[1, 2, 3, 4, 5]` (Monday–Friday) | *(Fill from Backend Doc)* | [ ] | |
| **Edit Schedule** | Endpoint to update time, dosage, or exercise details | *(Fill from Backend Doc)* | [ ] | |
| **Delete Schedule** | Endpoint to remove a scheduled medication or exercise | *(Fill from Backend Doc)* | [ ] | |
| **Pause Schedule** | Endpoint to temporarily stop reminders without deleting | *(Fill from Backend Doc)* | [ ] | |

---

### Checklist 3: XP Awarding & Macro Logic

| Requirement | Expected Specification | Backend Developer Delivered | Match? (Yes/No) | Notes / Adjustments |
| :--- | :--- | :--- | :--- | :--- |
| **XP Timing** | XP is **only** awarded when marking an item completed/taken (NOT upon creation/scheduling) | *(Fill from Backend Doc)* | [ ] | |
| **Manual Calorie Goal** | `calorieGoal` can be updated without backend overriding it via `4P + 4C + 9F` | *(Fill from Backend Doc)* | [ ] | |
| **Gender Enum** | Accepts `"MALE"`, `"FEMALE"`, `"OTHER"` / `"PREFER_NOT_TO_SAY"` | *(Fill from Backend Doc)* | [ ] | |

---

## 4. Recommended Next Action Plan

While waiting for the backend developer's documentation:
1. **Fix Onboarding 11 StoreKit Flow**: Fix the bypass bug and inverted UI so the app is ready for when Apple activates the agreement.
2. **Finalize Barcode Scanner (Milestone 2)**: Polish the Open Food Facts scanning experience and food entry UI.
3. **Build Exercise Timer & Local Storage (Milestone 2)**: Ensure full workout logging works cleanly on-device.
4. **Build the Custom Quest Creator UI with Local Mock (Milestone 3)**: Complete the screens and bottom sheets so we only need to plug in the endpoints when the backend developer provides their document.
