# Velvet & Iron Backend API Documentation: Complete Feature Integration Guide

**Base URL:** `https://velvet.api.softvence.app`  
**Authentication:** `Authorization: Bearer <JWT_ACCESS_TOKEN>`  
**Global Header Recommendation:** `x-timezone: <IANA_TIMEZONE>` (e.g. `x-timezone: America/Chicago`)  
**Target Audience:** Frontend Mobile (Flutter) & Web Engineering Teams  
**Last Updated:** October 26, 2026 (Includes Client Feedback 16 Updates)

---

## Global Integration Standards & Rules

### 1. Timezone Ingestion
* **Global HTTP Interceptor (Recommended):** Add `x-timezone: <User_IANA_Timezone>` (e.g., `x-timezone: America/Chicago` or `Intl.DateTimeFormat().resolvedOptions().timeZone`) to every outgoing request.
* **Per-Route Query Parameter:** All endpoints support `?timezone=<IANA_TIMEZONE>`. If both are provided, the query parameter takes precedence.
* **Fallback Priority:** If neither header nor query param is supplied, the backend falls back to the user's saved database profile timezone, and finally to `America/Chicago`.

### 2. Date Query Parameters
* Always format date query parameters strictly as `YYYY-MM-DD` strings (e.g. `?date=2026-10-26`). Never pass full ISO strings or raw UTC timestamps in `date` queries.

### 3. Response Standard
* All dates in API responses are ISO 8601 strings in UTC (`YYYY-MM-DDTHH:mm:ss.sssZ`).
* Flags indicating daily completion (`isDone`, `isCompleted`, `isTaken`) are strict booleans (`true` or `false`).

---

## Feature Domain 1: Mood Tracking & Daily "Attunement of Spirit" Quest

### 1.1 Route: Log Today's Mood
* **Method & Path:** `POST /mood-log`
* **Why It is Used:** Records or updates the user's current mood, energy level, hunger level, and optional personal notes for their local calendar day. On the first log of each local day, it awards `+30 XP` and marks the daily **"Attunement of Spirit"** (`mood-check`) quest as completed. Deduplication is strictly scoped to the user's local calendar day; subsequent submissions on the same local date update the existing entry and advance the timestamp to the moment of update.

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `mood` | `string` | **Yes** | User's emotional state enum | `'TIRED'`, `'GOOD'`, `'PISSED'`, `'GREAT'`, `'POOR'` |
| `energyLevel` | `string` | No | Current energy level enum | `'EXHAUSTED'`, `'LOW'`, `'MODERATE'`, `'ENERGIZED'`, `'HIGH'` |
| `hungerLevel` | `string` | No | Hunger level enum | `'NOT_HUNGRY'`, `'HUNGRY'`, `'VERY_HUNGRY'` |
| `note` | `string` | No | Freeform user thoughts | `'Feeling motivated after morning run'` |
| `loggedAt` | `string` (ISO 8601) | No | Optional explicit timestamp | Defaults to current submission time |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/mood-log" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "mood": "GOOD",
    "energyLevel": "MODERATE",
    "hungerLevel": "HUNGRY",
    "note": "Feeling energized and focused"
  }'
```

#### Sample Success Response (`201 Created` or `200 OK`)
```json
{
  "id": "e9329e71-46ab-4712-8921-9d82136e01a4",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "mood": "GOOD",
  "energyLevel": "MODERATE",
  "hungerLevel": "HUNGRY",
  "note": "Feeling energized and focused",
  "earnedXp": 30,
  "loggedAt": "2026-10-26T13:20:00.000Z"
}
```

---

### 1.2 Route: Fetch Mood History & Streaks
* **Method & Path:** `GET /mood-log/history`
* **Why It is Used:** Returns user's historical mood logs and current streak calculations, mapped strictly to local calendar dates in the user's timezone.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/mood-log/history" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "success": true,
  "data": [
    {
      "id": "e9329e71-46ab-4712-8921-9d82136e01a4",
      "mood": "GOOD",
      "energyLevel": "MODERATE",
      "hungerLevel": "HUNGRY",
      "note": "Feeling energized and focused",
      "earnedXp": 30,
      "loggedAt": "2026-10-26T13:20:00.000Z",
      "date": "2026-10-26"
    }
  ],
  "meta": {
    "totalLogs": 1,
    "currentStreak": 1
  }
}
```

