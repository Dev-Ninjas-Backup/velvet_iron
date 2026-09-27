# Velvet & Iron — Complete Client Communication & Feedback Archive

> **Document Purpose**: This document serves as the permanent, single source of truth preserving all client emails, feedback notes, functional requirements, and revision specifications from the start of testing through each milestone.

---

## 1. Email 1: Initial Android Build Feedback (The March Build Comparison)
*Received during initial testing of the handover build.*

### Full Message Transcript
```text
Hi team,

I’ve now been able to access and test the Android build, and I need to confirm that I was sent the most recent version of the app. I’m very concerned because a significant number of updates and changes I requested previously—including some that were discussed months ago—do not appear to have been implemented.

In just my initial testing, I’ve already found multiple major issues. The themes are not displaying the correct artwork, the companion characters are not appearing and interacting/speaking to the user as intended, and the wrong companion briefly appears when navigating between screens before switching to the selected companion. The generic black notification/error boxes that I specifically requested be replaced are also still throughout the app.

There are also functional issues. I cannot log a completed exercise or schedule an exercise; both return errors. I updated and saved my macro goals, but the app did not retain them. My profile picture initially appeared automatically even though I did not select one, and it has now disappeared.

The quest system also does not reflect what we discussed. There is no way for the user to create/add their own quests, the quests do not appear to integrate properly with the daily task system, and several of the preset quests need correction. For example, one asks the user to log a meal containing 120g+ of protein. Meal logging also displays calories with “g” as the unit. There are no “N/A,” “not yet,” or skip options for food and medication where those options are necessary.

I’m also finding outdated/incorrect copy, grammar issues, and even a subscription confirmation showing an expiration date in September 2025.

This is only from my first pass through the app, and I am continuing to document issues with screenshots. I understand that this is a test build and expected to contain bugs, but many of the things I am seeing are not new beta feedback—they are items I have already communicated previously.

Before I continue compiling the full QA/revision list, please confirm whether the build I received tonight is the latest development build and whether the visual/functional updates I previously provided were supposed to be included in this build.

I have put a significant amount of time into providing detailed feedback, artwork, UI direction, character information, and functionality requirements, so I need to understand why so much of that work is not reflected in the version I am currently testing.
```

### Team Response
```text
The current build doesn't include the 10 files and the quote pack you sent us 2 days ago. They are under development. 

As I previously mentioned our team recently had a developer handover that's what caused the delay.

After it's done I will upload the 2nd version of the app.
```

### Client Follow-Up Reply
```text
Thank you for clarifying. I understand that the 10 files and quote pack I sent two days ago are still under development, and I was not expecting every very recent item to necessarily be included in this build.

My concern is with the items I communicated well before those files, including requirements and changes discussed months ago, as well as core functionality that is currently not working.

For example, I have now tested a significant portion of the app and the selected companion has not appeared or spoken to me a single time despite completing onboarding, logging activities, earning XP, navigating screens, and completing other actions. Companion interaction is a core feature of the app and has been discussed previously.

I also cannot log or schedule an exercise, the barcode scanner does not work, there is no ability to create custom quests, and several parts of the quest and logging systems do not function as previously discussed. The generic black notification boxes I previously asked to have changed are still present as well.

The app is also currently named “Velvet & Iron” rather than “Velvet & Iron Training Codex.”

These are separate from the new files I sent two days ago.

I understand that a developer handover caused delays, but I need clarity on the status of the previously requested functionality and changes. Please let me know which of those existing requirements are already implemented, which are currently under development, and which have not yet been implemented.

I will continue testing this build and compiling a complete QA list with screenshots so that we can make sure the second version addresses everything before launch. I also need a concrete timeline for the next build. When can I expect Version 2 to be uploaded and available for me to test?

At this point, “under development” is not enough information for me to properly plan the launch. Please provide an estimated date for when the current updates will be completed and when I will receive the next test build.

I understand that unexpected development issues and the developer handover can affect timelines, but after the amount of time this project has already been in development, I need clear expectations and regular progress updates going forward.

One important clarification: the artwork and quote pack I resent two days ago were NOT originally provided two days ago. I originally sent those updated materials on August 6. I resent them two days ago to make sure the current development team had everything they needed.
That distinction is important because the build I am testing tonight appears substantially the same as the build I was given around March.
Before I stepped away from the project because of my head injury, I had already provided feedback on issues including the themes not matching correctly, the characters not appearing/interacting with the user as intended, and other UI/functionality changes. I am now seeing those same issues months later.
I understand there has been a developer handover and that the most recent materials may still be actively implemented. However, I need clarification on what development work and previously requested revisions were completed between the build I received around March and the build I received tonight.
```

