# Backend Action Items & Fixes: Specific-Day Quest Reset & GLP-1 Weekly Scheduling (October 26, 2026)

**Target Audience:** Backend Engineering Team  
**Base URL:** `https://velvet.api.softvence.app`  
**Reference Client Feedback:** `client_text16.txt`  
**Severity:** High (Pre-Launch Blocker)  

---

## 1. Issue 1: Specific-Day Custom Quest Reappearance & Midnight Reset

### Client Problem Statement
> *"When a quest is scheduled for specific days of the week, it appears to disappear after being completed on the first scheduled day. I'm concerned it may not reappear at midnight on the next selected day. Please verify that these quests reset and reappear correctly on every scheduled day, even after previous completions. They should remain active on their assigned schedule unless the user changes or deletes them."*

---

### Root Cause & Architectural Analysis
1. **Frontend Request:**
   When creating a custom quest for specific weekdays (e.g., Monday, Wednesday, Friday), the mobile app sends:
   ```json
   POST /custom-quest
   {
     "title": "Gym Strength Session",
     "category": "FITNESS",
     "recurrence": "SPECIFIC_DAYS",
     "daysOfWeek": [1, 3, 5],
     "xpReward": 10
   }
   ```
2. **Current Backend Behavior:**
   - On **Monday (Day 1)**: The quest appears in `GET /quests/today` with `isCompleted: false`.
   - The user completes it: `POST /custom-quest/:id/complete` (or `POST /quests/today/complete`).
   - If the backend mutates the parent quest row directly (`custom_quests.isCompleted = true`), or if `GET /quests/today` filters using `WHERE isCompleted = false`:
     - On **Tuesday (Day 2)**: It does not appear because Tuesday is not in `[1, 3, 5]`. (This is correct behavior, but leads the client to suspect the quest was deleted).
     - On **Wednesday (Day 3)**: The quest **must reappear** at midnight in the user's timezone (`x-timezone`) with **`isCompleted: false`**. If `isCompleted` was permanently set on the quest row, it either never appears again or appears permanently checked.

---

### Required Backend Changes

#### 1. Decouple Quest Definition from Daily Completion Status
Do **not** mutate the master custom quest row when marking a quest as completed. Track completions in a separate date-scoped table (similar to `schedule_completions`):

```prisma
// Example Prisma schema pattern
model CustomQuest {
  id          String   @id @default(uuid())
  userId      String
  title       String
  category    String   @default("GENERAL")
  recurrence  String   @default("DAILY") // DAILY, SPECIFIC_DAYS, WEEKLY
  daysOfWeek  Int[]    // [1, 3, 5] (1=Monday ... 7=Sunday)
  xpReward    Int      @default(10)
  isPaused    Boolean  @default(false)
  createdAt   DateTime @default(now())

  completions CustomQuestCompletion[]
}

model CustomQuestCompletion {
  id            String   @id @default(uuid())
  customQuestId String
  userId        String
  completedDate String   // "YYYY-MM-DD" in user's timezone
  completedAt   DateTime @default(now())
  earnedXp      Int      @default(10)

  customQuest   CustomQuest @relation(fields: [customQuestId], references: [id], onDelete: Cascade)

  @@unique([customQuestId, completedDate])
}
```

#### 2. Querying Active Quests in `GET /quests/today` and `GET /custom-quest`
When querying quests for a given date (`?date=YYYY-MM-DD` and `x-timezone: America/Chicago`):

