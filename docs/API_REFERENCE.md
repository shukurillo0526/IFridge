# iFridge — API Reference (v3.4.0)

> Complete reference for all backend API endpoints.
> Interactive docs available at `http://localhost:8000/docs` (Swagger UI).

---

## 🏥 Health & Status

### `GET /api/v1/health`
Deep health check — tests all dependencies with latency.

**Response:** `200` (healthy/degraded) or `503` (unhealthy)
```json
{
  "status": "healthy",
  "version": "3.4.0",
  "timestamp": "2026-04-23T06:00:00Z",
  "services": {
    "supabase": {"status": "up", "latency_ms": 45.2},
    "ollama": {"status": "up", "latency_ms": 12.1, "models_loaded": ["qwen3:8b"]},
    "rate_limiter": {"status": "up"}
  }
}
```

### `GET /api/v1/health/ping`
Lightweight liveness probe (no dependency checks).

### `GET /api/v1/ai/status`
AI model availability and GPU info.

---

## 🤖 AI Endpoints

### `POST /api/v1/ai/generate-recipe`
Generate a recipe from available ingredients.

**Body:**
```json
{
  "ingredients": ["chicken breast", "rice", "soy sauce"],
  "cuisine": "Korean",
  "max_time_minutes": 30,
  "difficulty": 2,
  "servings": 2,
  "shelf_only": false
}
```

### `POST /api/v1/ai/substitute`
Get AI-suggested substitutes for a missing ingredient.

**Body:**
```json
{
  "ingredient": "heavy cream",
  "recipe_context": "Pasta carbonara"
}
```

### `POST /api/v1/ai/cooking-tip`
Get a cooking tip for a specific recipe step.

**Body:**
```json
{
  "step_text": "Sear the steak on high heat for 3 minutes per side",
  "question": "How do I know when to flip?"
}
```

### `POST /api/v1/ai/youtube-recipe`
Extract a structured recipe from YouTube video metadata.

**Body:**
```json
{
  "video_title": "Easy Korean Bibimbap Recipe",
  "video_description": "Ingredients: 2 cups rice, 200g beef...",
  "channel_name": "Maangchi",
  "youtube_id": "abc123def45"
}
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "is_recipe": true,
    "title": "Korean Bibimbap",
    "cuisine": "Korean",
    "difficulty": 2,
    "ingredients": [{"name": "rice", "quantity": 2, "unit": "cups"}],
    "steps": [{"step": 1, "text": "Cook rice..."}]
  }
}
```

### `POST /api/v1/ai/shopping-list`
Generate a consolidated shopping list from missing ingredients.

**Body:**
```json
{
  "user_id": "uuid",
  "recipe_ids": ["recipe-uuid-1", "recipe-uuid-2"]
}
```

**Response:** Category-grouped, deduplicated list with quantities.

### `POST /api/v1/ai/parse-raw`
Parse unstructured recipe text into structured format.

### `POST /api/v1/ai/normalize-recipe`
Convert terse recipe steps into detailed, beginner-friendly instructions.

---

## 📊 Recommendations

### `GET /api/v1/recommendations/{user_id}`
Server-side scored recipe recommendations using the 6-signal composite engine.

**Query Params:** `cuisine` (optional), `limit` (default: 50)

**Response:** Pre-tiered recipes with `relevance_score`, `match_pct`, `matched`, `missing`.

---

## 👤 User Data

### `POST /api/v1/user/init`
Initialize a new user (creates profile, gamification stats, flavor profile).

### `GET /api/v1/user/{user_id}/dashboard`
Single endpoint returning all user profile data (profile, stats, flavor, shopping list, meal plan).

### `PATCH /api/v1/user/profile`
Update user profile fields (display name, dietary tags, avatar).

### `POST /api/v1/user/cook`
Record that the user cooked a recipe. **Triggers flavor profile auto-learning.**

**Body:**
```json
{
  "user_id": "uuid",
  "recipe_id": "recipe-uuid"
}
```

### `POST /api/v1/user/engagement`
Track video engagement (like, unlike, save, unsave, view).

**Body:**
```json
{
  "user_id": "uuid",
  "video_id": "video-uuid",
  "action": "like"
}
```

---

## 🛒 Shopping List

### `POST /api/v1/user/shopping-list`
Add item to shopping list.

### `PATCH /api/v1/user/shopping-list/{item_id}`
Toggle purchased status.

### `DELETE /api/v1/user/shopping-list/{item_id}`
Delete item from shopping list.

---

## 📅 Meal Plan

### `POST /api/v1/user/meal-plan`
Plan a recipe for a specific date and meal type.

### `DELETE /api/v1/user/meal-plan/{meal_id}`
Remove a planned meal.

---

## 🔥 Nutrition

### `POST /api/v1/calories/analyze-image`
Upload a food photo — identifies items and estimates calories.

### `POST /api/v1/calories/analyze`
Estimate calories for a list of food items (DB lookup + AI fallback).

### `POST /api/v1/calories/log`
Log a meal to the user's daily nutrition tracker.

### `GET /api/v1/calories/daily/{user_id}`
Get daily nutrition summary (total calories, protein, carbs, fat).

---

## 🔍 Vision & Scanning

### `POST /api/v1/vision/detect`
Detect ingredients from a food photo using vision AI.

### `POST /api/v1/ocr/scan-receipt`
Scan a grocery receipt via OCR and extract purchased items.

### `GET /api/v1/barcode/lookup/{barcode}`
Look up product info from a barcode (Open Food Facts).

---

## 📐 Embeddings

### `POST /api/v1/embeddings/generate`
Generate embeddings for ingredient/recipe text.

### `POST /api/v1/embeddings/search`
Semantic similarity search using pgvector.

---

## 🔒 Error Envelope

All errors return a standardized format:

```json
{
  "status": "error",
  "code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "errors": ["body → ingredients: field required"],
  "request_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

| Code | HTTP | Description |
|------|------|-------------|
| `BAD_REQUEST` | 400 | Malformed request |
| `UNAUTHORIZED` | 401 | Missing/invalid auth |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 422 | Pydantic validation failure |
| `RATE_LIMITED` | 429 | Too many requests (10/min on AI endpoints) |
| `INTERNAL_ERROR` | 500 | Unhandled exception (traceback hidden) |
| `SERVICE_UNAVAILABLE` | 503 | Dependency down (Ollama, Supabase) |

---

## 🔑 Headers

| Header | Direction | Description |
|--------|-----------|-------------|
| `X-Request-ID` | Request/Response | Unique request correlation ID |
| `X-Response-Time` | Response | Request processing time (e.g., `45.2ms`) |
| `Content-Type` | Request | Must be `application/json` for POST/PUT/PATCH |
