-- ============================================================
-- I-Fridge — Migration 009: Recipe Enhancements
-- ============================================================
-- Adds timer data, tools, and temperature to recipe steps.
-- Adds calorie and prep note fields to recipes.
-- ============================================================

-- Enhanced recipe step fields
ALTER TABLE recipe_steps ADD COLUMN IF NOT EXISTS timer_seconds INT;
ALTER TABLE recipe_steps ADD COLUMN IF NOT EXISTS timer_auto_start BOOLEAN DEFAULT FALSE;
ALTER TABLE recipe_steps ADD COLUMN IF NOT EXISTS tools_needed TEXT[];
ALTER TABLE recipe_steps ADD COLUMN IF NOT EXISTS temperature_c INT;

-- Recipe-level enhancements
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS calories_per_serving INT;
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS prep_notes TEXT[];  -- mise en place instructions
