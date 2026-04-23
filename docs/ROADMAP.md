# iFridge — Roadmap & Next Steps

> Tracks the evolution of iFridge from MVP to production-ready.
> Items marked ✅ have been completed. Remaining items are prioritized for future work.

---

## ✅ Completed — Optimization Roadmap (Sprints 1-5)

### Sprint 1: Security & Stability ✅
- ✅ SQL injection prevention — all queries use Supabase ORM/RPC
- ✅ Rate limiting — `slowapi` on all AI endpoints (10 req/min)
- ✅ API response standardization — `ApiResponse` envelope model

### Sprint 2: Algorithm Upgrades ✅
- ✅ 6-signal composite scoring (expiry, flavor, familiarity, difficulty, recency, coverage)
- ✅ Server-side recommendations — `/api/v1/recommendations/{user_id}` with client fallback
- ✅ AI ingredient substitution — "Swap" button on missing ingredients

### Sprint 3: UX & Performance ✅
- ✅ Onboarding flow — 3-step animated PageView for first-time users
- ✅ Recipe card redesign — glow border for ≥90% matches, relevance score bar
- ✅ Image caching — `cached_network_image` for recipe hero images
- ✅ iframe memory fix — auto-stop off-screen video playback

### Sprint 4: YouTube Intelligence ✅
- ✅ YouTube recipe extraction — `/api/v1/ai/youtube-recipe` via LLM
- ✅ Flavor profile auto-learning — EMA (α=0.15) on cook events
- ✅ Smart shopping list — `/api/v1/ai/shopping-list` (deduplicated, category-grouped)
- ✅ "I Cooked This" button — records cook + triggers flavor learning
- ✅ Video engagement tracking — persistent likes/saves/views

### Sprint 5: Scalability & Production ✅
- ✅ Request ID middleware — `X-Request-ID` + `X-Response-Time` tracing
- ✅ Input validation middleware — 10MB body limit, UUID format checks
- ✅ Structured JSON logging — request ID correlation
- ✅ Health checks — `/api/v1/health` (deep) + `/api/v1/health/ping` (liveness)
- ✅ Global error handlers — standardized error envelopes
- ✅ API documentation — enriched OpenAPI spec with tags

---

## 🔥 Priority 1: Critical Fixes & Polish

### 1.1 Seed the Recipes Table
- **Status:** ✅ Done — 100 recipes loaded with ingredients and steps.

### 1.2 Barcode Scanning
- **Status:** ✅ Done — wired into Scan screen via `mobile_scanner`.

### 1.3 User Authentication
- **Status:** ✅ Done — Supabase Auth with Google OAuth. Demo UUID replaced.

### 1.4 Expiry Notifications
- **Status:** ⏳ Pending — requires Supabase Edge Function + FCM push.
- **Action:** Implement a daily cron that queries items expiring within 2 days, sends push via FCM.

---

## ⚡ Priority 2: Feature Enhancements

### 2.1 Ingredient Image Database
- **Status:** Partially done (emoji icons work well). Full image URLs optional.
- **Options:** Unsplash API bulk-populate, Supabase Storage uploads, or AI-generated icons.

### 2.2 Shopping List Generation
- **Status:** ✅ Done — "Add to Shopping List" button on recipe detail, smart shopping list API, category grouping.

### 2.3 Meal Planning Calendar
- **Status:** ✅ Done — meal plan CRUD endpoints exist. Calendar view enhancement pending.

### 2.4 Multi-Language Support (i18n)
- **Status:** ✅ Done — English, Korean, Uzbek, Russian supported via `flutter_localizations`.

### 2.5 Share & Social Features
- **Status:** Partial — video feed with likes/bookmarks exists. Deep link sharing pending.

---

## 🧠 Priority 3: AI Upgrades

### 3.1 Conversational Kitchen Assistant
- **Status:** ✅ Done
- Persistent multi-turn chat via `/api/v1/ai/chat` with SSE streaming.
- Kitchen-aware system prompt with context injection (user inventory/recipes).
- Frontend `chatWithAssistant()` method in ApiService.

