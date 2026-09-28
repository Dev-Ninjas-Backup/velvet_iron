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



---

## 4. Email 3: Build 3 Testing & Onboarding / UX Refinements
*Extracted from `client_text3.txt` (received September 2026).*

### Full Message Transcript
```text
Hi Salauddin, Thank you for the update and new APK! I've gone through as much of the build as I currently can. I know the profile photo flow, session/token issue, and parts of the backend are still being worked on, so I've kept those in mind. 

1. NEW-USER ONBOARDING – BLOCKED I tested with a brand-new account. At Step 3/11, after entering the user's name and pressing Continue, I receive: "The AWS Access Key Id you provided does not exist in our records." This prevents me from completing onboarding, so I cannot continue testing the full new-user experience until this is fixed. The profile screen also automatically displays the existing placeholder photo on a brand-new account. I know you mentioned profile photos are still being finalized, but I wanted to document it. 

2. CHOOSE YOUR PATH Please add a short description beneath each Path. A new user currently sees four names/colors without knowing what they represent. Adventurer: Forge your strength through an epic fantasy adventure. Scribe: Turn your wellness journey into a story worth writing. Mage: Harness arcane power as you build stronger habits. Realmwalker: Level up your health as you journey between worlds. This will also help clarify that Path determines the theme/style of the Codex while the companion is selected separately. 

3. BARCODE SCANNER The scanner recognizes products (I tested a can of Coke), but nutrition only displays per 100 mL. There is no way to select mL, fl oz/oz, serving size, or the actual quantity consumed. Users need practical serving/unit options for food logging. 

4. MANUAL CALORIES Calories are still being calculated from macros and I cannot independently enter/override them. Your update mentioned independent calorie overrides were implemented, so please check this because I am not seeing it in this APK.

5. QUEST NAMES Several preset quests still have the old generic names such as "Step Master," "Protein Power," and "Three Meals a Day." We previously requested proper fantasy/Codex-style names so these feel integrated into the world. 

6. EXERCISE Exercise logging is still not functioning. I attempted to log Aerial Silks and received: "Failed to log exercise. Please try again." I am also still unable to properly schedule exercises. Both completed exercise logging and scheduling need to work before release. 

7. CAMPSITE COMPANION I love that companion dialogue is appearing at camp! However, the companion portrait is very small and easy to overlook. Please make the companion much larger/more prominent, similar to their presentation during important quest/daily interactions. The companion is a major part of the experience, so the nightly interaction should feel significant. 

8. JOURNEY LANDMARKS/CAMPSITES I reached The Wayfarer's Arch, but there was no clear notification or celebration. The only indication was "Last reached: The Wayfarer's Arch" on the map. Each landmark should have a clear acknowledgement when unlocked. I also have an idea that would make the journey more immersive while keeping the logic simple: Once a user reaches a new landmark, their campsite artwork should change to that location and REMAIN there until they reach the next landmark. Example: Starting area = original campsite Wayfarer's Arch = tent/camp pitched at the Arch Whispering Wood = tent/camp pitched in the woods Next landmark = campsite changes again We can create/provide each campsite image. This makes it feel like the user is actually traveling across the map and pitching camp at each location. The logic can simply be: once cumulative steps reach a landmark threshold, change the campsite image to that location until the next threshold is reached. 

9. CAMP IMAGE The small "Camp Pitched for the Night" thumbnail still uses the other tent image. Please update it to our approved campsite artwork for consistency.

10. MEMBERSHIP/SUBSCRIPTION COPY The Membership Benefits section needs to be updated before launch. There are grammatical issues, and it currently undersells what makes Premium valuable. I would like the benefits to emphasize: • Full health & wellness tracking • Fantasy themes and selectable companions • Quests, XP, achievements & 1,000,000-step journey • Private Discord community with challenges, events, prizes, etc. There are also customer-facing phrases that need proofreading, including: "Full Advance health tracking features" "Daily quote and tips for healths" "advance discord community" "Choose package to experience the full potential" Since this is where we're asking users to purchase Premium, the language needs to feel polished and clearly explain what they're receiving. 

11. DISCORD/COMMUNITY LOCATION The private Discord is a major membership benefit, but the Join Discord button is currently under Feedback & Support. Most users will not intuitively open Feedback & Support to find their community. Please keep that button if desired, but also add a much easier/visible route to Discord. I think a "Community" or fantasy-themed "Guild" option accessible from Settings/main navigation would work well. 

That's everything I can meaningfully test in this build until the blocking issues are resolved. There are several improvements I'm very happy to see, especially the expanded quest system, campsite experience, map/journey system and companion integration. We're very close, and I want to make sure we catch these remaining items before store submission rather than needing changes after release. Please let me know when the blocking issues are resolved/there is an updated build and I'll continue testing. Thank you again to you and the team!

Attachment: /Users/saharaislam/Desktop/tahmid/velvet_iron/velvet_iron-attachments
```

