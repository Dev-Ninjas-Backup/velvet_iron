# Velvet & Iron — Backend API Requirements (V1 Release)

**Target Base URL**: `https://velvet.api.softvence.app`  
**Date**: September 2026  
**Document Purpose**: Specification of backend database schemas, endpoints, and business logic modifications required to support the V1 UI & Functionality specifications for the Velvet & Iron mobile application.

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Priority 1: Custom Quests System (New Endpoints)](#2-priority-1-custom-quests-system-new-endpoints)
3. [Priority 2: Recurring Medication Scheduling](#3-priority-2-recurring-medication-scheduling)
4. [Priority 3: Recurring Exercise Scheduling](#4-priority-3-recurring-exercise-scheduling)
5. [Priority 4: XP Award Timing & Anti-Abuse Fix](#5-priority-4-xp-award-timing--anti-abuse-fix)
6. [Priority 5: Independent Daily Calorie Goal](#6-priority-5-independent-daily-calorie-goal)
7. [Priority 6: Profile & Onboarding Schema Updates](#7-priority-6-profile--onboarding-schema-updates)
8. [Backend Endpoints & Changes Checklist](#8-backend-endpoints--changes-checklist)

---

## 1. Executive Summary

Based on the V1 Launch Specification, several key features cannot be supported solely by the Flutter client and require server-side modifications:
1. **Custom Quests**: Users must be able to create, edit, pause, and delete their own custom quests. The current API only serves static Codex quests via `GET /xp-stats/quests`.
2. **Recurring Schedules**: Medication and Exercise schedules currently only accept a single ISO timestamp. They need recurrence models (Daily, Weekly, Specific Days, Custom) and standard CRUD operations (Edit, Pause, Delete).
3. **XP Award Logic**: Currently, scheduling a meal or exercise immediately awards +10 XP in the database. XP must **only** be credited when the task is actually marked as completed/taken.
4. **Independent Calorie Goal**: The backend currently overwrites calorie targets using the formula `4*P + 4*C + 9*F`. Users must be able to set a manual Calorie Goal independently of macros.
5. **Enums & Seeds**: Support "Prefer not to say" in gender selection, and update theme naming seeds from "Reader" to "Scribe" and "Gamer" to "Realmwalker".

---

## 2. Priority 1: Custom Quests System (New Endpoints)

### Current State
* Mobile app only has:
  * `GET /xp-stats/quests` — returns hardcoded/system Codex quests.
  * `POST /profile/add-xp/log` — logs arbitrary XP increments.
* There is no database collection or API for user-created custom quests.

### Requirements

#### Schema: `UserCustomQuest`
```typescript
{
  id: string;              // UUID / ObjectId
  userId: string;          // Authenticated user ID
  name: string;            // Quest name (required)
  category: string;        // e.g., "FITNESS", "NUTRITION", "MINDFULNESS", "GENERAL"
  description?: string;    // Optional notes/description
  scheduledDate?: string;  // ISO Date (YYYY-MM-DD)
  scheduledTime?: string;  // HH:mm (optional time of day)
  recurrence: "NONE" | "DAILY" | "WEEKLY" | "SPECIFIC_DAYS" | "CUSTOM";
  daysOfWeek?: number[];   // 1 = Monday ... 7 = Sunday (if WEEKLY / SPECIFIC_DAYS)
  reminderEnabled: boolean;// Whether to send push notification
  reminderTime?: string;   // ISO time or minutes before
  isDone: boolean;         // Completion status for today
  isPaused: boolean;       // Paused status (default: false)
  xp: number;              // Controlled XP reward (e.g., fixed at 10 XP or capped at 25 XP)
  createdAt: string;
  updatedAt: string;
}
```

#### Required Endpoints

##### 1. `POST /quests/custom` — Create Custom Quest
* **Headers**: `Authorization: Bearer <accessToken>`
* **Request Body**:
  ```json
  {
    "name": "Morning Walk & Sunlight",
    "category": "FITNESS",
    "description": "15 minute walk outside after waking up",
    "scheduledDate": "2026-09-17",
    "scheduledTime": "08:00",
    "recurrence": "DAILY",
    "daysOfWeek": [1, 2, 3, 4, 5],
    "reminderEnabled": true,
    "xp": 10
  }
  ```
* **Server Logic**: Validate and enforce that `xp` cannot exceed an anti-abuse cap (e.g., max 15 XP per custom quest, max 5 custom quest completions per day).
* **Response `201 Created`**: Returns created `UserCustomQuest` object.

##### 2. `GET /quests/custom` — Fetch User's Custom Quests
* **Query Params**: `?date=YYYY-MM-DD` (optional, filter for today's active/due quests)
* **Response `200 OK`**:
  ```json
  {
    "success": true,
    "quests": [
      {
        "id": "quest_uuid",
        "name": "Morning Walk & Sunlight",
        "category": "FITNESS",
        "description": "15 minute walk outside after waking up",
        "recurrence": "DAILY",
        "isDone": false,
        "isPaused": false,
        "xp": 10,
        "isCustom": true
      }
    ]
  }
  ```

##### 3. `PATCH /quests/custom/:id` — Edit Custom Quest
* **Request Body**: Partial update (`name`, `category`, `description`, `recurrence`, `daysOfWeek`, `reminderEnabled`).
* **Response `200 OK`**: Returns updated quest.

##### 4. `PATCH /quests/custom/:id/pause` — Pause / Resume Quest
* **Request Body**:
  ```json
  { "isPaused": true }
  ```
* **Response `200 OK`**: Toggles quest active state.

##### 5. `DELETE /quests/custom/:id` — Delete Custom Quest
* **Response `200 OK`**:
  ```json
  { "success": true, "message": "Quest deleted successfully" }
  ```

##### 6. `PATCH /quests/custom/:id/complete` — Complete Custom Quest
* **Server Logic**: 
  - Marks quest as completed for the current date.
  - Automatically credits `quest.xp` to the user's `balanceXp` and `totalEarnXp`.
  - Enforces daily cap so users cannot exploit unlimited XP.
* **Response `200 OK`**: Returns updated quest and new user XP total.

---

## 3. Priority 2: Recurring Medication Scheduling

### Current State
* App currently uses:
  * `POST /medication-schedule` (`name`, `type`, `doseMg`, `scheduleTime`)
  * `PATCH /medication-schedule/:id/taken?isTaken=true`
  * `GET /medication/history`
* **Limitations**:
  - `scheduleTime` is a single string with no recurrence fields.
  - No way to edit, pause, or delete a medication schedule.
  - No recurrence generation for upcoming days/weeks.

### Requirements

#### Updated Schema: `MedicationSchedule`
```typescript
{
  id: string;
  userId: string;
  name: string;            // e.g. "Semaglutide" or "Vitamin D"
  type: "TABLET" | "CAPSULE" | "INJECTION" | "LIQUID";
  doseMg: number;
  scheduleTime: string;    // HH:mm time of day
  recurrence: "ONCE" | "DAILY" | "WEEKLY" | "SPECIFIC_DAYS" | "CUSTOM";
  daysOfWeek?: number[];   // [1..7] (e.g., [1] for weekly on Monday)
  startDate: string;       // ISO Date
  endDate?: string;        // Optional ISO Date
  reminderEnabled: boolean;
  isPaused: boolean;       // Default: false
  isTaken: boolean;        // Today's status
  createdAt: string;
  updatedAt: string;
}
```

#### Required Endpoints
1. **`POST /medication-schedule` (Update)**:
   - Accept recurrence fields: `recurrence`, `daysOfWeek`, `reminderEnabled`.
2. **`PATCH /medication-schedule/:id` (New)**:
   - Allow editing `name`, `type`, `doseMg`, `scheduleTime`, `recurrence`, `daysOfWeek`.
3. **`PATCH /medication-schedule/:id/pause` (New)**:
   - Toggle `isPaused: true | false`.
4. **`DELETE /medication-schedule/:id` (New)**:
   - Hard or soft delete the schedule and cancel future instances.
5. **Feed into `todaySchedules` in `GET /profile`**:
   - The backend `GET /profile` endpoint currently returns `todaySchedules.combined`.
   - Ensure that recurring medication scheduled for the current day automatically appears in `todaySchedules` as `type: "medication"`.

---

## 4. Priority 3: Recurring Exercise Scheduling

### Current State
* App currently uses:
  * `POST /exercise-log/schedule` (`type`, `name`, `intensity`, `duration`, `note`, `scheduledAt`)
  * `PATCH /exercise-log/:id/taken?isTaken=true`
  * `GET /exercise-log/history`
* **Limitations**:
  - Only stores a single timestamp `scheduledAt`.
  - No recurrence fields (`repeatType`, `daysOfWeek`).
  - Missing Edit, Pause, and Delete endpoints.

### Requirements

#### Updated Schema: `ExerciseSchedule`
```typescript
{
  id: string;
  userId: string;
  name: string;
  type: string;            // "CARDIO", "STRENGTH", "FLEXIBILITY", etc.
  intensity: "LOW" | "MODERATE" | "HIGH";
  duration: number;        // Minutes
  note?: string;
  timeOfDay?: string;      // HH:mm
  recurrence: "NEVER" | "DAILY" | "WEEKLY" | "SPECIFIC_DAYS" | "CUSTOM";
  daysOfWeek?: number[];   // [1..7]
  isPaused: boolean;
  isTaken: boolean;        // Today's status
  scheduledAt: string;
  createdAt: string;
}
```

#### Required Endpoints
1. **`POST /exercise-log/schedule` (Update)**:
   - Accept `recurrence` and `daysOfWeek`.
2. **`PATCH /exercise-log/schedule/:id` (New)**:
   - Edit scheduled exercise details.
3. **`PATCH /exercise-log/schedule/:id/pause` (New)**:
   - Pause or resume recurring schedule.
4. **`DELETE /exercise-log/schedule/:id` (New)**:
   - Delete scheduled workout.
5. **Feed into `todaySchedules` in `GET /profile`**:
   - Ensure recurring exercise scheduled for today surfaces automatically in `todaySchedules` with `type: "exercise"`.

---

## 5. Priority 4: XP Award Timing & Anti-Abuse Fix

### Problem
In the current implementation:
* When a user calls `POST /meal-schedule`, the backend response returns `earnedXp: 10` and immediately increments the user's `balanceXp`.
* When a user calls `POST /exercise-log/schedule`, XP is awarded immediately on schedule creation.

### Required Change
* **Do NOT award XP merely for scheduling.** Creating a schedule should return `earnedXp: 0` and leave user XP balance unchanged.
* **Award XP ONLY upon completion confirmation**:
  - `PATCH /meal-schedule/:id/taken?isTaken=true` &rarr; Award +10 XP.
  - `PATCH /exercise-log/:id/taken?isTaken=true` &rarr; Award +10 XP.
  - `PATCH /medication-schedule/:id/taken?isTaken=true` &rarr; Award +10 XP (only once per schedule instance).
* Ensure that completing a task via Today's Quests or the feature screen triggers the same `PATCH .../taken` endpoint so XP is **never awarded twice**.

---

## 6. Priority 5: Independent Daily Calorie Goal

### Problem
* Endpoint `POST /macro-goal` only accepts:
  ```json
  { "carbs": 150, "protein": 120, "fat": 50 }
  ```
* The backend automatically calculates:
  $$\text{Calories} = (\text{carbs} \times 4) + (\text{protein} \times 4) + (\text{fat} \times 9)$$
  and overwrites the calorie value.
* The V1 Specification explicitly states:
  > *"Allow the user to manually set a Daily Calorie Goal in kcal. Allow independent manual goals for Protein (g), Carbohydrates (g), and Fat (g). Do not automatically overwrite the user’s calorie target based on the macro values they enter."*

### Required Change
1. Update `POST /macro-goal` to accept an optional `calories` integer:
   ```json
   {
     "carbs": 150,
     "protein": 120,
     "fat": 50,
     "calories": 2000
   }
   ```
2. **Server Logic**:
   - If `calories` is explicitly supplied, store that exact integer in the database.
   - Only fallback to `(4*P + 4*C + 9*F)` if `calories` is omitted or `null`.
3. Return the saved `calories` in:
   - `POST /macro-goal` response
   - `GET /macro-goal` response
   - `GET /profile` response (`dailyCalories`)
   - `GET /meal-log/history` response (`dailyCalories`)

---

## 7. Priority 6: Profile & Onboarding Schema Updates

### 1. Gender Selection ("Prefer not to say")
* The onboarding flow is adding a 4th option: `"Prefer not to say"`.
* If the backend user profile schema uses an enum validator (e.g. `enum: ['MALE', 'FEMALE', 'OTHER']`), please update it to:
  ```typescript
  enum Gender {
    MALE = 'MALE',
    FEMALE = 'FEMALE',
    OTHER = 'OTHER',
    PREFER_NOT_TO_SAY = 'PREFER_NOT_TO_SAY'
  }
  ```
* Alternatively, allow `gender` to be nullable or an open string.

### 2. Database Theme Seeds (Optional / Cosmetic)
* Themes are being rebranded:
  * `"Reader"` &rarr; `"Scribe"`
  * `"Gamer"` &rarr; `"Realmwalker"`
* The mobile app will support both names for backwards compatibility, but please update the theme titles in the database seed collections (`themes` collection) so that `GET /themes/my-themes` returns:
  * Name: `"Scribe"` (tagline: scroll, quill, inkpot / metallic silver)
  * Name: `"Realmwalker"` (tagline: magical portal, rune gaming controller)

---

## 8. Backend Endpoints & Changes Checklist

| # | Endpoint | Method | Change Type | Description |
| :--- | :--- | :---: | :---: | :--- |
| 1 | `/quests/custom` | `POST` | **NEW** | Create custom quest with recurrence and reminder settings |
| 2 | `/quests/custom` | `GET` | **NEW** | Fetch active custom quests for authenticated user |
| 3 | `/quests/custom/:id` | `PATCH` | **NEW** | Edit custom quest fields |
| 4 | `/quests/custom/:id/pause` | `PATCH` | **NEW** | Pause or unpause a recurring custom quest |
| 5 | `/quests/custom/:id` | `DELETE` | **NEW** | Delete custom quest |
| 6 | `/quests/custom/:id/complete` | `PATCH` | **NEW** | Complete custom quest and award capped XP |
| 7 | `/medication-schedule` | `POST` | **UPDATE** | Accept recurrence fields (`recurrence`, `daysOfWeek`) |
| 8 | `/medication-schedule/:id` | `PATCH` | **NEW** | Edit medication schedule |
| 9 | `/medication-schedule/:id/pause` | `PATCH` | **NEW** | Pause / resume medication schedule |
| 10 | `/medication-schedule/:id` | `DELETE` | **NEW** | Delete medication schedule |
| 11 | `/exercise-log/schedule` | `POST` | **UPDATE** | Accept recurrence fields (`recurrence`, `daysOfWeek`). **Do not award XP on scheduling.** |
| 12 | `/exercise-log/schedule/:id` | `PATCH` | **NEW** | Edit scheduled workout |
| 13 | `/exercise-log/schedule/:id/pause`| `PATCH` | **NEW** | Pause / resume workout schedule |
| 14 | `/exercise-log/schedule/:id` | `DELETE` | **NEW** | Delete scheduled workout |
| 15 | `/meal-schedule` | `POST` | **UPDATE** | **Do not award XP on scheduling.** Award XP only when marked taken. |
| 16 | `/macro-goal` | `POST` | **UPDATE** | Accept and store independent manual `calories` goal. |
| 17 | `/auth/profile` / `/user-info` | `PATCH` | **UPDATE** | Allow `gender: 'PREFER_NOT_TO_SAY'`. |
| 18 | `/themes` (DB seeds) | - | **DATA** | Update theme names from Reader &rarr; Scribe, Gamer &rarr; Realmwalker. |

---

*Generated for the Velvet & Iron engineering team to facilitate seamless coordination between Frontend & Backend developers for the V1 release.*
