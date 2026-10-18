# Backend Action Items & Bug Fixes (October 18, 2026)

**Severity**: High (Blocking UI features & throwing 400 errors in production)  
**Environment**: Production (`https://velvet.api.softvence.app`)  
**Database**: PostgreSQL via Prisma ORM  

---

## 1. Critical: Missing Database Column `meal_schedules.recurrence` (HTTP 400)

### Endpoint
`GET /meal-log/history?limit=30&offset=0`

### Error Response
```json
{
  "success": false,
  "statusCode": 400,
  "timestamp": "2026-10-18T06:32:46.446Z",
  "path": "/meal-log/history?limit=30&offset=0",
  "message": "\nInvalid `prisma.mealSchedule.findMany()` invocation:\n\n\nThe column `meal_schedules.recurrence` does not exist in the current database."
}
```

### Root Cause
The backend code in `MealScheduleService` / `meal-log` module executes a Prisma query (`prisma.mealSchedule.findMany()`) that references the field `recurrence`. However, the corresponding database migration was never executed or pushed to the live database (`prisma migrate deploy` or `prisma db push` was omitted during the last backend deployment).

### Reproduction cURL
```bash
curl -X GET "https://velvet.api.softvence.app/meal-log/history?limit=30&offset=0" \
  -H "accept: application/json" \
  -H "Authorization: Bearer <USER_ACCESS_TOKEN>" \
  -H "x-refresh-token: <USER_REFRESH_TOKEN>"
```

### Required Fix
1. Execute the pending migration on the production database:
   ```bash
   npx prisma migrate deploy
   ```
   *Or, if using automated schema push:*
   ```bash
   npx prisma db push
   ```
2. Ensure the `meal_schedules` table contains the column:
   ```sql
   ALTER TABLE "meal_schedules" ADD COLUMN IF NOT EXISTS "recurrence" TEXT DEFAULT 'DAILY';
   ```
3. Verify that `GET /meal-log/history` returns `200 OK` with the history payload.

---

## 2. Bug: `/mood-log/today` returns 400 Bad Request when no log exists

### Endpoint
`GET /mood-log/today?date=YYYY-MM-DD`

### Error Response
```json
{
  "success": false,
  "statusCode": 400,
  "timestamp": "2026-10-18T06:39:12.159Z",
  "path": "/mood-log/today?date=2026-10-18",
  "message": "No mood log found for today"
}
```

### Root Cause
When a user opens the app for the first time in a day, they have not yet logged a mood. This is a completely standard and expected user state.  
Returning an **HTTP 400 (Bad Request)** implies the client sent an invalid or malformed request, which causes network layers and error handlers to treat the response as an application failure.

### Required Fix
When no mood log entry is found for the given `date`:
- **Recommended**: Return **`200 OK`** with `data: null` (or `log: null`):
  ```json
  {
    "success": true,
    "statusCode": 200,
    "data": null,
    "message": "No mood log found for today"
  }
  ```
- **Alternative**: If an error status must be used, return **`404 Not Found`**, never `400 Bad Request`.

---

## 3. Checklist for Backend Team Deployment

- [ ] Run `npx prisma migrate deploy` on production.
- [ ] Confirm `SELECT column_name FROM information_schema.columns WHERE table_name='meal_schedules';` includes `recurrence`.
- [ ] Test `GET /meal-log/history?limit=30&offset=0` returns `200 OK`.
- [ ] Update `/mood-log/today` handler to return `200 OK` with `data: null` when no record exists.
- [ ] Deploy and verify health checks on `https://velvet.api.softvence.app`.