---

## Feature Domain 2: Recurring Scheduled Activities ("Specific Days" Reappearance)

### 2.1 Route: Create Recurring Workout Schedule
* **Method & Path:** `POST /exercise-logs/schedule`
* **Why It is Used:** Schedules a recurring workout routine. When `recurrence` is set to `SPECIFIC_DAYS` (or `WEEKLY`), the activity automatically reappears on all specified weekdays, resets cleanly at local midnight, and maintains separate daily completion states.

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `name` | `string` | **Yes** | Workout title | `'Walk the Realm'`, `'Upper Body Push'` |
| `type` | `string` | **Yes** | Exercise category enum | `'CARDIO'`, `'STRENGTH'`, `'FLEXIBILITY'`, `'BALANCE'` |
| `duration` | `number` | No | Estimated duration in minutes | `30`, `45`, `60` |
| `intensity` | `string` | No | Workout intensity level | `'LOW'`, `'MEDIUM'`, `'HIGH'` |
| `recurrence` | `string` | No | Frequency pattern | `'DAILY'`, `'SPECIFIC_DAYS'`, `'WEEKLY'`, `'NEVER'` |
| `daysOfWeek` (or `repeatDays`) | `number[]` \| `string[]` | Required if `SPECIFIC_DAYS` | Selected weekdays (1=Mon ... 7=Sun) | `[1, 3, 5]` or `["MONDAY", "WEDNESDAY", "FRIDAY"]` |
| `timeOfDay` | `string` | No | Scheduled time in 24-hr `HH:mm` format | `'07:30'`, `'18:00'` |
| `scheduledAt` | `string` (ISO 8601) | No | Start date/time anchor | `'2026-10-26T07:30:00.000Z'` |
| `reminderEnabled` | `boolean` | No | Push notification trigger flag | `true` or `false` |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/exercise-logs/schedule" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "name": "Walk the Realm",
    "type": "CARDIO",
    "duration": 30,
    "intensity": "MEDIUM",
    "recurrence": "SPECIFIC_DAYS",
    "daysOfWeek": [1, 3, 5],
    "timeOfDay": "07:30",
    "reminderEnabled": true
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "c1f72863-7928-40a2-b2d9-1b3d5b78f910",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "name": "Walk the Realm",
  "type": "CARDIO",
  "duration": 30,
  "intensity": "MEDIUM",
  "recurrence": "SPECIFIC_DAYS",
  "daysOfWeek": [1, 3, 5],
  "timeOfDay": "07:30",
  "reminderEnabled": true,
  "isTaken": false,
  "isPaused": false,
  "createdAt": "2026-10-26T07:30:00.000Z"
}
```

---

### 2.2 Route: Query Today's Exercise Schedules
* **Method & Path:** `GET /exercise-logs/schedule/today`
* **Why It is Used:** Returns scheduled workouts eligible for the target local calendar date. On non-scheduled days (e.g. Tuesday for a Mon/Wed/Fri schedule), the activity is cleanly excluded. On scheduled days (Monday and Wednesday), it appears with `isTaken: false` and resets automatically at local midnight.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`). Defaults to user today. |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/exercise-logs/schedule/today?date=2026-10-26" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
[
  {
    "id": "c1f72863-7928-40a2-b2d9-1b3d5b78f910",
    "name": "Walk the Realm",
    "type": "CARDIO",
    "duration": 30,
    "intensity": "MEDIUM",
    "timeOfDay": "07:30",
    "recurrence": "SPECIFIC_DAYS",
    "daysOfWeek": [1, 3, 5],
    "isTaken": false,
    "isPaused": false
  }
]
```

---

### 2.3 Route: Mark Scheduled Exercise Taken / Untaken
* **Method & Path:** `PATCH /exercise-logs/schedules/:id/mark-taken`
* **Why It is Used:** Toggles completion status for a specific scheduled activity. Writes to the date-scoped `schedule_completions` table for the user's local calendar day. Once marked taken on Monday, it stays taken on Monday and does NOT leak into Wednesday.

#### Query & Body Parameters
* **URL Param:** `id` (string, required): Master schedule ID.
* **Query Param:** `date` (string, optional): Target local calendar date (`YYYY-MM-DD`).

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values |
|---|---|:---:|---|---|
| `isTaken` | `boolean` | **Yes** | Completion toggle state | `true` or `false` |
| `dateStr` | `string` | No | Target local calendar date (`YYYY-MM-DD`) | `'2026-10-26'` |

#### Sample cURL Request
```bash
curl -X PATCH "https://velvet.api.softvence.app/exercise-logs/schedules/c1f72863-7928-40a2-b2d9-1b3d5b78f910/mark-taken" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "isTaken": true,
    "dateStr": "2026-10-26"
  }'
