# iFridge — Quick Start Checklist

> Run these steps to get iFridge running locally with full AI support.
> The app **auto-detects** its environment — no URL switching needed:
> - `flutter run -d Chrome` → uses **localhost:8000** (local Ollama AI)
> - GitHub Pages → uses **Railway production backend**

---

## 🔧 One-Time Setup (First Time Only)

### 1. Install Python Dependencies

```powershell
cd d:\dev\projects\iFridge\backend
pip install -r requirements.txt
```

### 2. Pull AI Models

```powershell
ollama pull qwen2.5vl:7b
ollama pull qwen3:8b
ollama pull nomic-embed-text
ollama pull gemma3:12b
```

### 3. Install Flutter Dependencies

```powershell
cd d:\dev\projects\iFridge\frontend
flutter pub get
```

---

## 🚀 Running Locally (3 Terminals)

### Terminal 1: Ollama (AI Server)

```powershell
ollama serve
```

> Leave this running. If it says "already running", that's fine — skip to Terminal 2.

---

### Terminal 2: Backend (FastAPI)

```powershell
cd d:\dev\projects\iFridge\backend
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

> Wait until you see `Uvicorn running on http://0.0.0.0:8000`. Leave it running.

---

### Terminal 3: Frontend (Flutter)

```powershell
cd d:\dev\projects\iFridge\frontend
flutter run -d Chrome

or

flutter build apk --debug 2>&1 | Select-Object -Last 12
```

---

## ✅ Quick Verify

After all 3 are running, open Chrome and check:

| URL | Expected |
|-----|----------|
| `http://localhost:8000/` | `{"name": "I-Fridge Intelligence API", "version": "3.4.0", ...}` |
| `http://localhost:8000/api/v1/health/ping` | `{"status": "ok", ...}` |
| `http://localhost:8000/api/v1/health` | Full dependency health report (Supabase, Ollama) |
| `http://localhost:8000/api/v1/ai/status` | Shows which AI models are loaded |
| `http://localhost:8000/docs` | Interactive Swagger API docs |
| Flutter app | Should load the Living Shelf after login |

---

## 🌐 How Environment Auto-Detection Works

The API URL is **automatic** — you never need to edit `api_service.dart`:

| Running From | Browser Host | Backend Used | AI Available |
|-------------|-------------|-------------|-------------|
| `flutter run -d Chrome` | `localhost` | `http://localhost:8000` | ✅ Local Ollama |
| GitHub Pages | `*.github.io` | Railway production URL | ⚠️ Railway (no local Ollama) |

The logic lives in `frontend/lib/core/services/api_service.dart`:

```dart
static String get baseUrl {
  if (kIsWeb) {
    final host = Uri.base.host;
    if (host != 'localhost' && host != '127.0.0.1') {
      return _productionUrl;  // GitHub Pages → Railway
    }
  }
  return _localUrl;  // Local dev → localhost:8000
}
```

> **No more commenting/uncommenting URLs before pushing to GitHub!**

---

## 🧠 AI Models (RTX 5070 Ti — 16GB VRAM)

The backend uses these local AI models via Ollama:

| Model | Size | Role |
|-------|------|------|
| `qwen2.5vl:7b` | 6.0 GB | Vision (multimodal) — scans receipts, detects ingredients, calorie photos |
| `qwen3:8b` | 5.2 GB | Text LLM — recipe generation, tips, ingredient subs, YouTube extraction |
| `nomic-embed-text` | 274 MB | Embeddings — semantic search (runs on CPU) |
| `gemma3:12b` | 8.1 GB | Fallback — multimodal backup if qwen2.5vl unavailable |

---

## 🏗️ Backend Architecture (v3.4.0)

```
Request → CORS → RequestIdMiddleware → InputValidationMiddleware → Router → Response
                 ↓                      ↓
           X-Request-ID           Body size check
           X-Response-Time        UUID validation
                 ↓
         Structured JSON logs with request_id correlation
```

### Middleware Stack
| Layer | Purpose |
|-------|---------|
| `CORSMiddleware` | Allows Flutter origins |
| `RequestIdMiddleware` | Injects `X-Request-ID`, measures `X-Response-Time` |
| `InputValidationMiddleware` | 10MB body limit, UUID format validation |
| `register_error_handlers` | Standardized error envelopes with request IDs |

### Key Services
| Service | Purpose |
|---------|---------|
| `recommendation_engine.py` | 6-signal composite scoring (expiry, flavor, familiarity, difficulty, recency, coverage) |
| `youtube_intelligence.py` | Extracts structured recipes from YouTube video metadata |
| `flavor_learning.py` | EMA-based flavor profile auto-learning on cook events |
| `expiry_prediction.py` | Smart expiry with storage/packaging factors + visual freshness |
| `ollama_service.py` | Local LLM interface (text, vision, embeddings, streaming) |

---

## 📡 API Endpoints Overview

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/health` | Deep health check (Supabase + Ollama + latency) |
| GET | `/api/v1/health/ping` | Lightweight liveness probe |
| GET | `/api/v1/ai/status` | AI model status |
| POST | `/api/v1/ai/generate-recipe` | Generate recipe from ingredients |
| POST | `/api/v1/ai/substitute` | AI ingredient substitution |
| POST | `/api/v1/ai/cooking-tip` | Get cooking tips for a step |
| POST | `/api/v1/ai/youtube-recipe` | Extract recipe from YouTube metadata |
| POST | `/api/v1/ai/shopping-list` | Smart shopping list generation |
| POST | `/api/v1/ai/parse-raw` | Parse raw recipe text |
| POST | `/api/v1/ai/normalize-recipe` | Convert terse steps to detailed steps |
| GET | `/api/v1/recommendations/{user_id}` | Server-side scored recommendations |
| POST | `/api/v1/user/init` | Initialize new user |
| GET | `/api/v1/user/{user_id}/dashboard` | Full user profile data |
| POST | `/api/v1/user/cook` | Record cook event (triggers flavor learning) |
| POST | `/api/v1/user/engagement` | Track video likes/saves/views |
| POST | `/api/v1/ai/chat` | Multi-turn kitchen assistant (SSE streaming) |
| POST | `/api/v1/inventory/predict-expiry` | Smart expiry prediction (category + storage + packaging) |
| POST | `/api/v1/inventory/assess-freshness` | Visual freshness score from ingredient photo |
| POST | `/api/v1/calories/analyze-image` | Analyze food photo for calories |
| POST | `/api/v1/calories/analyze` | Estimate calories for food items |
| GET | `/api/v1/calories/daily/{user_id}` | Daily nutrition summary |

> Full interactive docs at `http://localhost:8000/docs`

---

## 🔄 If Things Break

| Problem | Fix |
|---------|-----|
| `No module named uvicorn` | Run `pip install -r requirements.txt` in the `backend` folder |
| Backend won't start | Make sure Python deps are installed (see above) |
| AI returns mock data | Check `ollama serve` is running in Terminal 1 |
| "Couldn't load inventory" | Backend not running, or check Terminal 2 for errors |
| Hot reload not working | Press `R` (capital) in Terminal 3 for hot restart |
| Flutter `pub get` fails | Enable Developer Mode: `start ms-settings:developers` |
| Wrong backend URL | Should be automatic now — check `ApiConfig` in `api_service.dart` |
| Health check returns 503 | Supabase connection issue — check `.env` credentials |
| `X-Request-ID` missing | Ensure `RequestIdMiddleware` is registered in `main.py` |
