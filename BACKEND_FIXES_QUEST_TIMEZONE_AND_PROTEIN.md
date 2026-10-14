# Backend Specification: Quest Timezone Alignment & Protein Requirement Fix

This document provides the backend engineering team with the exact root causes, requirements, and code solutions to resolve the two client-reported issues:
1. **Issue 1:** Titan's Nourishment — 30g Single-Meal Protein Requirement
2. **Issue 2:** Quests Screen Timezone Bug — Scheduled Exercises & Daily Reset Alignment

---

## 1. Issue 1: Titan's Nourishment (30g Protein Requirement)

### Problem
- The quest currently requires **120g** of protein, but client specifications require **30g of protein in a single meal**.
- When the client logged a meal with exactly 30g of protein, the quest remained incomplete because the backend logic checks `protein >= 120`.
- The quest description returned by `GET /quests/today` also displays `"Log a meal with 120g+ protein"`.

### Required Backend Changes

#### 1. Update Quest Record in Database
Update the seed/preset quest definition for `protein-power` (or `codex_protein-power`):
- **Title:** `Titan's Nourishment` (or keep identifier `protein-power`)
- **Description:** `Log a meal with 30g+ protein`
- **Target Value:** `30`
- **XP Reward:** `30`

#### 2. Update Meal Log Activity Evaluation (`POST /meal-log`)
When a user logs a meal (`POST /meal-log` or `POST /meal-log/photo`), evaluate single-meal protein:

```typescript
// Example NestJS / Express meal log completion trigger
async function onMealLogged(userId: string, meal: { protein: number }): Promise<void> {
  // Check SINGLE meal protein (do NOT sum cumulative daily protein)
  if (meal.protein >= 30) {
    await completeCodexQuest(userId, 'protein-power', 30 /* xp */);
  }
}
```

*Note: Completion must trigger immediately on the logged meal and award the 30 XP.*

---

## 2. Issue 2: Timezone Bug on Quests Screen (`GET /quests/today`)

### Problem & Root Cause Analysis
During physical testing, the client scheduled an exercise for **Tuesday, October 13, at 6:45 PM** in their local timezone (US Central Time, `UTC-5`):
- **On the Exercise Screen:** Correctly displayed as **"Today - 06:45 PM"**.
- **On the Quests Screen:** Displayed as **"Wednesday, October 14, 2026 at 5:45 AM"** (+11 hours ahead).

#### Why this occurs:
1. **App Sends Standard UTC:** When scheduling, the mobile app converts the local time (`2026-10-13 18:45:00`) to UTC (`2026-10-13T23:45:00.000Z`) and sends it to `POST /exercise-log/schedule`, with the header `x-timezone: America/Chicago`.
2. **Exercise Screen converts back:** The Exercise screen fetches `scheduledAt` as raw UTC and calls `.toLocal()`, which renders **"Today - 06:45 PM"** correctly.
3. **Quests Screen uses Server Local Time:** In `GET /quests/today`, the backend aggregates scheduled workouts into quest objects. When populating the `description` field, the backend executes date formatting using the **server's local machine timezone (Bangladesh, `UTC+6` / Asia/Dhaka)** instead of the client's `x-timezone` header:
   $$\text{23:45 UTC} + \text{6 hours (BST)} = \mathbf{\text{05:45 AM (Wednesday, Oct 14)}}$$
   This difference of **exactly +11 hours** matches the offset between US Central (`UTC-5`) and Bangladesh (`UTC+6`).
4. **Incorrect Day Partitioning:** Because the backend evaluated the date in server local time (where it was already Wednesday morning), the workout was incorrectly treated as a Wednesday quest rather than Tuesday's quest.
5. **Daily Quest Resets:** Daily quest resets and streak cron jobs are currently firing at midnight server time (Bangladesh UTC+6), resetting quests for US users in the early afternoon.

---

### Required Backend Changes

#### 1. Respect the `x-timezone` Request Header in `GET /quests/today`
Extract the client's IANA timezone from the request header:

```typescript
// Header: x-timezone (e.g. "America/Chicago", "America/New_York", "Europe/London")
const userTimezone = (req.headers['x-timezone'] as string) || 'UTC';
```

When formatting the `description` string for `WORKOUT_SCHEDULE` items:

```typescript
import moment from 'moment-timezone';

function formatWorkoutDescription(
  workout: { type: string; duration: number; scheduledAt: Date },
  userTimezone: string
): string {
  // Convert UTC timestamp to user's native timezone before formatting
  const formattedDate = moment(workout.scheduledAt)
    .tz(userTimezone)
    .format('dddd, MMMM D, YYYY [at] h:mm A');

  return `${workout.type.toUpperCase()} • ${workout.duration} min • ${formattedDate}`;
}
```

#### 2. Include Raw `scheduledAt` in the Quest Response (Recommended)
In addition to the formatted description, include the raw ISO-8601 UTC timestamp in the quest object so mobile clients can format it natively:

```json
{
  "id": "workout_123e4567-e89b-12d3",
  "title": "Ice Skating",
  "description": "CARDIO • 30 min • Tuesday, October 13, 2026 at 6:45 PM",
  "scheduledAt": "2026-10-13T23:45:00.000Z",
  "xpReward": 10,
  "isCompleted": false,
  "questType": "WORKOUT_SCHEDULE",
  "originalRefId": "123e4567-e89b-12d3"
}
```

#### 3. Querying "Today's" Workouts Using User Timezone Boundaries
When filtering scheduled workouts for the unified feed (`GET /quests/today?date=YYYY-MM-DD`):
Calculate the 24-hour UTC window for the user's local day:

```typescript
import moment from 'moment-timezone';

function getUtcDayRangeForTimezone(targetDateStr: string, timezone: string) {
  // targetDateStr = "2026-10-13"
  const startOfDay = moment.tz(targetDateStr, 'YYYY-MM-DD', timezone).startOf('day').toDate();
  const endOfDay = moment.tz(targetDateStr, 'YYYY-MM-DD', timezone).endOf('day').toDate();

  return { startOfDay, endOfDay };
}

// Database query:
const { startOfDay, endOfDay } = getUtcDayRangeForTimezone(queryDate, userTimezone);

const scheduledWorkoutsToday = await prisma.exerciseSchedule.findMany({
  where: {
    userId,
    scheduledAt: {
      gte: startOfDay,
      lte: endOfDay,
    },
  },
});
```

#### 4. Timezone-Aware Daily Quest Resets & Streaks
Ensure daily quest completion resets and streak computations evaluate midnight in the user's timezone:
- A user's quests should reset when `00:00:00` occurs in **their** local timezone (`user.timezone` or `x-timezone`), not at midnight in Bangladesh / server time.

---

## 3. Verification & Acceptance Checklist

| # | Test Scenario | Expected Result |
|---|---|---|
| 1 | Log a meal with **30g protein** | `Titan's Nourishment` quest marks complete immediately and awards **+30 XP**. |
| 2 | Log a meal with **25g protein** | `Titan's Nourishment` quest remains incomplete. |
| 3 | Schedule exercise in US timezone (e.g. `America/Chicago`) at **Tuesday 6:45 PM** | `GET /quests/today` returns `Tuesday, October 13 ... at 6:45 PM` in `description`. |
| 4 | Open Quests screen on mobile client | Quest appears under **Today's Quests** with matching Tuesday 6:45 PM time, aligned with Exercise screen. |
| 5 | Pass `x-timezone: Europe/London` | Date/time converts to UK local time. |
| 6 | Midnight passage in US timezone | Quests reset at user's local midnight. |
