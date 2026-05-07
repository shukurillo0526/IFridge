-- Migration: 010_translation_system
-- Description: Enhanced recipe translation system with status tracking,
--              quality feedback, retry logic, and batch support.

-- 1. Drop old translation table and recreate with full columns
DROP TABLE IF EXISTS public.recipe_translations CASCADE;

CREATE TABLE public.recipe_translations (
    recipe_id          UUID NOT NULL REFERENCES public.recipes(id) ON DELETE CASCADE,
    language_code      TEXT NOT NULL,
    title              TEXT NOT NULL,
    short_description  TEXT,                                          -- For recipe cards in list view
    ingredients        JSONB NOT NULL DEFAULT '[]'::jsonb,            -- [{name, quantity, unit, prep_note}]
    steps              JSONB NOT NULL DEFAULT '[]'::jsonb,            -- [{step_number, text, timer_seconds}]
    translation_method TEXT NOT NULL DEFAULT 'ai_direct',             -- ai_direct | ai_glossary | human | community
    translation_status TEXT NOT NULL DEFAULT 'pending',               -- pending | completed | failed
    quality_score      NUMERIC(3,2),                                  -- 0.00-1.00 from user feedback
    retry_after        TIMESTAMPTZ,                                   -- Don't retry failed translations until this
    translated_at      TIMESTAMPTZ DEFAULT now(),
    PRIMARY KEY (recipe_id, language_code)
);

-- 2. RLS — everyone can read, only service role writes
ALTER TABLE public.recipe_translations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "translations_read_all"
    ON public.recipe_translations FOR SELECT USING (true);

-- 3. Indexes for fast lookups
CREATE INDEX idx_translations_lang
    ON public.recipe_translations(language_code);

CREATE INDEX idx_translations_status
    ON public.recipe_translations(translation_status);

CREATE INDEX idx_translations_recipe_lang
    ON public.recipe_translations(recipe_id, language_code);
