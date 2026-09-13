# Velvet & Iron - Subscription & RevenueCat Play Store Setup Guide

This guide documents what has already been completed and the exact steps to take next once your Google Play Console owner completes the Merchant Account setup.

---

## 1. What Is Already Completed

1. **Google Cloud Service Account:**
   - Account: `revenuecat-billing@velvetand-iron-training-mhr8qv.iam.gserviceaccount.com`
   - Key file (`.json`) generated and downloaded.

2. **Google Play Console Permissions (Step 2):**
   - Service account invited to Google Play Console with:
     - *View app information (read-only)*
     - *View financial data*
     - *Manage orders and subscriptions*
   - Associated with app **Velvet & Iron** (`com.velvet.velvetiron`).

3. **RevenueCat Current Configuration (Step 3 - Test Store):**
   - Entitlement: `premium` (Display name: *Premium Access*)
   - Offering: `default`
     - Package `$rc_monthly` -> `velvet_iron_monthly`
     - Package `$rc_annual` -> `velvet_iron_annual`
   - Flutter app code matches this setup 100%.

---

## 2. What To Do Next

### Phase 1: Wait for Console Owner (Merchant Account)
- **Status:** Pending with Account Owner.
- **Action Needed:** The account owner must complete the **Google Payments merchant account** (bank and tax details) under Google Play Console settings.
- **Result:** This will remove the lock on **Monetize with Play → Products → Subscriptions**.

---

### Phase 2: Create Subscriptions in Google Play Console (Step 1)
Once the Subscriptions page is unlocked:

1. In **Google Play Console**, go to **Velvet & Iron** → **Monetize with Play** → **Products** → **Subscriptions**.
2. **Monthly Subscription:**
   - Click **Create subscription**
   - **Subscription ID:** `velvet_iron_monthly`
   - **Name:** `Velvet & Iron Premium (Monthly)`
   - Under **Base plans**, click **Add base plan**:
     - **Base plan ID:** `monthly-plan`
     - **Type:** Auto-renewing
     - **Billing period:** 1 month
     - **Price:** Set price (e.g. $9.99)
     - Click **Save** → click **Activate** on the base plan.
3. **Annual Subscription:**
   - Click **Create subscription**
   - **Subscription ID:** `velvet_iron_annual`
   - **Name:** `Velvet & Iron Premium (Annual)`
   - Under **Base plans**, click **Add base plan**:
     - **Base plan ID:** `annual-plan`
     - **Type:** Auto-renewing
     - **Billing period:** 1 year
     - **Price:** Set price (e.g. $119.99)
     - Click **Save** → click **Activate** on the base plan.

---

### Phase 3: Link Google Play Products in RevenueCat
Currently, your products in RevenueCat are listed under **"Test Store"**. Now link the live Play Store products:

1. In [RevenueCat Dashboard](https://app.revenuecat.com/):
2. Go to **Project Settings (⚙️) → Apps → Android app**:
   - Ensure the Google Play service account JSON key from Phase 1 is uploaded under **Google Play Store credentials**.
3. Go to **Product Catalog → Products**:
   - Click **+ New product** (or Product editor):
     - App: **Velvet & Iron (Android)**
     - Identifier: `velvet_iron_monthly`
   - Click **+ New product**:
     - App: **Velvet & Iron (Android)**
     - Identifier: `velvet_iron_annual`
4. Go to **Product Catalog → Entitlements → `premium`**:
   - Click **Attach** and add the newly created Google Play products to the `premium` entitlement.
5. In **Product Catalog → Offerings → `default`**:
   - Verify that packages `$rc_monthly` and `$rc_annual` have the Google Play products attached.

---

### Phase 4: Switch `.env` to Production RevenueCat API Key
1. In RevenueCat Dashboard, go to **Project Settings (⚙️) → API Keys**.
2. Under **Public App-Specific API Keys**, copy your **Android** public key (starts with `goog_...`).
3. Open your project's `.env` file:
   ```properties
   REVENUECAT_API_KEY=goog_your_production_key_here
   ```
   *(Replaces the test key `test_eAAuBIVWkeTdvPgUekqqIJqEfpi`).*

---

### Phase 5: Build & Release `.aab` to Production
Because your developer account is an **Organization account**, you do not have the 20-tester requirement and can publish directly:

1. Build the release App Bundle:
   ```bash
   flutter build appbundle --release
   ```
2. Upload `build/app/outputs/bundle/release/app-release.aab` to **Production** (or **Internal testing**) in Google Play Console.
3. Once approved, subscriptions and in-app purchases will be live!

---

## 3. Quick Identifier Reference Table

| Item | Identifier in App / RevenueCat / Play Store |
| :--- | :--- |
| **Package Name** | `com.velvet.velvetiron` |
| **Monthly Subscription ID** | `velvet_iron_monthly` |
| **Annual Subscription ID** | `velvet_iron_annual` |
| **Entitlement ID** | `premium` |
| **Default Offering** | `default` |
| **Monthly Package ID** | `$rc_monthly` |
| **Annual Package ID** | `$rc_annual` |
| **Service Account** | `revenuecat-billing@velvetand-iron-training-mhr8qv.iam.gserviceaccount.com` |
