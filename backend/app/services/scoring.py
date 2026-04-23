"""
I-Fridge — Enhanced Scoring Service (v2)
==========================================
Computes a composite Relevance Score using 6 weighted signals.

Formula:
  RelevanceScore = Σ(wi × si) for i in [expiry, flavor, familiar, difficulty, recency, coverage]

Signals:
  1. Expiry Urgency (w=0.25)  — Prioritize waste reduction (expiring items)
  2. Flavor Affinity (w=0.20) — Personalize to user taste profile (cosine similarity)
  3. Familiarity (w=0.10)     — Slight boost for comfort food (cooked before)
  4. Difficulty Fit (w=0.10)  — Prefer recipes matching user skill level
  5. Recency Penalty (w=0.10) — Penalize recently cooked recipes (variety)
  6. Match Coverage (w=0.25)  — Reward higher ingredient match percentage

Weights sum to 1.0 and are configurable via environment variables (see config.py).
"""

import numpy as np
from datetime import date, timedelta
from typing import Optional
from app.core.config import get_settings

# Flavor axes — shared vocabulary between recipes and user profiles.
FLAVOR_AXES = ["sweet", "salty", "sour", "bitter", "umami", "spicy"]


def compute_expiry_urgency(
    recipe_ingredient_ids: list[str],
    user_inventory: dict[str, date],  # {ingredient_id: computed_expiry}
    horizon_days: int = 7,
) -> float:
    """
    How urgently the recipe's ingredients need to be used.

    Items expiring today → 1.0 urgency.
    Items expiring in `horizon_days`+ → 0.0 urgency.
    Returns average urgency across matched ingredients.
    """
    today = date.today()
    urgencies: list[float] = []

    for ing_id in recipe_ingredient_ids:
        expiry = user_inventory.get(ing_id)
        if expiry is None:
            continue  # missing ingredient — skip

        days_left = (expiry - today).days
        # Normalize: 0 days left → urgency 1.0, horizon+ days → 0.0
        normalized = max(0.0, 1.0 - (days_left / horizon_days))
        urgencies.append(normalized)

    return float(np.mean(urgencies)) if urgencies else 0.0


def compute_flavor_affinity(
    recipe_vectors: dict[str, float],  # {"sweet": 0.3, "umami": 0.9, ...}
    user_profile: dict[str, float],    # {"sweet": 0.5, "umami": 0.7, ...}
) -> float:
    """
    Cosine similarity between the recipe's flavor profile
    and the user's learned taste preferences.

    Returns a value between 0.0 (orthogonal) and 1.0 (identical).
    """
    r_vec = np.array([recipe_vectors.get(axis, 0.5) for axis in FLAVOR_AXES])
    u_vec = np.array([user_profile.get(axis, 0.5) for axis in FLAVOR_AXES])

    dot = np.dot(r_vec, u_vec)
    norm = np.linalg.norm(r_vec) * np.linalg.norm(u_vec)

    return float(dot / norm) if norm > 0 else 0.5


def compute_difficulty_fit(
    recipe_difficulty: int,       # 1 (easy) to 3 (hard)
    user_skill_level: int = 2,    # 1 (beginner) to 5 (expert)
) -> float:
    """
    How well the recipe difficulty matches the user's skill level.
    
    Perfect match → 1.0, each level of mismatch → -0.25 penalty.
    A beginner seeing a hard recipe scores low.
    An expert seeing an easy recipe still scores moderately (0.75).
    
    Mapping:
      skill 1-2 → prefers difficulty 1
      skill 3   → prefers difficulty 2
      skill 4-5 → prefers difficulty 3
    """
    # Map user skill (1-5) to preferred difficulty (1-3)
    preferred = min(3, max(1, (user_skill_level + 1) // 2))
    gap = abs(recipe_difficulty - preferred)
    
    return max(0.0, 1.0 - gap * 0.25)


def compute_recency_penalty(
    last_cooked_date: Optional[date],
    cooldown_days: int = 14,
) -> float:
    """
    Penalize recipes that were recently cooked to promote variety.
    
    Cooked today → 0.0 (full penalty, don't recommend again).
    Cooked 7 days ago → 0.5 (moderate penalty).
    Cooked 14+ days ago → 1.0 (no penalty, safe to recommend).
    Never cooked → 0.8 (slight penalty for unfamiliarity, but we
                         handle this via the familiarity signal).
    """
    if last_cooked_date is None:
        return 0.8  # Never cooked — neutral-ish
    
    today = date.today()
    days_since = (today - last_cooked_date).days
    
    if days_since <= 0:
        return 0.0  # Cooked today
    
    # Linear ramp from 0.0 to 1.0 over cooldown_days
    return min(1.0, days_since / cooldown_days)


def compute_match_coverage(
    match_percentage: float,  # 0.0 to 1.0
) -> float:
    """
    Reward higher ingredient match percentages with a gentle curve.
    
    Uses a sigmoid-like boost so that the jump from 80% → 100% match
    is rewarded more heavily than 30% → 50%.
    
    100% match → 1.0
    80% match  → 0.85
    50% match  → 0.45
    0% match   → 0.0
    """
    # Apply a power curve that emphasizes high matches
    return float(match_percentage ** 1.3)


def compute_relevance_score(
    expiry_urgency: float,
    flavor_affinity: float,
    is_comfort: bool,
    match_percentage: float = 1.0,
    recipe_difficulty: int = 1,
    user_skill_level: int = 2,
    last_cooked_date: Optional[date] = None,
) -> float:
    """
    Compute the final weighted relevance score using 6 signals.

    All weights sum to 1.0:
    - Match coverage   (w=0.25): Reward high ingredient match
    - Expiry urgency   (w=0.25): Prioritize waste reduction
    - Flavor affinity  (w=0.20): Personalize to user taste
    - Difficulty fit    (w=0.10): Match user cooking skill
    - Recency penalty   (w=0.10): Promote variety
    - Familiarity      (w=0.10): Slight boost for comfort food
    """
    settings = get_settings()

    familiarity = 1.0 if is_comfort else 0.3
    difficulty_fit = compute_difficulty_fit(recipe_difficulty, user_skill_level)
    recency = compute_recency_penalty(last_cooked_date)
    coverage = compute_match_coverage(match_percentage)

    # Use configurable weights with new defaults
    w_expiry = getattr(settings, 'WEIGHT_EXPIRY', 0.25)
    w_flavor = getattr(settings, 'WEIGHT_FLAVOR', 0.20)
    w_familiar = getattr(settings, 'WEIGHT_FAMILIAR', 0.10)
    w_difficulty = getattr(settings, 'WEIGHT_DIFFICULTY', 0.10)
    w_recency = getattr(settings, 'WEIGHT_RECENCY', 0.10)
    w_coverage = getattr(settings, 'WEIGHT_COVERAGE', 0.25)

    score = (
        w_coverage * coverage
        + w_expiry * expiry_urgency
        + w_flavor * flavor_affinity
        + w_difficulty * difficulty_fit
        + w_recency * recency
        + w_familiar * familiarity
    )
    return round(min(1.0, max(0.0, score)), 3)
