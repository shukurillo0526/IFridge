-- ============================================================
-- I-Fridge — Migration 003: Shopping List & Meal Plan
-- ============================================================
-- Adds the two tables that the Profile Screen queries but
-- which were never formally migrated.
-- Run in the Supabase SQL Editor.
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. Shopping List
-- ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.shopping_list (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    ingredient_name TEXT NOT NULL,
    quantity        NUMERIC(10,2) DEFAULT 1,
    unit            TEXT DEFAULT 'pcs',
    is_purchased    BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_shopping_user
    ON public.shopping_list(user_id);

-- RLS
ALTER TABLE public.shopping_list ENABLE ROW LEVEL SECURITY;

CREATE POLICY "shopping_owner" ON public.shopping_list
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- 2. Meal Plan
-- ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.meal_plan (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    recipe_id     UUID REFERENCES public.recipes(id) ON DELETE SET NULL,
    planned_date  DATE NOT NULL,
    meal_type     TEXT DEFAULT 'dinner',   -- breakfast | lunch | dinner | snack
    notes         TEXT,
    created_at    TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_user_date_meal UNIQUE (user_id, planned_date, meal_type)
);

CREATE INDEX IF NOT EXISTS idx_meal_plan_user_date
    ON public.meal_plan(user_id, planned_date);

-- RLS
ALTER TABLE public.meal_plan ENABLE ROW LEVEL SECURITY;

CREATE POLICY "meal_plan_owner" ON public.meal_plan
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
