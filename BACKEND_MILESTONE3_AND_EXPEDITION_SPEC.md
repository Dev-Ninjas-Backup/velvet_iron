# Backend Specification: Milestone 3 & Expedition V1 Alignment

This document outlines the exact API contracts, database schema requirements, and anti-abuse validation rules required from the backend engineering team for **Velvet & Iron**.

---

## 1. Custom Quests System & Anti-Abuse (Milestone 3)

### Context & Requirements
Users can forge custom daily quests (e.g., "Read 20 pages", "10-minute meditation", "Cold shower"). While the frontend currently provides an offline fallback, the backend must implement cloud persistence, synchronization, and anti-abuse safeguards.

### Anti-Abuse Rule (Critical)
To prevent players from inflating companion XP and leveling up artificially:
- **Max XP per custom quest**: 15 XP.
- **Max total XP per day from custom quests**: 50 XP across all completed custom quests.
- If a user completes more custom quests after reaching 50 XP in a single day, the completion is saved, but the companion XP awarded is capped at 0 for subsequent completions.

### Endpoints

#### `POST /quests/custom`
Create a new custom quest for the authenticated user.

- **Headers**: `Authorization: Bearer <token>`
- **Request Body**:
  ```json
  {
    "title": "Evening Stretch",
    "description": "10 minutes of hip and back mobility",
    "xpReward": 15,
    "frequency": "DAILY"
  }
  ```
- **Validation**:
  - `title`: String, min 3, max 60 chars (required).
  - `xpReward`: Integer, between 5 and 15 (auto-clamped to 15 if higher).
  - `frequency`: Enum `["DAILY", "WEEKLY"]` (default `"DAILY"`).
- **Response** (`201 Created`):
  ```json
  {
    "success": true,
    "data": {
      "id": "cquest_789abc",
      "userId": "user_123",
      "title": "Evening Stretch",
      "description": "10 minutes of hip and back mobility",
      "xpReward": 15,
      "frequency": "DAILY",
      "isCompleted": false,
      "createdAt": "2026-09-24T10:00:00.000Z"
    }
  }
  ```

#### `GET /quests/custom`
Fetch all custom quests for the user for the requested date.

- **Headers**: `Authorization: Bearer <token>`
- **Query Params**: `?date=YYYY-MM-DD` (defaults to today in user's timezone)
- **Response** (`200 OK`):
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "cquest_789abc",
        "title": "Evening Stretch",
        "description": "10 minutes of hip and back mobility",
        "xpReward": 15,
        "frequency": "DAILY",
        "isCompleted": false,
        "completedAt": null
      }
    ],
    "meta": {
      "todayCustomXpEarned": 15,
      "dailyCustomXpCap": 50
    }
  }
  ```

#### `POST /quests/custom/:id/complete`
Mark a custom quest as complete and award XP (subject to daily cap).

- **Headers**: `Authorization: Bearer <token>`
- **Response** (`200 OK`):
  ```json
  {
    "success": true,
    "data": {
      "id": "cquest_789abc",
      "isCompleted": true,
      "xpAwarded": 15,
      "companionTotalXp": 460,
      "companionLevel": 3
    }
  }
  ```

#### `DELETE /quests/custom/:id`
Delete a custom quest.

- **Headers**: `Authorization: Bearer <token>`
- **Response** (`200 OK`):
  ```json
  {
    "success": true,
    "message": "Custom quest deleted successfully."
  }
  ```

---

## 2. Recurring Schedules (Medications & Workouts)

### Context & Requirements
Users must be able to schedule medications and workouts with recurring frequencies (Daily, Weekly, or Specific Days of the week) rather than one-off single timestamps. Users must also be able to pause, edit, or delete recurring schedules.

### Schema Fields to Add
Add the following fields to the `scheduled_items` / `medication_schedules` / `workout_schedules` tables or collections:

```json
{
  "recurrenceType": "NONE" | "DAILY" | "WEEKLY" | "SPECIFIC_DAYS",
  "daysOfWeek": [1, 2, 3, 4, 5], 
  "timeOfDay": "08:30",
  "isPaused": false,
  "startDate": "2026-09-24",
  "endDate": null
}
```
*Note: `daysOfWeek` uses ISO 8601 standard integers where 1 = Monday, 7 = Sunday.*

### Endpoints
- `POST /schedules` — Create a recurring schedule.
- `GET /schedules?date=YYYY-MM-DD` — Automatically expands recurring items that match the given date.
- `PATCH /schedules/:id` — Update schedule (e.g. toggle `isPaused`, change reminder time or recurrence).
- `DELETE /schedules/:id` — Soft-delete or remove schedule.

---

## 3. Independent Calorie Goal Architecture

### Context & Problem
Currently, the backend automatically derives the user's daily calorie goal strictly from macro inputs via the formula:
$$\text{Calories} = (4 \times \text{Protein}) + (4 \times \text{Carbs}) + (9 \times \text{Fat})$$

While nutritionally grounded, clients and users need the ability to set a standalone manual calorie target (e.g. 2,000 kcal) without the backend overwriting it when macros are adjusted independently or left as estimates.

### Required Backend Behavior
1. In `user_profiles` / `daily_goals`:
   - Store `calorieGoal` as an independent column/attribute.
   - Store an enum or flag: `calorieGoalMode: "AUTO" | "MANUAL"`.
2. When `calorieGoalMode == "MANUAL"`, do **NOT** recompute `calorieGoal` when the user updates carbs, protein, or fat goals.
3. In `GET /user/profile` and `GET /nutrition/goals`, return the stored `calorieGoal` directly.

---

## 4. Expedition V1 Journey Alignment (1,000,000 Steps)

### Context & Canonical Season Content
The app features "The Long March" Grand Journey. The full Season 1 journey culminates at **1,000,000 cumulative steps** across 10 canonical landmarks.

### The 10 Canonical Milestones
| Milestone # | Milestone Name | Cumulative Steps Required |
|:---:|:---|:---:|
| 1 | The Whispering Woods | 25,000 |
| 2 | Mistveil Crossing | 75,000 |
| 3 | Old Stonewatch Fort | 150,000 |
| 4 | Moonlit Ridge | 250,000 |
| 5 | Ashen Hollow | 375,000 |
| 6 | Sunken Bastion | 500,000 |
| 7 | Windswept Plateau | 625,000 |
| 8 | Frostpine Pass | 750,000 |
| 9 | High Dragon's Roost | 875,000 |
| 10 | The World's Edge | 1,000,000 |

### Step Logging Anti-Abuse (Critical)
- **Max Daily Walking Limit**: Reject or clamp daily steps exceeding **50,000 steps/day** per user.
- If a request attempts to add steps resulting in $> 50,000$ for a single day, respond with HTTP `400 Bad Request`:
  ```json
  {
    "statusCode": 400,
    "message": "Daily walking limit reached (50,000 steps). Rest your legs, traveler!"
  }
  ```

### Campsite Evening Ritual (`POST /step-log/set-up-camp`)
- When pitched, lock today's step count. Subsequent step additions on the same date should be rejected with:
  ```json
  {
    "statusCode": 400,
    "message": "Camp has already been pitched for today. Today's steps are locked."
  }
  ```
- Award **+20 XP** once per calendar day.
- Increment `totalCampsites` counter on the user profile.
- Return the unlocked milestone index and cumulative steps in the response body.
