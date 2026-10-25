# Velvet & Iron Backend API Documentation: Feature-Based Integration Guide

**Base URL:** `https://velvet.api.softvence.app`  
**Authentication:** `Authorization: Bearer <JWT_ACCESS_TOKEN>`  
**Global Header Recommendation:** `x-timezone: <IANA_TIMEZONE>` (e.g. `x-timezone: America/Chicago`)  
**Target Audience:** Frontend Mobile & Web Engineering Teams  

---

## Global Integration Standards & Rules

### 1. Timezone Ingestion
* **Global HTTP Interceptor (Recommended):** Add `x-timezone: <User_IANA_Timezone>` (e.g., `x-timezone: America/Chicago` or `Intl.DateTimeFormat().resolvedOptions().timeZone`) to every outgoing request.
* **Per-Route Query Parameter:** All endpoints also support `?timezone=<IANA_TIMEZONE>`. If both are provided, the query parameter takes precedence.
* **Fallback Priority:** If neither header nor query param is supplied, the backend falls back to the user's saved database profile timezone, and finally to `America/Chicago`.

### 2. Date Query Parameters
* Always format date query parameters strictly as `YYYY-MM-DD` strings (e.g. `?date=2026-10-20`). Never pass full ISO strings or raw UTC timestamps in `date` queries.

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
  "loggedAt": "2026-10-20T18:20:00.000Z",
  "createdAt": "2026-10-20T18:20:00.000Z",
  "updatedAt": "2026-10-20T18:20:00.000Z"
}
```

#### Sample Error Response (`400 Bad Request`)
```json
{
  "statusCode": 400,
  "message": "Mood is required to create a new log",
  "error": "Bad Request"
}
```

#### Frontend Instructions
* Call `POST /mood-log` when the user submits their daily check-in.
* Immediately upon receiving `200`/`201`, refresh the daily quests feed (`GET /quests/today`) so that "Attunement of Spirit" displays as completed (`isCompleted: true`).

---

### 1.2 Route: Get Mood Log History
* **Method & Path:** `GET /mood-log/history`
* **Why It is Used:** Returns paginated mood logs for the user, with the most recent mood displayed at the top. Supports filtering by a specific local calendar date.

#### Query Parameters
| Parameter | Type | Required | Default | Description |
|---|---|:---:|---|---|
| `date` | `string` | No | - | Filter logs strictly for calendar date (`YYYY-MM-DD`, e.g. `2026-10-20`) |
| `limit` | `number` | No | `30` | Number of logs to return |
| `offset` | `number` | No | `0` | Number of logs to skip |
| `timezone` | `string` | No | Header fallback | User IANA timezone (e.g. `America/Chicago`) |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/mood-log/history?date=2026-10-20&timezone=America/Chicago" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### Sample Success Response (`200 OK`)
```json
{
  "logs": [
    {
      "id": "e9329e71-46ab-4712-8921-9d82136e01a4",
      "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
      "mood": "GOOD",
      "energyLevel": "MODERATE",
      "hungerLevel": "HUNGRY",
      "note": "Feeling energized and focused",
      "earnedXp": 30,
      "loggedAt": "2026-10-20T18:20:00.000Z"
    }
  ],
  "totalCount": 1,
  "currentMood": "GOOD"
}
```

---

## Feature Domain 2: Recurring Scheduled Activities & Habits ("Specific Days" Reappearance)

### 2.1 Route: Create Recurring Exercise Schedule
* **Method & Path:** `POST /exercise-log/schedule`
* **Why It is Used:** Establishes a recurring workout activity (e.g., "Walk the Realm") on designated days of the week. The master schedule persists indefinitely; daily completions are tracked separately so that completing the activity on Monday never prevents it from reappearing on Wednesday or Friday.

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `name` | `string` | **Yes** | Schedule title | `'Walk the Realm'` |
| `type` | `string` | **Yes** | Exercise category | `'WALK'`, `'RUN'`, `'CARDIO'`, `'STRENGTH'`, `'YOGA'` |
| `recurrence` | `string` | **Yes** | Recurrence frequency | `'SPECIFIC_DAYS'`, `'DAILY'`, `'WEEKLY'`, `'ONCE'` |
| `daysOfWeek` (or `repeatDays`)| `number[]` | **Yes** (if `SPECIFIC_DAYS`) | Selected ISO weekdays | `[1, 3, 5]` (1=Monday ... 7=Sunday) |
| `duration` | `number` | No | Target duration in minutes | `30` |
| `intensity` | `string` | No | Workout intensity level | `'LOW'`, `'MODERATE'`, `'HIGH'` |
| `scheduledTime` | `string` | No | Target time of day | `'08:00'` |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/exercise-log/schedule" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "name": "Walk the Realm",
    "type": "WALK",
    "recurrence": "SPECIFIC_DAYS",
    "daysOfWeek": [1, 3, 5],
    "duration": 30,
    "intensity": "MODERATE"
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "5ccee945-c89b-4a84-baf1-49812634fd57",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "name": "Walk the Realm",
  "type": "WALK",
  "recurrence": "SPECIFIC_DAYS",
  "daysOfWeek": [1, 3, 5],
  "duration": 30,
  "intensity": "MODERATE",
  "isPaused": false,
  "createdAt": "2026-10-19T08:00:00.000Z"
}
```

