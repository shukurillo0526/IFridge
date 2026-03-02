-- ============================================================
-- I-Fridge — Migration 006: Data Hardening
-- ============================================================
-- 1. Add updated_at columns + triggers to shopping_list, meal_plan
-- 2. Tighten ingredients INSERT policy (service role only)
-- 3. Add unique constraint on inventory to prevent duplicates
-- 4. Add composite index for state-based queries
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. Add updated_at to shopping_list and meal_plan
-- ────────────────────────────────────────────────────────────

-- Shopping List
ALTER TABLE public.shopping_list
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();

DROP TRIGGER IF EXISTS trg_shopping_updated_at ON public.shopping_list;
CREATE TRIGGER trg_shopping_updated_at
    BEFORE UPDATE ON public.shopping_list
    FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- Meal Plan
ALTER TABLE public.meal_plan
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();

DROP TRIGGER IF EXISTS trg_meal_plan_updated_at ON public.meal_plan;
CREATE TRIGGER trg_meal_plan_updated_at
    BEFORE UPDATE ON public.meal_plan
    FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- ────────────────────────────────────────────────────────────
-- 2. Tighten ingredients INSERT policy
-- ────────────────────────────────────────────────────────────
-- Remove the overly permissive policy that allows any auth user to insert.
-- Ingredients should only be created via the backend (service role key).

DROP POLICY IF EXISTS "ingredients_auth_insert" ON public.ingredients;

-- ────────────────────────────────────────────────────────────
-- 3. Prevent duplicate inventory entries
-- ────────────────────────────────────────────────────────────
-- A user shouldn't have two separate rows for the same ingredient
-- in the same location. If they add "Milk" to "Fridge" twice,
-- the second add should update quantity instead.
-- Note: This is a UNIQUE index, not a constraint, so it's safe
-- if duplicates already exist (they'll just block new inserts).

CREATE UNIQUE INDEX IF NOT EXISTS idx_inventory_unique_item
    ON public.inventory_items(user_id, ingredient_id, location);

-- ────────────────────────────────────────────────────────────
-- 4. Additional performance indexes
-- ────────────────────────────────────────────────────────────

-- State-based inventory queries (e.g., "show all frozen items")
CREATE INDEX IF NOT EXISTS idx_inventory_user_state
    ON public.inventory_items(user_id, item_state);

-- Ingredient name text search (for autocomplete)
CREATE INDEX IF NOT EXISTS idx_ingredients_name_trgm
    ON public.ingredients USING GIN(display_name_en gin_trgm_ops);