```typescript
// 1. Calculate the local weekday for queryDate (1 = Monday ... 7 = Sunday)
const localWeekday = moment.tz(queryDate, userTimezone).isoWeekday();

// 2. Fetch all active custom quests that should appear on this weekday:
//    - recurrence == 'DAILY'
//    - OR (recurrence in ['SPECIFIC_DAYS', 'WEEKLY'] AND daysOfWeek contains localWeekday)
const eligibleQuests = await prisma.customQuest.findMany({
  where: {
    userId,
    isPaused: false,
    OR: [
      { recurrence: 'DAILY' },
      {
        recurrence: { in: ['SPECIFIC_DAYS', 'WEEKLY'] },
        daysOfWeek: { has: localWeekday }
      }
    ]
  }
});

// 3. Check completions specifically for the target calendar date:
const completionsToday = await prisma.customQuestCompletion.findMany({
  where: {
    userId,
    completedDate: queryDate // e.g. "2026-10-21"
  }
});
const completedQuestIds = new Set(completionsToday.map(c => c.customQuestId));

// 4. Map response: isCompleted is strictly scoped to queryDate
const responseData = eligibleQuests.map(quest => ({
  id: quest.id,
  title: quest.title,
  category: quest.category,
  recurrence: quest.recurrence,
  daysOfWeek: quest.daysOfWeek,
  xpReward: quest.xpReward,
  isCompleted: completedQuestIds.has(quest.id), // false on next scheduled day!
  isDone: completedQuestIds.has(quest.id)
}));
```

---

## 2. Issue 2: GLP-1 Optional Quest (Weekly Schedule vs Daily Quest)

### Client Problem Statement
> *"The optional GLP-1 injection quest is currently appearing as a daily quest. This is incorrect, as the GLP-1 injections supported by this feature are administered once per week. The user should be able to select their preferred injection day during setup. The quest should then appear only on that selected day each week, reset weekly, and award XP once per scheduled completion. It should not appear as a daily quest or require daily completion."*

---

### Root Cause
1. In `GET /quests/today` (or `/xp-stats/quests`), the backend currently returns **"Elixir of the Alchemist"** (`track-your-shot` / `codex_track-your-shot`) as a **daily mandatory Codex quest** every single day.
2. GLP-1 injections (e.g. Tirzepatide, Semaglutide) are taken **strictly once per week** on a single assigned day (e.g. every Sunday).
3. Expecting users to log an injection daily is medically incorrect and breaks quest streak completion for users who cannot complete it on the other 6 days of the week.

---

### Required Backend Changes

#### Option A: Exclude `track-your-shot` from Default Daily Codex Feed (Recommended)
Remove `track-your-shot` / `Elixir of the Alchemist` from the hardcoded daily Codex quest list in `GET /quests/today`.  
Instead, rely on the **Medication Schedule** system:
- When a user schedules a GLP-1 medication via `POST /medication-schedule`:
  ```json
  {
    "name": "GLP-1",
    "type": "INJECTION",
    "doseMg": 5,
    "recurrence": "WEEKLY",
    "daysOfWeek": [7], // e.g. Sunday
    "scheduleTime": "2026-10-25T14:00:00.000Z"
  }
  ```
- The backend's Unified Quests Feed (`GET /quests/today`) will automatically include it as a `MEDICATION_SCHEDULE` quest **only on Sunday**, rather than as an inescapable daily Codex quest.

#### Option B: Store Preferred Weekly Injection Day on User Profile / Quest Preferences
If `Elixir of the Alchemist` is maintained as a Codex quest:
1. Add `glp1InjectionDay` (`1` = Mon ... `7` = Sun, or `null`) to user settings/profile (`PATCH /auth/profile` or `PATCH /user/preferences`).
2. In `GET /quests/today`:
   - Only include `Elixir of the Alchemist` if `glp1Enabled == true` **AND** `todayWeekday == user.glp1InjectionDay`.
   - On the remaining 6 days of the week, exclude it from the response so it does not block 100% daily quest completion.

---

## 3. Verification & Acceptance Checklist

- [ ] **Specific-Day Recurrence:** Create a custom quest for Monday and Wednesday. Complete it on Monday. Verify that for Wednesday (`?date=YYYY-MM-DD` where date is Wednesday), `GET /quests/today` returns the quest with `isCompleted: false`.
- [ ] **Non-Scheduled Day Exclusion:** On Tuesday, verify that the quest is excluded from `GET /quests/today`.
- [ ] **GLP-1 Weekly Isolation:** Verify that GLP-1 / "Elixir of the Alchemist" does **not** appear as a daily quest 7 days a week. It must only appear on the user's selected weekly injection day.
- [ ] **Timezone Alignment:** Confirm all midnight resets and day transitions use the client's `x-timezone` header (e.g., `America/Chicago`).