---

### 2.2 Route: Get Today's Scheduled Exercises
* **Method & Path:** `GET /exercise-log/schedules/today`
* **Why It is Used:** Returns workouts scheduled for the current day. If an activity is scheduled for Monday, Wednesday, and Friday, it automatically appears on those days with `isTaken: false` and is excluded on other weekdays.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target date (`YYYY-MM-DD`). Defaults to user's local today. |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/exercise-log/schedules/today?date=2026-10-21" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
[
  {
    "id": "5ccee945-c89b-4a84-baf1-49812634fd57",
    "name": "Walk the Realm",
    "type": "WALK",
    "duration": 30,
    "intensity": "MODERATE",
    "isTaken": false,
    "loggedAt": "2026-10-19T08:00:00.000Z"
  }
]
```

---

### 2.3 Route: Complete Scheduled Activity for Specific Date
* **Method & Path:** `POST /exercise-log/schedule/:id/take` (or `POST /schedule-completion/complete`)
* **Why It is Used:** Marks a recurring workout completed for a specific calendar date and awards `+10 XP`. It records completion in `schedule_completions`, ensuring that completing Monday does not mark Wednesday or Friday as taken.

#### Route Parameters & Body
* **URL Param:** `:id` (Schedule ID string)
* **Request Body:**

| Field | Type | Required | Description | Example |
|---|---|:---:|---|---|
| `date` | `string` | No | Calendar date (`YYYY-MM-DD`). Defaults to user local today | `'2026-10-21'` |
| `scheduleType` | `string` | No | Type of schedule | `'WORKOUT'`, `'MEDICATION'`, `'MEAL'` |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/exercise-log/schedule/5ccee945-c89b-4a84-baf1-49812634fd57/take" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "date": "2026-10-21"
  }'
```

#### Sample Success Response (`200 OK`)
```json
{
  "success": true,
  "message": "Schedule marked as completed for 2026-10-21",
  "data": {
    "scheduleId": "5ccee945-c89b-4a84-baf1-49812634fd57",
    "date": "2026-10-21",
    "isCompleted": true,
    "earnedXp": 10
  }
}
```

#### Duplicate Completion Handling (`200 OK`)
If already completed for that calendar date, it idempotently returns current state without awarding duplicate XP:
```json
{
  "success": true,
  "message": "Already completed for this date",
  "data": {
    "scheduleId": "5ccee945-c89b-4a84-baf1-49812634fd57",
    "date": "2026-10-21",
    "isCompleted": true,
    "earnedXp": 0
  }
}
```

---

## Feature Domain 3: Custom Quests & Midnight Isolation ("Study Italian")

### 3.1 Route: Create Custom Quest
* **Method & Path:** `POST /custom-quest`
* **Why It is Used:** Allows users to define custom habits/quests. Automatically enforces anti-abuse guardrails: titles must be 3–60 characters, and XP rewards are clamped between 1 and 15 XP (defaults to 10 XP).

#### Route Fields & Data Types