```

#### Sample Success Response (`200 OK`)
```json
{
  "id": "c1f72863-7928-40a2-b2d9-1b3d5b78f910",
  "name": "Walk the Realm",
  "isTaken": true,
  "date": "2026-10-26",
  "earnedXp": 10
}
```

---

## Feature Domain 3: Specific-Day Custom Quests & Date-Scoped Completions

### 3.1 Route: Create Custom Quest
* **Method & Path:** `POST /custom-quest` (Supported Aliases: `/quests/custom`, `/custom-quests`)
* **Why It is Used:** Creates a recurring or one-off custom habit/quest. Weekday parameters (`daysOfWeek` / `repeatDays`) accept integer arrays `[1, 3, 5]`, string arrays `["1", "3", "5"]`, or day names `["MONDAY", "WEDNESDAY", "FRIDAY"]`, automatically normalized to ISO weekday numbers `1..7`. XP is capped between 1 and 15 XP (defaults to 10 XP).

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `title` (or `name`) | `string` | **Yes** | Quest title (3–60 chars) | `'Gym Strength Session'`, `'Study Italian'` |
| `category` | `string` | No | Category | `'FITNESS'`, `'NUTRITION'`, `'MINDFULNESS'`, `'GENERAL'` |
| `description` | `string` | No | Quest details | `'Legs & Core workout routine'` |
| `recurrence` (or `frequency`)| `string` | No | Recurrence mode | `'DAILY'`, `'SPECIFIC_DAYS'`, `'WEEKLY'`, `'NONE'` |
| `daysOfWeek` (or `repeatDays`)| `number[]` \| `string[]` | Required if `SPECIFIC_DAYS` | Weekdays (1=Mon ... 7=Sun) | `[1, 3, 5]` or `["MONDAY", "WEDNESDAY", "FRIDAY"]` |
| `scheduledTime` | `string` | No | Scheduled time in 24-hr `HH:mm` | `'07:30'` |
| `reminderEnabled` | `boolean` | No | Reminder trigger flag | `true` or `false` |
| `reminderTime` | `string` | No | Reminder time in `HH:mm` | `'07:15'` |
| `xpReward` (or `xp`) | `number` | No | Custom XP reward | Clamped between 1 and 15 (Default: `10`) |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/custom-quest" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "title": "Gym Strength Session",
    "category": "FITNESS",
    "description": "Legs & Core workout routine",
    "recurrence": "SPECIFIC_DAYS",
    "daysOfWeek": [1, 3, 5],
    "scheduledTime": "07:30",
    "reminderEnabled": true,
    "xpReward": 10
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "success": true,
  "data": {
    "id": "58dbf014-37b0-47dc-9228-99308c8fce63",
    "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
    "title": "Gym Strength Session",
    "name": "Gym Strength Session",
    "category": "FITNESS",
    "description": "Legs & Core workout routine",
    "scheduledTime": "07:30",
    "frequency": "SPECIFIC_DAYS",
    "recurrence": "SPECIFIC_DAYS",
    "daysOfWeek": [1, 3, 5],
    "reminderEnabled": true,
    "isCompleted": false,
    "isDone": false,
    "completedAt": null,
    "isPaused": false,
    "xpReward": 10,
    "xp": 10,
    "isCustom": true,
    "createdAt": "2026-10-26T07:30:00.000Z"
  }
}
```

