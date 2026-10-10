# Backend Specification: Exercise History Backdating & Timezone-Aware Daily Resets

This document specifies the backend requirements and API updates needed to resolve **Issue 4 (Exercise History Past Dates)** and **Issue 5 (Daily Quest Reset / Timezone Alignment - High Priority)** reported during testing.

---

## 1. Issue 4: Exercise History Backdating (`POST /exercise-log`)

### Problem
Currently, when a user logs a completed workout, the backend stores `loggedAt: new Date()` (the server time when the request arrives). There is no parameter in the DTO to submit a past date/time. As a result, users cannot backdate workouts that took place earlier in the day or on previous days.

### Required Backend Changes

#### 1. Update `POST /exercise-log`
Allow an optional `loggedAt` field in the request payload.

- **Endpoint:** `POST /exercise-log`
- **Content-Type:** `multipart/form-data` or `application/json`
- **Authentication:** `Bearer <JWT>`

**Updated Request Fields / DTO:**
| Field | Type | Required | Description |
|---|---|---|---|
| `type` | String (enum: `CARDIO`, `STRENGTH`, `FLEXIBILITY`, `BALANCE`) | Yes | Exercise type |
| `name` | String | Yes | Name of exercise (e.g. `"Aerial Silks"`) |
| `intensity` | String (enum: `LOW`, `MEDIUM`, `HIGH`) | No | Intensity level (default `MEDIUM`) |
| `duration` | Integer | No | Duration in minutes (default `30`) |
| `note` | String | No | Optional notes |
| **`loggedAt`** | **String (ISO 8601 DateTime)** | **No** | **Timestamp when workout occurred (e.g. `"2026-10-14T19:15:00.000Z"`). If omitted or null, default to `new Date()`.** |

#### 2. Service & Database Logic
```typescript
// Example NestJS / Express handler logic
const exerciseDate = dto.loggedAt ? new Date(dto.loggedAt) : new Date();

const newLog = await this.prisma.exerciseLog.create({
  data: {
    userId: user.id,
    type: dto.type,
    name: dto.name,
    intensity: dto.intensity || 'MEDIUM',
    duration: dto.duration || 30,
    note: dto.note || '',
    loggedAt: exerciseDate, // Persist the custom date if supplied
    earnedXp: 10,
  },
});
```

#### 3. Query Sorting & Aggregation
- Ensure `GET /exercise-log/history` orders records by `loggedAt DESC` (not `createdAt DESC`).
- Ensure daily exercise statistics, total minutes, and weekly XP charts aggregate using `loggedAt`.

---

## 2. Issue 5: Timezone-Aware Daily Resets & Streaks (HIGH PRIORITY)

### Problem
The backend server runs in **UTC**. Currently, endpoints calculating "today" evaluate day boundaries against UTC midnight (`00:00:00 UTC`):
- For users in North America (e.g., Eastern Time EDT `UTC-4`, Central `UTC-5`, Pacific `UTC-7`):
  - **UTC midnight occurs at 8:00 PM EDT / 7:00 PM CDT / 5:00 PM PDT**.
  - At **8:00 PM local time**, the backend switches to the next calendar day.
  - Quests for "today" prematurely reset or disappear.
  - Daily logs (water, steps, mood, medication) reset to 0 while the user is still active in the evening.
  - Activities logged between 8:00 PM and 11:59 PM get stamped on "tomorrow" in UTC.
  - Streaks break unexpectedly because consecutive days are evaluated on UTC day boundaries rather than the user's local day boundaries.

### Current Endpoint Status in OpenAPI
| Endpoint | Current Parameter | Timezone Issue |
|---|---|---|
| `GET /quests/today` | Optional `?date=YYYY-MM-DD` | If no date sent, defaults to UTC day |
| `GET /quests/custom` | Optional `?date=YYYY-MM-DD` | If no date sent, defaults to UTC day |
| `GET /schedules` | Optional `?date=YYYY-MM-DD` | If no date sent, defaults to UTC day |
| `GET /water-log/today` | None | Calculates `00:00 UTC` to `23:59 UTC` |
| `GET /step-log/today` | None | Calculates `00:00 UTC` to `23:59 UTC` |
| `GET /mood-log/today` | None | Calculates `00:00 UTC` to `23:59 UTC` |
| `GET /medication-schedule/today` | None | Calculates `00:00 UTC` to `23:59 UTC` |
| `GET /exercise-log/schedule/today` | None | Calculates `00:00 UTC` to `23:59 UTC` |
| `GET /xp-stats/today` | None | Calculates `00:00 UTC` to `23:59 UTC` |
| `GET /profile` (streak / todaySchedules) | None | Calculates streak on UTC dates |