| Field | Type | Required | Description | Allowed Values / Examples |
|---|---|:---:|---|---|
| `title` (or `name`) | `string` | **Yes** | Quest title (3–60 chars) | `'Study Italian'` |
| `category` | `string` | No | Category | `'LEARNING'`, `'FITNESS'`, `'GENERAL'`, `'HABIT'` |
| `description` | `string` | No | Quest details | `'Practice 15 minutes of vocabulary'` |
| `frequency` (or `recurrence`)| `string` | No | Frequency | `'DAILY'`, `'WEEKLY'`, `'SPECIFIC_DAYS'` |
| `daysOfWeek` (or `repeatDays`)| `number[]` | No | Weekdays (1=Mon ... 7=Sun) | `[1, 2, 3, 4, 5]` |
| `xpReward` (or `xp`) | `number` | No | Custom XP reward | Default: `10` (Clamped between 1 and 15) |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/custom-quest" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "title": "Study Italian",
    "category": "LEARNING",
    "description": "Practice Duolingo for 15 mins",
    "frequency": "DAILY",
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
    "title": "Study Italian",
    "name": "Study Italian",
    "category": "LEARNING",
    "description": "Practice Duolingo for 15 mins",
    "frequency": "DAILY",
    "recurrence": "DAILY",
    "isCompleted": false,
    "isDone": false,
    "completedAt": null,
    "isPaused": false,
    "xpReward": 10,
    "xp": 10,
    "isCustom": true,
    "createdAt": "2026-10-19T21:00:00.000Z"
  }
}
```

---

### 3.2 Route: Fetch Custom Quests for Specific Date
* **Method & Path:** `GET /custom-quest`
* **Why It is Used:** Fetches custom quests for a specific date in the user's timezone. Quests completed on previous evenings (e.g., Monday 9:20 PM CDT) accurately return `isCompleted: false` and `isDone: false` on Tuesday.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`). Defaults to user today. |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/custom-quest?date=2026-10-20" \
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
      "title": "Study Italian",
      "name": "Study Italian",
      "category": "LEARNING",
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

### 3.3 Route: Complete Custom Quest
* **Method & Path:** `POST /custom-quest/:id/complete` (Dual-supported: `PATCH /custom-quest/:id/complete`)
* **Why It is Used:** Marks the custom quest complete for today and credits XP (subject to the 50 XP/day anti-abuse allowance). The URL parameter accepts raw UUID or `custom_`-prefixed ID.

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/custom-quest/58dbf014-37b0-47dc-9228-99308c8fce63/complete" \
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
    "companionTotalXp": 460,
    "companionLevel": 4
  },
  "quest": {
    "id": "58dbf014-37b0-47dc-9228-99308c8fce63",
    "name": "Study Italian",
    "isCompleted": true,
    "isDone": true,
    "completedAt": "2026-10-20T18:25:00.000Z"
  },
  "earnedXp": 10,
  "newBalanceXp": 120
}
```

---

## Feature Domain 4: Nutrition, Meal Logging & Daily Macro Goals

### 4.1 Route: Log a Meal
* **Method & Path:** `POST /meal-log`
* **Why It is Used:** Logs nutritional food intake for the user's daily tracker. Calculates total calories automatically if omitted and awards `+30 XP`.

#### Route Fields & Data Types

| Field | Type | Required | Description | Examples |
|---|---|:---:|---|---|
| `mealType` | `string` | **Yes** | Meal classification | `'BREAKFAST'`, `'LUNCH'`, `'DINNER'`, `'SNACK'` |
| `description` | `string` | No | Description / food name | `'Turkey bagel & avocado'` |
| `calories` | `number` | No | Total calories (auto-calculated if omitted) | `420` |
| `carbs` | `number` | **Yes** | Carbohydrates in grams | `35` |
| `protein` | `number` | **Yes** | Protein in grams | `42` |
| `fats` | `number` | **Yes** | Dietary fats in grams | `10` |
| `loggedAt` | `string` | No | Explicit timestamp | Defaults to current time |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/meal-log" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "mealType": "LUNCH",
    "description": "Turkey bagel with avocado",
    "calories": 420,
    "carbs": 35,
    "protein": 42,
    "fats": 10
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "c19b841a-8219-48be-9b30-3b8c2918ca12",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "mealType": "LUNCH",
  "description": "Turkey bagel with avocado",
  "calories": 420,
  "carbs": 35,
  "protein": 42,
  "fats": 10,
  "earnedXp": 30,
  "loggedAt": "2026-10-20T18:13:45.980Z"
}
```

---

### 4.2 Route: Get Meal History & Daily Macro Need/Consumed/Remaining
* **Method & Path:** `GET /meal-log/history` (Aliases: `/meal-log/today`, `/meal-log/daily`)
* **Why It is Used:** Powers the nutrition progress rings on the dashboard. Computes daily need, total consumed, and remaining values strictly within the user's localized calendar day. At 12:00 AM local time, `consumed` resets strictly to `0` and `remaining` resets to full targets.