---

### 3.2 Route: Query Custom Quests for Specific Date
* **Method & Path:** `GET /custom-quest` (Supported Aliases: `/quests/custom`, `/custom-quests`)
* **Why It is Used:** Queries custom quests active on a target calendar date.
  * **Daily Feed Mode (Default):** On scheduled days (e.g. Wednesday), returns the quest with `isCompleted: false`. On non-scheduled days (e.g. Tuesday), the quest is excluded.
  * **Management Mode (`?all=true`):** Returns all custom quests regardless of scheduled weekday so users can manage or edit them anytime.
  * **History Preservation:** Completing the quest on Wednesday does NOT erase Monday's completion; querying Monday (`?date=2026-10-26`) continues to return `isCompleted: true`.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`). Defaults to user today. |
| `all` (or `includeAll`) | `boolean` | No | If `true`, returns all quests regardless of scheduled weekday (for management screens). |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request (Daily Feed)
```bash
curl -X GET "https://velvet.api.softvence.app/custom-quest?date=2026-10-28" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "success": true,
  "data": [
    {
      "id": "58dbf014-37b0-47dc-9228-99308c8fce63",
      "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
      "title": "Gym Strength Session",
      "category": "FITNESS",
      "recurrence": "SPECIFIC_DAYS",
      "daysOfWeek": [1, 3, 5],
      "isCompleted": false,
      "isDone": false,
      "completedAt": null,
      "xpReward": 10,
      "isCustom": true
    }
  ],
  "meta": {
    "todayCustomXpEarned": 0,
    "dailyCustomXpCap": 50
  }
}
```

---

### 3.3 Route: Mark Custom Quest Complete
* **Method & Path:** `POST /custom-quest/:id/complete` (Supported Aliases: `PATCH /custom-quest/:id/complete`, `POST /quests/custom/:id/complete`)
* **Why It is Used:** Marks a custom quest as complete for the target local calendar date. Persists the completion record in `schedule_completions` (`scheduleType: 'CUSTOM_QUEST'`), awards XP (subject to the 50 XP/day custom quest cap), and preserves past completion history.

#### Query & Body Parameters
* **URL Param:** `id` (string, required): Custom quest UUID.
* **Query Param:** `date` (string, optional): Target local calendar date (`YYYY-MM-DD`).
* **Body Param:** `dateStr` (string, optional): Target local calendar date (`YYYY-MM-DD`).

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/custom-quest/58dbf014-37b0-47dc-9228-99308c8fce63/complete?date=2026-10-28" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "success": true,
  "data": {
    "id": "58dbf014-37b0-47dc-9228-99308c8fce63",
    "isCompleted": true,
    "xpAwarded": 10,
    "companionTotalXp": 240,
    "companionLevel": 3
  },
  "quest": {
    "id": "58dbf014-37b0-47dc-9228-99308c8fce63",
    "title": "Gym Strength Session",
    "isCompleted": true,
    "isDone": true,
    "xpReward": 10
  },
  "earnedXp": 10,
  "newBalanceXp": 240
}
```

---

## Feature Domain 4: Nutrition, Meal Logging & Localized Macro Goals

### 4.1 Route: Log Meal Entry
* **Method & Path:** `POST /meal-log`
* **Why It is Used:** Logs consumed food, calories, and macronutrients. Automatically attributes entries to the user's local calendar day (e.g., late dinners logged at 9:17 PM CDT on Monday remain in Monday's totals and do NOT bleed into Tuesday).

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `mealType` | `string` | **Yes** | Meal slot enum | `'BREAKFAST'`, `'LUNCH'`, `'DINNER'`, `'SNACK'` |
| `description` | `string` | No | Food description | `'Grilled chicken salad with quinoa'` |
| `calories` | `number` | No | Energy content (kcal) | `450` |
| `protein` | `number` | No | Protein content (g) | `45` |
| `carbs` | `number` | No | Carbohydrate content (g) | `30` |
| `fats` | `number` | No | Fat content (g) | `12` |
| `loggedAt` | `string` (ISO 8601) | No | Custom timestamp | Defaults to current submission time |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/meal-log" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "mealType": "DINNER",
    "description": "Grilled Salmon and Steamed Vegetables",
    "calories": 520,
    "protein": 42,
    "carbs": 18,
    "fats": 22
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "78a2e5d9-31bc-4c07-926f-1246d88f91a2",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "mealType": "DINNER",
  "calories": 520,
  "protein": 42,
  "carbs": 18,
  "fats": 22,
  "earnedXp": 10,
  "loggedAt": "2026-10-26T20:15:00.000Z"
}
```