---

### Recommended Solutions

We recommend implementing **Approach A** as the primary solution, with **Approach B** as query parameter support where relevant.

### Approach A: Timezone-Aware Day Boundaries via `x-timezone` Header (Recommended)

The frontend will send the user's IANA timezone in standard headers with every request:
```http
x-timezone: America/New_York
x-timezone-offset: -240
```

#### Backend Implementation (Middleware / Utility):
1. **Helper function to calculate local start and end of day:**
```typescript
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';

dayjs.extend(utc);
dayjs.extend(timezone);

export function getUserDayBoundaries(
  userTimezone: string = 'UTC',
  targetDate?: string // optional 'YYYY-MM-DD'
): { startOfDay: Date; endOfDay: Date } {
  // If targetDate passed, use that date in user's timezone; else use 'now'
  const base = targetDate
    ? dayjs.tz(targetDate, userTimezone)
    : dayjs().tz(userTimezone);

  const startOfDay = base.startOf('day').toDate();
  const endOfDay = base.endOf('day').toDate();

  return { startOfDay, endOfDay };
}
```

2. **Extract Timezone from Request:**
```typescript
const userTz =
  req.headers['x-timezone']?.toString() ||
  req.user?.timezone ||
  'UTC';

const { startOfDay, endOfDay } = getUserDayBoundaries(userTz, req.query.date as string);
```

3. **Apply in Prisma / Database Queries for All `/today` Endpoints:**
```typescript
// Example: Water Log Today
const todayLogs = await this.prisma.waterLog.findMany({
  where: {
    userId: user.id,
    loggedAt: {
      gte: startOfDay,
      lte: endOfDay,
    },
  },
});
```

Apply this same day boundary logic to:
- `WaterLog`
- `StepLog`
- `MoodLog`
- `MedicationSchedule`
- `ExerciseSchedule`
- `XPStats` (`/xp-stats/today`)
- `DailyQuest` feed

---

### Approach B: Standardize `?date=YYYY-MM-DD` Across All `/today` Endpoints

If header-based timezone extraction is not preferred, add the optional `?date=YYYY-MM-DD` query parameter to all `/today` endpoints:
- `GET /water-log/today?date=YYYY-MM-DD`
- `GET /step-log/today?date=YYYY-MM-DD`
- `GET /mood-log/today?date=YYYY-MM-DD`
- `GET /medication-schedule/today?date=YYYY-MM-DD`
- `GET /exercise-log/schedule/today?date=YYYY-MM-DD`
- `GET /xp-stats/today?date=YYYY-MM-DD`

When `date` is present:
- Compute the 24-hour window for that date: `gte: new Date("${date}T00:00:00.000Z")`, `lte: new Date("${date}T23:59:59.999Z")` (or combined with the user's timezone offset).

---

### Streak Calculation Fix
Currently, streak calculations in `ProfileService` / `daily-login` check if the user logged on consecutive UTC days:
- If a user in New York logs at 9:00 PM on Tuesday (UTC Wednesday 01:00) and at 7:00 PM on Wednesday (UTC Wednesday 23:00), the backend sees **both logs as occurring on the same UTC day (Wednesday)**, and marks Tuesday as missed!
- **Fix:** When grouping login/activity timestamps for streaks, convert the timestamp to the user's local calendar date (`YYYY-MM-DD` in `userTz`) before checking for consecutive calendar days.

---

## 3. Bonus Verification: Step Quest (`step-master`) Trigger

In testing, logging a workout ("Aerial Silks") completed the step quest **"Stride of the Realmwalker"** (`step-master`).

**Backend Check:**
Please ensure that the `POST /exercise-log` service handler does **not** automatically mark `step-master` as completed. `step-master` should only be completed when the user reaches their step goal via step logging.

---

## 4. Frontend Alignment Summary

Once the backend updates are ready:
1. **Frontend will send `loggedAt`** in `POST /exercise-log` when the user selects a past date/time in the completed exercise form.
2. **Frontend will send headers:**
   - `x-timezone`: User's local IANA timezone name (e.g., `America/New_York`, `America/Chicago`).
   - `x-timezone-offset`: Offset in minutes (e.g., `-240`).
3. **Frontend will pass `?date=YYYY-MM-DD`** on `/quests/today`, `/quests/custom`, and other daily endpoints using the local device date.
