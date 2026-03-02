-- ============================================================
-- I-Fridge — Gamification Stats Increment RPC
-- ============================================================
-- Called by GamificationRepository.completeCookingSession()
-- Atomically increments XP, meals cooked, items saved,
-- recalculates level, and manages daily streaks.
-- ============================================================

CREATE OR REPLACE FUNCTION public.increment_gamification_stats(
    p_user_id         UUID,
    p_xp_gain         INT DEFAULT 0,
    p_meals_gain      INT DEFAULT 0,
    p_items_saved_gain INT DEFAULT 0
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_new_xp        INT;
    v_new_level     SMALLINT;
    v_last_updated  DATE;
    v_new_streak    INT;
BEGIN
    -- 1. Get current stats
    SELECT xp_points, updated_at::DATE, current_streak
    INTO v_new_xp, v_last_updated, v_new_streak
    FROM public.gamification_stats
    WHERE user_id = p_user_id;

    -- If no row exists yet, initialize one
    IF NOT FOUND THEN
        INSERT INTO public.gamification_stats (user_id, xp_points, total_meals_cooked, items_saved, current_streak, longest_streak, level)
        VALUES (p_user_id, p_xp_gain, p_meals_gain, p_items_saved_gain, 1, 1, 1);
        RETURN;
    END IF;

    -- 2. Calculate new XP and level
    v_new_xp := v_new_xp + p_xp_gain;
    -- Level formula: level = floor(sqrt(xp / 100)) + 1, minimum 1
    v_new_level := GREATEST(1, FLOOR(SQRT(v_new_xp::NUMERIC / 100.0))::SMALLINT + 1);

    -- 3. Manage daily streak
    IF v_last_updated = CURRENT_DATE THEN
        -- Already updated today, don't increment streak again
        NULL;
    ELSIF v_last_updated = CURRENT_DATE - INTERVAL '1 day' THEN
        -- Consecutive day: increment streak
        v_new_streak := v_new_streak + 1;
    ELSE
        -- Streak broken: reset to 1
        v_new_streak := 1;
    END IF;

    -- 4. Atomic update
    UPDATE public.gamification_stats
    SET
        xp_points         = v_new_xp,
        level             = v_new_level,
        total_meals_cooked = total_meals_cooked + p_meals_gain,
        items_saved        = items_saved + p_items_saved_gain,
        current_streak     = v_new_streak,
        longest_streak     = GREATEST(longest_streak, v_new_streak),
        updated_at         = NOW()
    WHERE user_id = p_user_id;
END;
$$;