---

### 4.2 Route: Daily Nutrition Dashboard & Calorie Aggregates
* **Method & Path:** `GET /profile/stats`
* **Why It is Used:** Returns daily consumed vs target nutrition totals. Local midnight resets guarantee that yesterday's calories and macros are cleared from today's dashboard.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`). Defaults to user today. |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/profile/stats?date=2026-10-26" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "date": "2026-10-26",
  "calorieGoal": 2000,
  "consumedCalories": 520,
  "remainingCalories": 1480,
  "consumedMacros": {
    "protein": 42,
    "carbs": 18,
    "fats": 22
  },
  "macroGoals": {
    "proteinGoal": 150,
    "carbsGoal": 200,
    "fatsGoal": 60
  },
  "weeklyPresent": {
    "monday": true,
    "tuesday": false,
    "wednesday": false,
    "thursday": false,
    "friday": false,
    "saturday": false,
    "sunday": false
  }
}
```

---

## Feature Domain 5: Weight Logging & Rollover

### 5.1 Route: Log Daily Weight
* **Method & Path:** `POST /weight-log`
* **Why It is Used:** Logs body weight. Submissions recorded late in the evening (e.g. 9:00 PM CDT) are attributed to that specific calendar day rather than rolling over prematurely to the next day.

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `weight` | `string` \| `number` | **Yes** | Measured body weight | `'182.4'` or `182.4` |
| `note` | `string` | No | Optional weigh-in note | `'Morning fasted weight'` |
| `loggedAt` | `string` (ISO 8601) | No | Weigh-in timestamp | Defaults to current time |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/weight-log" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "weight": "182.4",
    "note": "Morning fasted weigh-in"
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "99b03912-32a1-43ee-9df7-28562719a8f4",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "weight": "182.4",
  "note": "Morning fasted weigh-in",
  "earnedXp": 10,
  "loggedAt": "2026-10-26T14:30:00.000Z"
}
```

---

## Feature Domain 6: Step Tracking, Expedition Milestones & Camp Setup

### 6.1 Route: Sync Steps & "Set Up Camp"
* **Method & Path:** `POST /step-logs`
* **Why It is Used:** Commits daily pedometer steps and claims expedition milestones ("Set Up Camp"). Awards `+50 XP` when the daily step goal (8,000 steps) is achieved. Deduplication ensures that step commits are attributed strictly to the user's local calendar day.

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `steps` | `number` | **Yes** | Total steps accumulated for the day | `8500` |
| `goal` | `number` | No | Step target (defaults to `8000`) | `8000`, `10000` |
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`) | `'2026-10-26'` |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/step-logs" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "steps": 8500,
    "goal": 8000,
    "date": "2026-10-26"
  }'
```

#### Sample Success Response (`201 Created` or `200 OK`)
```json
{
  "id": "e3089401-447a-4ecf-96a8-bf2904576182",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "steps": 8500,
  "goal": 8000,
  "isGoalReached": true,
  "campPitched": true,
  "earnedXp": 50,
  "date": "2026-10-26"
}
```

---

## Feature Domain 7: Companion Dialogue & Contextual Interaction

### 7.1 Route: Fetch Contextual Companion Dialogue
* **Method & Path:** `GET /companion/dialogue`
* **Why It is Used:** Fetches context-aware dialogue from the user's active companion. Evaluates time-of-day greetings (Morning, Afternoon, Evening, Night) using the user's local clock in `x-timezone` rather than server UTC time.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/companion/dialogue" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "companionId": "481a5392-4911-4770-b8c1-193498829377",
  "name": "Ignis",
  "dialogue": "Good afternoon, Champion! Half the day remains—let us seize our goals.",
  "timeOfDay": "AFTERNOON",
  "streakStatus": "ACTIVE",
  "currentStreak": 5
}
```

