-- ============================================================
-- I-Fridge — Migration 011: Nutrition Logging
-- ============================================================
-- Daily calorie and macro tracking.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.nutrition_logs (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    meal_type         TEXT NOT NULL DEFAULT 'snack',  -- breakfast, lunch, dinner, snack
    food_items        JSONB NOT NULL DEFAULT '[]',
    total_calories    INT DEFAULT 0,
    total_protein_g   REAL DEFAULT 0,
    total_carbs_g     REAL DEFAULT 0,
    total_fat_g       REAL DEFAULT 0,
    notes             TEXT,
    logged_at         TIMESTAMPTZ DEFAULT now(),
    created_at        TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nutrition_user ON public.nutrition_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_nutrition_date ON public.nutrition_logs(logged_at DESC);

-- RLS
ALTER TABLE public.nutrition_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own nutrition" ON public.nutrition_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can log nutrition" ON public.nutrition_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own logs" ON public.nutrition_logs FOR DELETE USING (auth.uid() = user_id);

-- Daily calorie goal on users table
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS daily_calorie_goal INT DEFAULT 2000;
