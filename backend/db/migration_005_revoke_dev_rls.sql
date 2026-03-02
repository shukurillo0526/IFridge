-- ============================================================
-- I-Fridge — Migration 005: Revoke Dev-Only RLS Policies
-- ============================================================
-- Removes the open-read policies created by dev_rls_fix.sql.
-- These allowed ALL authenticated users to read ALL rows,
-- violating per-user data isolation.
--
-- WARNING: After running this, only properly authenticated
-- users will see their own data. Ensure auth is working
-- before applying in production.
-- ============================================================

DROP POLICY IF EXISTS "inventory_dev_read" ON public.inventory_items;
DROP POLICY IF EXISTS "stats_dev_read"     ON public.gamification_stats;
DROP POLICY IF EXISTS "profile_dev_read"   ON public.user_flavor_profile;
DROP POLICY IF EXISTS "history_dev_read"   ON public.user_recipe_history;
DROP POLICY IF EXISTS "users_dev_read"     ON public.users;

-- ────────────────────────────────────────────────────────────
-- Verification: List remaining policies to confirm only
-- owner-based policies remain on user-scoped tables.
-- ────────────────────────────────────────────────────────────

SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
