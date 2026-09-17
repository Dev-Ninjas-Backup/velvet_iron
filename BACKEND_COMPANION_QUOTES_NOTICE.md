# Velvet & Iron — Companion Quotes & Dialogue System (Backend Notification & Reference)

**Target Base URL**: `https://velvet.api.softvence.app`  
**Audience**: Backend Development Team  
**Subject**: Companion Dialogue System Architecture, Database Seed Updates, and Push Notification Templates  
**Date**: September 2026  

---

## 1. Executive Summary & Work Division

The product team has finalized the **Character Quote Packs** specification for the 4 core companions (Riven, Thyra, General Leon, Visepheron), comprising 800+ lines of dialogue across 17 interaction triggers.

### What the Backend DOES NOT Need to Build:
* **No dynamic quote API endpoints needed**: The Flutter mobile client bundles the full 800+ quote library locally in `assets/dialogue/companion_quotes.json`. In-app dialogues (quest completion, workout logs, hydration, app opens) will be evaluated and rendered **100% on-device** for instantaneous, offline-capable responses.
* You do **not** need to create high-throughput endpoints for in-app quote streaming.

### What the Backend DOES Need to Do:
1. **Update Companion Database Seeds** in the `companions` collection (names, titles, default quotes).
2. **Ensure Active Companion Serialization** in `GET /profile` and `GET /companions/my-companions` returns the updated character metadata.
3. **(Optional / Recommended) Push Notification Copy**: Use the supplied companion-specific templates for automated cron/push notification workflows (morning reminders, streak alerts, and inactive user re-engagement).

---

## 2. Action Item 1: Companion Database Seed Updates

Please update the `companions` table/collection seed records to reflect the 4 official launch companions:

### Companion 1: Riven
* **ID / Slug**: `riven`
* **Name**: `Riven`
* **Title**: `High Lord of the Forsaken Court`
* **Persona**: Seductive, sarcastic, clever, slightly dangerous, secretly supportive dark fae.
* **Default / Hero Quote**: `"Come now. We have things to accomplish."`
* **Unlock XP**: `0` (or as configured for onboarding default)

### Companion 2: Thyra
* **ID / Slug**: `thyra`
* **Name**: `Thyra`
* **Title**: `Shield of the Realm`
* **Persona**: Formidable paladin, protective, honorable, grounded, warm warrior.
* **Default / Hero Quote**: `"A shield is only as strong as the one who holds it. Take care of yourself."`
* **Unlock XP**: `250`

### Companion 3: General Leon
* **ID / Slug**: `general_leon` (or `leon`)
* **Name**: `General Leon`
* **Title**: `Commander of the Legions`
* **Persona**: Disciplined, tactical, concise, dry military humor, strategic.
* **Default / Hero Quote**: `"Discipline is choosing what you want most over what you want now."`
* **Unlock XP**: `250`

### Companion 4: Visepheron
* **ID / Slug**: `visepheron`
* **Name**: `Visepheron`
* **Title**: `Ancient Dragon`
* **Persona**: Ancient, immense wisdom, draconic pride, cosmic patience.
* **Default / Hero Quote**: `"Come, little flame. Burn steadily today."`
* **Unlock XP**: `250`

---

## 3. Action Item 2: Profile API Response Alignment

In `GET /profile` and `GET /companions/my-companions`, ensure the `activeCompanion` object returns the updated companion `name`:

```json
{
  "activeCompanion": {
    "id": "user_companion_id",
    "companionId": "companion_id",
    "companion": {
      "id": "companion_id",
      "name": "Riven",
      "title": "High Lord of the Forsaken Court",
      "quote": "Come now. We have things to accomplish."
    }
  }
}
```

The Flutter app inspects `activeCompanion.companion.name` (case-insensitive: `riven`, `thyra`, `leon` / `general leon`, `visepheron`) to select the local quote pack engine.

---

## 4. Action Item 3: Push Notification Copy Reference

If the backend triggers automated push notifications (e.g. Firebase Cloud Messaging / cron jobs), use the approved companion copy below based on the user's selected active companion:

### A. Morning Reminder (Sent between 07:00 – 09:00 AM)
* **Riven**: `"Good morning, darling. Try not to declare war before breakfast."`
* **Thyra**: `"Morning. Clear eyes, steady breath. The day begins."`
* **General Leon**: `"Morning briefing: do what matters first."`
* **Visepheron**: `"Morning is merely an invitation to begin again."`

### B. Inactive User Re-engagement (Sent after 3+ days of inactivity)
* **Philosophy**: **Zero guilt, zero shame, zero punishment.**
* **Riven**: `"Time passed. You returned. That is the whole story. Welcome back."`
* **Thyra**: `"The shield does not judge you for laying it down. Welcome back."`
* **General Leon**: `"Absence noted. Status reset. Report for duty when ready."`
* **Visepheron**: `"The road did not vanish while you were gone. You need not apologize to me for being human."`

### C. Streak Maintenance / Evening Reminder (Sent around 20:00)
* **Riven**: `"Day upon day. This is how empires rise. Shall we keep the streak going?"`
* **Thyra**: `"Another day joins the chain. Your strength grows with every choice."`
* **General Leon**: `"Consistency is a strategic advantage. Log your progress for today."`
* **Visepheron**: `"Steady, little flame. Day upon day, this is how mountains change."`

---

## 5. Summary Checklist for Backend Developers

| # | Task | Component | Priority |
|---|---|---|---|
| 1 | Update `companions` collection seeds with official names (Riven, Thyra, General Leon, Visepheron) | Database Seeds | **High** |
| 2 | Ensure `GET /profile` returns updated `activeCompanion.companion.name` | API (`/profile`) | **High** |
| 3 | Use companion-specific copy in automated push notification payloads | Notification Service / FCM | **Optional / Recommended** |

---

*For full dialogue compendium with all 800+ lines, refer to [COMPANION_QUOTE_PACKS_SPECIFICATION.md](./COMPANION_QUOTE_PACKS_SPECIFICATION.md).*