---

## Feature Domain 8: GLP-1 Weekly Schedule Isolation & Codex Evaluation

### 8.1 Clinical Overview & Quest Architecture
* **The Problem:** GLP-1 medications (e.g., Semaglutide, Tirzepatide, Ozempic, Mounjaro, Zepbound) are administered **strictly once per week** (e.g., Sunday). Previously, "Track Your Shot" ("Elixir of the Alchemist") appeared every single day, making 100% daily quest completion impossible for users on the other 6 days of the week.
* **The Solution:**
  1. **Non-Injection Weekdays:** When a user has a weekly GLP-1 schedule for Sunday, `track-your-shot` is **omitted** Monday through Saturday. The user receives 5 daily quests and can complete 5/5 (100%) daily streak without being penalized.
  2. **Injection Day (e.g. Sunday):** `track-your-shot` appears in the quest list and can be completed for `+10 XP`.
  3. **Zero Card Duplication:** If the user already has a specific scheduled injection item (`med_<id>`) in their feed, the redundant generic `codex_track-your-shot` card is omitted.
  4. **Checkbox Completion:** Completing `codex_track-your-shot` via `POST /quests/complete` automatically marks the user's scheduled injection as taken.

---

### 8.2 Route: Create Weekly GLP-1 Medication Schedule
* **Method & Path:** `POST /medication-schedule`
* **Why It is Used:** Schedules a weekly GLP-1 injection for a specific day of the week (e.g., Sunday).

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `name` | `string` | **Yes** | Medication name | `'Tirzepatide GLP-1'`, `'Semaglutide Weekly'` |
| `type` | `string` | **Yes** | Medication form | `'INJECTION'`, `'CAPSULE'`, `'TABLET'`, `'LIQUID'` |
| `doseMg` | `number` | No | Dosage in milligrams | `5`, `2.5`, `0.5` |
| `scheduleTime` | `string` (ISO 8601) | **Yes** | Anchor date and injection time | `'2026-11-01T09:00:00.000Z'` |
| `recurrence` | `string` | No | Recurrence pattern | `'WEEKLY'`, `'SPECIFIC_DAYS'`, `'DAILY'`, `'ONCE'` |
| `daysOfWeek` | `number[]` \| `string[]` | Required if `WEEKLY` | Injection weekday (7 = Sunday) | `[7]` or `["SUNDAY"]` |
| `reminderEnabled` | `boolean` | No | Push notification trigger flag | `true` or `false` |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/medication-schedule" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "name": "Tirzepatide GLP-1",
    "type": "INJECTION",
    "doseMg": 5,
    "scheduleTime": "2026-11-01T09:00:00.000Z",
    "recurrence": "WEEKLY",
    "daysOfWeek": [7],
    "reminderEnabled": true
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "18f921a8-7711-4fa3-9a11-82991047192a",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "name": "Tirzepatide GLP-1",
  "type": "INJECTION",
  "doseMg": 5,
  "recurrence": "WEEKLY",
  "daysOfWeek": [7],
  "isTaken": false,
  "isPaused": false,
  "createdAt": "2026-10-26T14:00:00.000Z"
}
```

---

### 8.3 Route: Unified Quests Feed (Injection Day vs Non-Injection Day)
* **Method & Path:** `GET /quests/today`
* **Why It is Used:** Returns the unified list of Codex quests, Custom quests, and Scheduled activities.
  * **On Non-Injection Days (Monday–Saturday):** Returns 5 Codex quests (`three-meals`, `mood-check`, `step-master`, `protein-power`, `mana-infusion`). `track-your-shot` is omitted!
  * **On Injection Day (Sunday):** Displays the scheduled GLP-1 injection card (`med_<id>`) with `isCompleted: false`.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`). Defaults to user today. |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request (Tuesday — Non-Injection Day)