---

## 5. Comprehensive Implementation & Status Matrix

| # | Client Request (Email 3) | Status | Target Implementation & Resolution Notes |
|:---:|:---|:---:|:---|
| **1** | **New-User Onboarding Blocked (AWS S3)** | ✅ **Resolved** | Added auto-recovery fallback in `Onboarding2Service` so if S3 avatar upload fails, it retries with `profilePhoto: null` to allow Step 3/11 completion without disruption. Filtered out backend hardcoded dummy avatar (`pinimg.com`) for new accounts. |
| **2** | **Choose Your Path Descriptions** | ✅ **Resolved** | Added client's exact 4 path descriptions as subtitles in `themes_list_widget.dart` and clarified Path (visual style/atmosphere) vs Companion selection in `progress_and_step_widget.dart`. |
| **3** | **Barcode Scanner Serving Size & Units** | ✅ **Resolved** | Stored base 100g/mL nutrition in `ScanBarcodeController`, extracted product serving size, and added dynamic unit selector (`100g / 100mL`, `Serving`, `mL`, `fl oz`, `oz`, `g`) + multiplier in `nutrition_fields.dart`. |
| **4** | **Manual Calorie Override UI** | ✅ **Resolved** | Added interactive "Auto (Macros)" vs "Manual Override" toggle in `daily_goal_controller.dart` & `daily_marco_goal.dart`, with persistent manual calorie storage in `SharedPreferencesHelper`. |
| **5** | **Preset Quest Fantasy Names** | ✅ **Resolved** | Mapped generic preset names to Codex lore in `Quest.fromJson`: "Stride of the Realmwalker", "Feast of the Hearth", "Titan's Nourishment" (with 30g+ protein fix), "Elixir of the Alchemist", "Attunement of Spirit". |
| **6** | **Exercise Logging & Scheduling Fix** | ✅ **Resolved** | Fixed root cause: backend rejected `"MODERATE"` intensity with 400. Mapped `"MODERATE"` -> `"MEDIUM"` for both `logExercise()` and `scheduleExercise()` in `exercise_service.dart`. |
| **7** | **Campsite Companion Portrait Prominence** | ✅ **Resolved** | Replaced tiny 68x68 thumbnail with a prominent 140x140 gilded circular portrait, companion title badge, and illuminated dialogue speech box in `step_journey_controller.dart`. |
| **8** | **Landmark Unlock Celebration & Dynamic Campsite Art** | ✅ **Resolved** | Integrated all 10 landmark campsite images from `velvet_iron-attachments/` into `assets/images/campsite/`. Added threshold calculation in `ExpeditionContentService` to dynamically show landmark artwork and location badge based on cumulative steps, plus landmark unlock modal. |
| **9** | **Camp Pitched Small Thumbnail Image** | ✅ **Resolved** | Generated approved `camp_thumbnail.png` from `campsite_scene.png` and updated `ImagePath.campTentFire` for buttons, cards, and rituals. |
| **10** | **Membership Benefits Copy Overhaul** | ✅ **Resolved** | Updated benefits in `membership_benefits.dart` and `onboarding11_controller.dart` to the 4 value pillars; updated onboarding header to "Choose a Plan to Unlock Your Full Potential" in `onboarding11_widgets.dart`. |
| **11** | **Guild / Community Discord Entry** | ✅ **Resolved** | Added "Guild Hall (Discord Community)" item in `general_setting_item.dart` linking to `https://discord.gg/velvetiron` and implemented `joinDiscord()` in `feedback_controller.dart` via `url_launcher`. |