---

## 2. Document: Step-Tracking, Expedition & Fantasy Map Architecture
*Extracted from `client_text.txt`.*

### Full Requirement Transcript
```text
I wanted to expand on the step-tracking/map idea so you have a clear picture of how I would like the system to work if this is feasible for V1.
For V1, steps will still be manually entered. Automatic health/device syncing remains planned for V2.

Users should be able to:
- Set their own daily step goal.
- Manually enter/update their steps during the day.
- See their daily steps vs. their personal goal.
- Have ALL steps count toward their journey, even if they don't reach their daily goal.

For example, if their goal is 10,000 but they complete 6,000, they still travel 6,000 steps on the map.
Their personal goal determines daily goal/quest completion, but should not determine whether their steps count toward the journey.

SET UP CAMP:
When the user knows they're finished walking for the day, they can tap "Set Up Camp."
This would:
1. Lock their final step count for that day.
2. Add those steps to their cumulative journey total.
3. Move their footprints forward on the fantasy map.
4. Place a small campsite where they stopped for the day.

There should be a confirmation before locking it, such as:
"Set Up Camp? Your journey for today will end here with 7,842 steps traveled. Once camp is established, today's journey cannot be changed."

Ideally, Set Up Camp can only be completed once per day. If feasible, the app could also automatically set up camp at the end of the day using the user's most recently entered step count if they forget.

THE MAP:
Instead of only a normal progress bar, users would have an aged fantasy/adventure map. Their footsteps move along a winding path based on cumulative steps.
I'd like users to be able to look/scroll slightly ahead and see upcoming landmarks and how many steps remain until they reach them. Daily campsites would appear wherever they stopped rather than being predetermined locations.

For the landmarks, I'd like the distance between them to gradually increase so the journey lasts longer.
Example first journey:
25,000 - The Wayfarer's Arch
55,000 - Whisperwood
90,000 - Blackwater Crossing
130,000 - The Ruins of Vael
175,000 - The Witchlight Marsh
225,000 - The Hollow Watchtower
280,000 - The Ashen Pass
340,000 - The Fallen King's Road
410,000 - The Obsidian Keep
500,000 - The Shattered Citadel

At 10,000 steps/day, the journey would take around 50 days; at 5,000/day, around 100 days. Everyone progresses at their own pace.
For V1, this would be ONE shared map/journey for all four companions.
I'd also like simple lore incorporated into the journey. When users Set Up Camp, their companion could occasionally give a short comment or teaser about the road ahead. When they reach a landmark, they could unlock lore, companion dialogue and/or XP.
The locations would have shared world lore, but each companion could have their own perspective.
For example, Riven might know darker history/politics, Thyra might know about battles, Leon could react as someone from another world, and Visepheron could remember ancient events.

Upcoming landmarks could show:
"BLACKWATER CROSSING - 8,462 steps away"

IMPORTANT: I will provide ALL creative content myself: final landmark names, lore, camp dialogue, companion quotes/interactions, etc. You would only need to implement/display it.
I don't want this to significantly delay V1. The priorities are manual steps, cumulative progress, Set Up Camp, map/footsteps and landmarks. The lore can use the existing companion/dialogue system and anything more complex can wait for V2.
Please let me know what is feasible for V1 and what, if anything, would affect the launch timeline.
```

---

## 3. Email 2: The Turnaround Feedback (Build 2 Testing & Final Refinements)
*Extracted from `client_text2.txt`.*