#### Query Parameters
| Parameter | Type | Required | Default | Description |
|---|---|:---:|---|---|
| `date` | `string` | No | Today | Local calendar date (`YYYY-MM-DD`, e.g. `2026-10-20`) |
| `timezone` | `string` | No | Header fallback | User IANA timezone (e.g. `America/Chicago`) |
| `filterLogsByDate` | `boolean` | No | `false` | When `true`, returns only logs belonging to `date` |
| `limit` | `number` | No | `30` | Pagination limit |
| `offset` | `number` | No | `0` | Pagination offset |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/meal-log/history?date=2026-10-20&filterLogsByDate=true" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "daily": {
    "calories": 2000,
    "macroNeed": {
      "protein": 150,
      "fat": 65,
      "carb": 200
    }
  },
  "consumed": {
    "protein": 42,
    "fat": 10,
    "carb": 35,
    "calories": 420
  },
  "remaining": {
    "protein": 108,
    "fat": 55,
    "carb": 165,
    "calories": 1580
  },
  "weeklyPresent": {
    "sunday": false,
    "monday": true,
    "tuesday": true,
    "wednesday": false,
    "thursday": false,
    "friday": false,
    "saturday": false
  },
  "logs": [
    {
      "id": "c19b841a-8219-48be-9b30-3b8c2918ca12",
      "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
      "mealType": "LUNCH",
      "description": "Turkey bagel with avocado",
      "calories": 420,
      "carbs": 35,
      "protein": 42,
      "fats": 10,
      "loggedAt": "2026-10-20T18:13:45.980Z",
      "isTaken": true,
      "earnedXp": 30,
      "entryType": "LOG"
    }
  ],
  "totalCount": 1,
  "totalEarnedXp": 30
}
```

---

## Feature Domain 5: Weight Logging & Rollover

### 5.1 Route: Log Daily Weight
* **Method & Path:** `POST /weight-log`
* **Why It is Used:** Logs the user's body weight for today and awards `+10 XP`. Deduplication is evaluated against local calendar midnight, meaning weigh-ins after 7:00 PM CDT on Monday no longer block Tuesday morning logs.

#### Route Fields & Data Types

| Field | Type | Required | Description | Examples |
|---|---|:---:|---|---|
| `weight` | `string` / `number` | **Yes** | Current weight in user's unit (lbs or kg) | `'165.5'` |
| `note` | `string` | No | Optional note | `'Morning weigh-in before breakfast'` |

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/weight-log" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "weight": "165.5",
    "note": "Morning weigh-in"
  }'
```

#### Sample Success Response (`201 Created`)
```json
{
  "id": "w9182310-48ab-49ce-a128-48bc91230192",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "weight": "165.5",
  "note": "Morning weigh-in",
  "loggedAt": "2026-10-20T13:30:00.000Z",
  "createdAt": "2026-10-20T13:30:00.000Z"
}
```

#### Duplicate Error Response (`400 Bad Request`)
If a weight log is submitted twice on the same local calendar day:
```json
{
  "statusCode": 400,
  "message": "Already claimed xp",
  "error": "Bad Request"
}
```
*(Frontend Instruction: If the user wishes to edit their weight on the same day rather than creating a new entry, use `PATCH /weight-log/today`)*.

---

### 5.2 Route: Get Today's Weight Log
* **Method & Path:** `GET /weight-log/today`
* **Why It is Used:** Retrieves the weight log for the specified local calendar day.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `date` | `string` | No | Target local calendar date (`YYYY-MM-DD`). Defaults to today. |
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/weight-log/today?date=2026-10-20" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "id": "w9182310-48ab-49ce-a128-48bc91230192",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "weight": "165.5",
  "note": "Morning weigh-in",
  "loggedAt": "2026-10-20T13:30:00.000Z"
}
```

---

## Feature Domain 6: Step Tracking, Expedition Milestones & Camp Setup

### 6.1 Route: Sync Steps
* **Method & Path:** `PATCH /step-log/steps`
* **Why It is Used:** Syncs step telemetry from Apple Health or Google Fit for the user's localized calendar date. Updates fantasy map progression and total lifetime steps.

#### Route Fields & Data Types

| Field | Type | Required | Description | Example |
|---|---|:---:|---|---|
| `steps` | `number` | **Yes** | Total steps accumulated today | `8500` |
| `date` | `string` | No | Calendar date (`YYYY-MM-DD`) | `'2026-10-20'` |

#### Sample cURL Request
```bash
curl -X PATCH "https://velvet.api.softvence.app/step-log/steps" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "steps": 8500
  }'