```bash
curl -X GET "https://velvet.api.softvence.app/quests/today?date=2026-10-27" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Response on Tuesday (`200 OK` — `track-your-shot` omitted)
```json
{
  "success": true,
  "data": [
    {
      "id": "codex_three-meals",
      "title": "Three Meals a Day",
      "description": "Log breakfast, lunch, and dinner",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "CODEX",
      "originalRefId": "three-meals"
    },
    {
      "id": "codex_mood-check",
      "title": "Mood Check",
      "description": "Log your mood and energy levels",
      "xpReward": 30,
      "isCompleted": false,
      "questType": "CODEX",
      "originalRefId": "mood-check"
    },
    {
      "id": "codex_step-master",
      "title": "Step Master",
      "description": "Complete your daily step goal or walk at least 8,000 steps",
      "xpReward": 50,
      "isCompleted": false,
      "questType": "CODEX",
      "originalRefId": "step-master"
    },
    {
      "id": "codex_protein-power",
      "title": "Titan's Nourishment",
      "description": "Log a meal with 30g+ protein",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "CODEX",
      "originalRefId": "protein-power"
    },
    {
      "id": "codex_mana-infusion",
      "title": "Mana Infusion",
      "description": "Drink at least 80% of your daily water potion goal",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "CODEX",
      "originalRefId": "mana-infusion"
    }
  ],
  "meta": {
    "totalQuests": 5,
    "completedQuests": 0
  }
}
```

#### Sample Response on Sunday (`200 OK` — Injection Day)
```json
{
  "success": true,
  "data": [
    {
      "id": "med_18f921a8-7711-4fa3-9a11-82991047192a",
      "title": "Tirzepatide GLP-1",
      "description": "INJECTION • 5mg",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "MEDICATION_SCHEDULE",
      "originalRefId": "18f921a8-7711-4fa3-9a11-82991047192a"
    },
    {
      "id": "codex_three-meals",
      "title": "Three Meals a Day",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "CODEX"
    },
    {
      "id": "codex_mood-check",
      "title": "Mood Check",
      "xpReward": 30,
      "isCompleted": false,
      "questType": "CODEX"
    },
    {
      "id": "codex_step-master",
      "title": "Step Master",
      "xpReward": 50,
      "isCompleted": false,
      "questType": "CODEX"
    },
    {
      "id": "codex_protein-power",
      "title": "Titan's Nourishment",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "CODEX"
    },
    {
      "id": "codex_mana-infusion",
      "title": "Mana Infusion",
      "xpReward": 10,
      "isCompleted": false,
      "questType": "CODEX"
    }
  ],
  "meta": {
    "totalQuests": 6,
    "completedQuests": 0
  }
}
```

---

### 8.4 Route: Complete Quest via Unified Feed Checkbox
* **Method & Path:** `POST /quests/complete` (Supported Aliases: `POST /quests/today/complete`, `POST /quests/:id/complete`)
* **Why It is Used:** Universal endpoint called when the user taps a quest checkbox in the daily feed. Supports Custom Quests, Workout Schedules, Medication Schedules, and the GLP-1 injection quest seamlessly.

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `questId` | `string` | **Yes** | Item identifier (with or without prefix) | `'med_18f921a8-...'`, `'custom_58dbf014-...'`, `'workout_c1f72863-...'` |
| `questType` | `string` | No | Optional explicit quest type | `'CUSTOM'`, `'MEDICATION_SCHEDULE'`, `'WORKOUT_SCHEDULE'` |
| `dateStr` | `string` | No | Target local calendar date (`YYYY-MM-DD`) | `'2026-11-01'` |

#### Sample cURL Request (Completing GLP-1 Injection on Sunday)
```bash
curl -X POST "https://velvet.api.softvence.app/quests/complete" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "questId": "med_18f921a8-7711-4fa3-9a11-82991047192a",
    "dateStr": "2026-11-01"
  }'
```

#### Sample Success Response (`200 OK`)
```json
{
  "success": true,
  "data": {
    "id": "med_18f921a8-7711-4fa3-9a11-82991047192a",
    "isCompleted": true,
    "xpAwarded": 10,
    "companionTotalXp": 250,
    "companionLevel": 3
  }
}
```