### 3.2 Smart Expiry Prediction (AI-Enhanced)
- **Status:** ✅ Done
- `expiry_prediction.py` with category-based shelf life, storage multipliers (freezer=6x, pantry=0.5x), packaging factors (+50% for sealed).
- `/api/v1/inventory/predict-expiry` endpoint.
- 12 unit tests covering all categories, storage, and packaging combinations.

### 3.3 Visual Freshness Detection
- **Status:** ✅ Done
- `/api/v1/inventory/assess-freshness` endpoint uses vision AI to score freshness (0.0-1.0) from photos.
- Returns visual cues, recommendation, days remaining estimate, and adjusted expiry date.

### 3.4 Personalized Nutrition Tracking
- **Status:** ✅ Done — calorie analysis (DB-first + AI fallback), daily nutrition logs, meal-type tracking.

### 3.5 Voice Commands
- **Status:** ✅ Done
- `speech_to_text` package with `VoiceCommandService` (intent parsing: recipe, shopping list, timer, assistant).
- `VoiceCommandFab` widget with pulsing mic animation, bottom-sheet AI replies.

---

## 🏗️ Priority 4: Architecture & Scale

### 4.1 State Management Upgrade
- **Status:** ✅ Done
- `flutter_riverpod` with `ProviderScope` wrapper.
- Providers: `inventoryProvider` (cache-first), `userProfileProvider`, `recommendationsProvider`, `shoppingListProvider`, `isOnlineProvider`.
- Screens can gradually migrate from `setState()` to `ConsumerWidget`.

### 4.2 Offline-First Architecture
- **Status:** ✅ Done
- `hive_flutter` cache service with 5 boxes (inventory, recipes, profile, sync_queue, meta).
- `connectivity_plus` auto-detects online/offline, flushes sync queue on reconnect.
- Cache-first strategy: show cached data instantly, refresh in background.

### 4.3 Cloud AI Migration
- **Status:** ✅ Done — `cloud_ai_service.py` with OpenAI GPT-4o-mini + Gemini 2.0 Flash.
- Automatic fallback chain: Ollama → Cloud AI → error.
- Activate by setting `OPENAI_API_KEY` or `GEMINI_API_KEY` in `.env`.

### 4.4 CI/CD Pipeline Expansion
- **Status:** ✅ Backend CI done — `.github/workflows/backend-tests.yml`
- 52 unit tests run on every push/PR to `main` (scoring, middleware, health, expiry)
- Flutter web deploy via GitHub Pages.

### 4.5 Analytics & Monitoring
- **Status:** ✅ Done — structured logging, health checks, and Sentry integration.
- Sentry: auto-activates when `SENTRY_DSN` is set in `.env` (both backend + frontend ready).
- PostHog/Mixpanel for user analytics remains optional future addition.

---

## 📊 Current Status (v3.5.0)

| Area | Status | Completeness |
|------|--------|-------------|
| Core Features | ✅ | 98% |
| AI Pipeline | ✅ | 95% |
| Security | ✅ | 95% |
| Performance | ✅ | 90% |
| Observability | ✅ | 90% |
| Testing | ✅ | 75% |
| CI/CD | ✅ | 70% |
| State Management | ✅ | 80% |
| Offline Support | ✅ | 85% |

---

## 🧪 Test Suite (52 tests, 0.88s)

| File | Tests | Coverage |
|------|-------|----------|
| `test_scoring.py` | 24 | 6-signal scoring engine (expiry, flavor, difficulty, recency, coverage, composite) |
| `test_middleware.py` | 9 | Request ID, timing, body size, UUID validation, error formatting |
| `test_health.py` | 7 | Root endpoint, ping, deep health, 404 envelope |
| `test_expiry.py` | 12 | Expiry prediction: categories, storage, packaging, shelf-stable, confidence |

Run locally: `cd backend && python -m pytest tests/ -v`

---

## 💡 Remaining Quick Wins

1. ⏳ FCM push notifications for expiring items (requires Firebase project + config)
2. ⏳ Migrate remaining `setState()` screens to `ConsumerWidget` (Riverpod providers are ready)
3. ⏳ Add `OPENAI_API_KEY` or `GEMINI_API_KEY` to `.env` to activate cloud AI fallback
4. ⏳ Add `SENTRY_DSN` to `.env` and `pip install sentry-sdk[fastapi]` to activate crash reporting
5. ⏳ PostHog/Mixpanel for user behavior analytics