```

#### Sample Success Response (`200 OK`)
```json
{
  "id": "s8192301-38ef-48cd-b912-38ef91203912",
  "userId": "0688ee8f-243a-4d7d-9c4b-2f9d89ba9691",
  "steps": 8500,
  "goal": 8000,
  "date": "2026-10-20T00:00:00.000Z",
  "isCampSet": false
}
```

---

### 6.2 Route: Set Up Camp (Expedition Goal Reached)
* **Method & Path:** `POST /step-log/camp/setup`
* **Why It is Used:** Pitches camp when the user achieves their daily step goal (or $\ge 8,000$ steps), awarding `+30 XP` and completing the **"Step Master"** (`step-master`) Codex quest.

#### Sample cURL Request
```bash
curl -X POST "https://velvet.api.softvence.app/step-log/camp/setup" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -H "x-timezone: America/Chicago" \
  -d '{
    "date": "2026-10-20"
  }'
```

#### Sample Success Response (`200 OK`)
```json
{
  "success": true,
  "message": "Camp pitched successfully for 2026-10-20!",
  "data": {
    "isCampSet": true,
    "steps": 8500,
    "xpAwarded": 30,
    "totalCampsites": 3
  }
}
```

---

## Feature Domain 7: Companion Dialogue & Contextual Interaction

### 7.1 Route: Get Active Companion Situational Dialogue
* **Method & Path:** `GET /companions/current/dialogue`
* **Why It is Used:** Returns dynamic, voice-acted lore dialogue from the user's active companion (Riven, Thyra, Leon, or Visepheron). Dialogue reacts contextually to user states (Post-Workout, Post-Meal, Morning, Afternoon, Evening, Night, or Streak at Risk). Time-of-day greetings and streak warnings are evaluated strictly in the user's local timezone.

#### Query Parameters
| Parameter | Type | Required | Description |
|---|---|:---:|---|
| `timezone` | `string` | No | User IANA timezone (e.g. `America/Chicago`). Defaults to header or profile. |

#### Sample cURL Request
```bash
curl -X GET "https://velvet.api.softvence.app/companions/current/dialogue" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "x-timezone: America/Chicago"
```

#### Sample Success Response (`200 OK`)
```json
{
  "companion": {
    "id": "c9182301-48fe-49ab-b192-384912039123",
    "name": "Riven",
    "slug": "riven",
    "title": "High Lord of the Forsaken Court",
    "quote": "Come now. We have things to accomplish."
  },
  "triggerContext": "AFTERNOON",
  "text": "The day wanes, yet our ambition does not. What victories shall we claim before twilight?",
  "actionPrompt": "Review Daily Quests",
  "timestamp": "2026-10-20T18:30:00.000Z"
}
```

#### Possible `triggerContext` Values
* `'POST_WORKOUT'`: Triggered if a workout was logged in the last 30 minutes.
* `'POST_MEAL'`: Triggered if a meal was logged in the last 30 minutes.
* `'STREAK_AT_RISK'`: Triggered only at night ($\ge 8:00\text{ PM}$ local time) if 0 activities are logged today.
* `'MORNING'`: 5:00 AM – 11:59 AM in user local timezone.
* `'AFTERNOON'`: 12:00 PM – 4:59 PM in user local timezone.
* `'EVENING'`: 5:00 PM – 8:59 PM in user local timezone.
* `'NIGHT'`: 9:00 PM – 4:59 AM in user local timezone.
* `'REENGAGEMENT'`: Triggered if 3+ days have passed without logged activity.

---

## Summary Integration Checklist for Frontend Developers

1. **Global Interceptor:** Set `x-timezone: Intl.DateTimeFormat().resolvedOptions().timeZone` on your API client (Axios, Fetch, or Dio).
2. **Date Queries:** Always pass dates in `YYYY-MM-DD` format (e.g. `?date=2026-10-20`).
3. **No Client Time Math:** Do not add or subtract hours on client side; display server date values directly or format locally via standard formatters.
4. **Quests Feed:** Check `isCompleted` as a strict boolean (`true` or `false`) to update completion checkboxes in UI.
5. **Recurring Schedules:** Pass `daysOfWeek` as an array of integers (`1` for Monday through `7` for Sunday).
6. **Macro Ring Reset:** Use `consumed` and `remaining` directly from `GET /meal-log/history`; the backend guarantees a clean slate at local midnight.
