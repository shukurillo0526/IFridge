# iFridge VISION: The Master Blueprint

This document serves as the comprehensive master blueprint for the **iFridge Ecosystem**. It details the journey from a personal smart-kitchen utility to a revolutionary three-sided food commerce marketplace. It encompasses the core philosophy, current technical implementation, business strategy, architecture, and the roadmap for upcoming phases.

---

## 1. Executive Summary & Core Philosophy

**The Problem:** The modern food experience is heavily fragmented. Consumers use one app for grocery tracking, another for finding recipes, a third for ordering delivery, and restaurants use entirely separate, expensive Point-of-Sale (POS) and delivery tablet systems. This fragmentation leads to food waste, high costs for consumers, and punishing 30%+ commission rates for restaurants.

**The iFridge Solution:** iFridge is a unified ecosystem that bridges the gap between the home kitchen and the commercial restaurant. By owning the "demand engine" (the consumer's daily habit of deciding what to eat), iFridge naturally funnels highly engaged users into a localized, low-commission commerce platform.

We are building a **Three-Sided Marketplace**:
1. **Consumers (iFridge App):** The demand engine. Users manage home inventory, discover AI-tailored recipes, and seamlessly order pickup/delivery from local restaurants using the exact same app.
2. **Restaurants (iFridge Business):** The supply side. A digital suite allowing restaurants to manage menus, process incoming mobile/kiosk orders without cashiers, and engage with the community.
3. **Drivers (iFridge Fleet - Planned):** The logistics network. A shared delivery fleet that any restaurant on the platform can utilize, reducing overhead and breaking reliance on high-commission third-party apps.

---

## 2. Current Implementation Status (What Is Live Today)

The foundation of the platform is fully implemented, deployed, and operational. The app features a seamless "Dual-Mode" interface, allowing users to toggle between **Cook Mode** and **Order Mode**.

### 2.1 Consumer App: Cook Mode (Home Kitchen Intelligence)
The original core of iFridge, representing a state-of-the-art smart kitchen assistant:
* **Smart Inventory Management:** Users can add ingredients via barcode scanning, manual entry, or by taking photos of loose ingredients/grocery receipts. The system utilizes Gemini 1.5 Flash and local Vision models to automatically extract items, sizes, and predict expiry dates based on category algorithms.
* **Social-Style Recipe Feeds:** A TikTok-style vertical video feed and categorized horizontal feeds ("For You", "Use It Up", "Explore").
* **6-Signal Recommendation Engine:** Recipes are scored using a highly advanced algorithm factoring in: Expiry Urgency, Flavor Affinity (Cosine Similarity), Difficulty Fit, Recency Penalties, and Inventory Match Coverage.
* **Local AI Integration:** Powered by an on-device/local Ollama service (`qwen2.5:3b`, `moondream`), the app can generate custom recipes based *only* on what's in the fridge, suggest ingredient substitutions, and offer live cooking tips during the interactive step-by-step cooking tutorial.

### 2.2 Consumer App: Order Mode (Food Commerce)
The newest expansion, bringing the "Luckin Coffee" mobile-ordering model to life:
* **Cart Service (`cart_service.dart`):** A robust in-memory singleton handling item additions, quantity management, special instructions, and restaurant binding (auto-clearing if a user switches restaurants mid-order).
* **Frictionless Checkout (`checkout_screen.dart`):** A streamlined review screen with dynamic toggles for Pickup vs. Delivery, subtotal calculations, and immediate API submission.
* **Order Tracking (`order_history_screen.dart`):** Generates human-readable Pickup Codes (e.g., `AB742`). The "My Orders" interface separates active and past orders, featuring dynamic visual progress bars tracking the order's exact lifecycle state.

### 2.3 Restaurant Suite: iFridge Business
Built directly into the existing application, unlocked for verified business accounts:
* **Creator Studio & Analytics:** Restaurants can upload promotional video shorts (reels) directly into the consumer "Explore" feeds, tracking views, likes, and engagement.
* **Live Order Management (`incoming_orders_page.dart`):** A dedicated 3-tab POS interface (New, Preparing, Ready). Staff view incoming orders with full details and advance the status with a single tap, instantly updating the consumer's tracking screen.

### 2.4 The Backend & Infrastructure
A production-hardened API serving the mobile clients:
* **FastAPI Backend:** Python 3.12 server handling AI routing, OCR parsing, recommendation scoring, and order processing. Features strict rate limiting, input validation, and request-tracing middleware.
* **Supabase Data Layer:** PostgreSQL database handling Auth, inventory, user data, and the newly implemented `orders` table. Features strict Row Level Security (RLS) policies, JSONB document storage for flexible order items, and optimized RPC functions.

---

## 3. Technical Architecture Deep-Dive

iFridge is built on a modern, highly scalable technology stack designed for both rapid iteration and production stability.

| Layer | Technologies Used | Purpose |
| :--- | :--- | :--- |
| **Frontend UI** | Flutter (Dart), Material 3 | Single codebase for iOS, Android, and Web. Highly animated, glassmorphic UI. |
| **State Management** | Riverpod, setState | Reactive UI updates and dependency injection. |
| **Local Storage** | Hive (NoSQL) | Offline-first caching for inventory, recipes, and user preferences. |
| **Backend API** | FastAPI (Python), Uvicorn | High-performance async REST API. Handles complex business logic and AI routing. |
| **Database & Auth** | Supabase (PostgreSQL) | Primary data store, JWT authentication, and Row Level Security. |
| **AI (Cloud)** | Google Gemini 1.5 Flash | Heavy-lifting Vision AI (complex receipt OCR). |
| **AI (Local/Edge)** | Ollama (`qwen3:8b`, `moondream`) | Privacy-first, zero-cost AI for recipe generation, chat, and simple vision tasks. |
| **Embeddings** | `nomic-embed-text`, `pgvector` | Semantic search and personalized recipe matching based on user flavor profiles. |

---

## 4. Business Strategy & Competitive Advantage

### The Revenue Model
The ecosystem monetizes through multiple diversified streams:
1. **Transaction Commissions:** A flat, radically low 3-5% commission on pickup/delivery orders (compared to the industry standard 30%).
2. **SaaS Subscriptions:** Monthly fees for restaurants to access advanced analytics, automated marketing tools, and Kiosk software licenses.
3. **Hardware Sales (Future):** One-time sales or leasing of iFridge Kiosk hardware (tablets, stands, thermal printers).
4. **Delivery Fees (Future):** Flat per-delivery fees charged to restaurants and consumers to pass through to the shared iFridge Fleet drivers.

### The Flywheel Effect (Our Moat)
iFridge's unique advantage is that it is a **daily utility** (Cook Mode) combined with a **transactional marketplace** (Order Mode).
* *More consumers* using the app for home cooking builds massive localized demand.
* *High demand* attracts restaurants eager for a lower-commission platform.
* *More restaurants* provide more dining choices, keeping consumers inside the app ecosystem.
* *High order volume* makes the upcoming shared delivery fleet viable, further lowering costs for restaurants.

---

## 5. The Strategic Roadmap

With Phase P (Marketplace Foundation) complete, the following phases are prioritized:

### Phase 2: Payments, Real-Time & Polish (Q3 2026)
* **Payment Gateway:** Integration with Stripe/Click/Payme for secure in-app checkout and automated restaurant payouts.
* **Real-Time WebSockets:** Upgrading order tracking to use Supabase Realtime subscriptions, eliminating pull-to-refresh.
* **Push Notifications:** Firebase Cloud Messaging (FCM) integration to alert users when food is ready and alert restaurants to new orders.

### Phase 3: Hardware & Kiosk Expansion (Q4 2026)
* **iFridge Kiosk App:** Developing a locked-down, full-screen web/tablet application for in-store self-service ordering.
* **Hardware Integrations:** Local network integration with standard ESC/POS thermal receipt printers and Kitchen Display Systems (KDS).

### Phase 4: Shared Logistics (Q1 2027)
* **iFridge Fleet App:** Launching a dedicated Flutter app for delivery drivers.
* **Dispatch Algorithm:** Building the backend routing engine to match "Ready" orders with the nearest available drivers based on GPS data.

### Phase 5: Advanced Analytics & B2B Scaling (Q2 2027+)
* **Restaurant Insights:** AI-driven demand forecasting, peak-hour heatmaps, and dynamic menu pricing suggestions.
* **B2B Expansion:** White-labeling the POS and Kiosk software for franchise adoption.