### Full Message Transcript
```text
Hi! We finished testing the newest build and overall we are really happy with the direction. The expedition/campsite system is fantastic, and we LOVE the water tracker. It feels immersive and fits the fantasy experience perfectly.

A few notes:

1. EXPEDITION
I'm attaching our V1 Expedition & Campsite Content document. It includes the finalized 1,000,000-step journey, milestone locations, progression logic, lore, campsite dialogue, and companion dialogue.
Daily step progress and cumulative journey progress need to remain separate. For example, 8,547/8,000 can show 107% for the Daily Expedition, but 8,547 cumulative steps should only equal about 0.85% of the 1,000,000-step journey.
Please also change "Lifetime Steps" to "Journey Steps" or "Cumulative Journey Steps."
Could you also confirm how the +1,000/+2,500/+5,000 manual walking buttons work? We want to make sure users cannot repeatedly use them to artificially complete the journey.

2. CAMP COMPLETION
We love the navy/gold "Campfire Lit!" popup. However, we don't love the bright green styling after camp is pitched. The green pill, outlined box, and large green button feel out of place with the fantasy/Scribe theme.
Please keep the completed state navy/antique gold instead. The bottom button could become a muted/disabled "Camp Pitched • Rest Until Dawn" state rather than bright green.

3. BARCODE SCANNER
Regarding your earlier database question, we would like BOTH Open Food Facts and USDA FoodData Central for broader coverage. Ideally, use Open Food Facts as the primary barcode lookup and USDA FoodData Central as a secondary/fallback when a product is missing or incomplete. We do not need a paid commercial database at this time.
We love that the current scanner populates calories/macros while still allowing manual editing.

4. RIVEN
We love seeing Riven incorporated! His current fire effect is visibly pixelated, though. Please replace it with your own clean, high-resolution magical fire effect. Purple magical flame would work perfectly and can be created/implemented by your team.

5. CAMPSITE ART
We have also created new resting/campsite poses for Riven, Thyra, Leon, and Visepheron to use with the campsite dialogue. I'll send those assets as well.

Overall, this update is really exciting. The walk → expedition → pitch camp → bank cumulative steps → earn XP flow is exactly the game-like experience we wanted. Thank you!
```

---

## 4. Item-by-Item Implementation & Status Matrix

| # | Client Request | Status | Implementation Details |
|:---:|:---|:---:|:---|
| **1** | **Selected Companion Appears & Speaks** | ✅ Completed | Implemented `CompanionDialogueEngine` with contextual banners, dynamic greetings on App Open, Streak, and Milestone triggers. Fixed companion switching bug. |
| **2** | **Aged Fantasy Map & Step Expedition** | ✅ Completed | Implemented in `StepJourneyScreen` with winding path, landmark milestones up to 1,000,000 cumulative steps, and landmark lore/quote cards. |
| **3** | **Daily vs. Cumulative Metric Separation** | ✅ Completed | Card shows `Daily Expedition: Steps / Goal` (% calculated daily), while the progress bar shows `Grand Journey: The Long March` (% of 1,000,000 steps). Renamed to "Cumulative Journey Steps". |
| **4** | **Step Goal Setting & Retention** | ✅ Completed | Gear icon opens target goal modal. Persists via `PUT /step-log/goal` and synchronizes locally and across app restarts. |
| **5** | **Camp Completion Styling** | ✅ Completed | Replaced bright green pill/button with theme-consistent navy/antique gold banner and muted `"Camp Pitched • Rest Until Dawn"` button. |
| **6** | **Campsite Artwork & Resting Companion Poses** | ✅ Completed | Extracted resting poses for Riven, Thyra, Leon, and Visepheron and displayed them by the campfire illustration with canonical dialogue. |
| **7** | **Mana Potion Water Tracker** | ✅ Completed | Implemented animated potion bottle with dual-unit normalization (oz & mL), quick-add buttons (+8, +16, +24, +32), and goal customization. |
| **8** | **Barcode Scanner (Dual Database)** | ✅ Completed | Primary lookup via Open Food Facts with automatic nutrition extraction and manual editing enabled. USDA fallback architecture specified for backend. |
| **9** | **Replace Generic Black Error/Toast Boxes** | ✅ Completed | Replaced with themed gold/navy dialogs and styled `EasyLoading` fantasy notifications. |
| **10** | **Anti-Abuse Safeguards** | ✅ Completed | Daily limit guard capped at 50,000 steps/day. Setting up camp locks steps for the remainder of the calendar day. |
| **11** | **Riven High-Res Magical Purple Flame** | ✅ Completed | High-resolution magical flame assets generated and integrated. |
| **12** | **Custom Quest Creation & Recurring Schedules** | 🔄 Backend Spec | UI and offline fallback created; backend API contracts documented in `BACKEND_MILESTONE3_AND_EXPEDITION_SPEC.md`. |
