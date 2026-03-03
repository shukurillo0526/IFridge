"""
I-Fridge — Calorie Analysis Router
====================================
Analyzes food images to estimate calories and macros.
Uses local LLM (Ollama) for food identification + ingredient DB for calorie data.
"""

import json
import logging
from datetime import datetime
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional, List

from app.db.supabase_client import get_supabase
from app.services.ollama_service import get_ollama_service

logger = logging.getLogger("ifridge.calories")

router = APIRouter()


class CalorieAnalyzeRequest(BaseModel):
    """Analyze food items for calorie content."""
    food_items: List[str]  # list of food names detected from image or typed


class NutritionLogRequest(BaseModel):
    """Log a meal's nutrition."""
    user_id: str
    meal_type: str = "snack"  # breakfast, lunch, dinner, snack
    food_items: List[dict]   # [{name, quantity_g, calories, protein_g, carbs_g, fat_g}]
    notes: Optional[str] = None


@router.post("/api/v1/calories/analyze")
async def analyze_calories(req: CalorieAnalyzeRequest):
    """
    Estimate calories and macros for a list of food items.
    First checks ingredient DB for calories_per_100g, then falls back to AI.
    """
    db = get_supabase()
    results = []
    unknown_items = []

    for item_name in req.food_items:
        # Try DB lookup first
        match = (
            db.table("ingredients")
            .select("display_name_en, calories_per_100g, default_unit, category")
            .ilike("display_name_en", f"%{item_name}%")
            .limit(1)
            .execute()
        )

        if match.data and len(match.data) > 0 and match.data[0].get("calories_per_100g"):
            ing = match.data[0]
            cal = ing["calories_per_100g"]
            results.append({
                "name": ing["display_name_en"],
                "source": "database",
                "calories_per_100g": cal,
                "estimated_serving_g": _estimate_serving(ing.get("category", "")),
                "estimated_calories": round(cal * _estimate_serving(ing.get("category", "")) / 100),
                "category": ing.get("category"),
            })
        else:
            unknown_items.append(item_name)

    # For items not in DB, use AI to estimate
    if unknown_items:
        ollama = get_ollama_service()
        if await ollama.is_available():
            prompt = f"""Estimate the nutrition for these food items: {', '.join(unknown_items)}.

For each item, provide:
- Typical serving size in grams
- Calories per 100g
- Estimated calories for one serving
- Macros per serving (protein_g, carbs_g, fat_g)

Return JSON only:
{{"items": [{{"name": "...", "serving_g": 150, "calories_per_100g": 200, "estimated_calories": 300, "protein_g": 10, "carbs_g": 30, "fat_g": 15}}]}}"""

            system = "You are a certified nutritionist. Provide accurate calorie estimates. Return only valid JSON."
            ai_result = await ollama.generate_text_json(prompt, system_prompt=system)

            if "items" in ai_result:
                for item in ai_result["items"]:
                    item["source"] = "ai_estimate"
                    results.append(item)

    # Calculate totals
    total_calories = sum(r.get("estimated_calories", 0) for r in results)

    return {
        "status": "success",
        "items": results,
        "total_estimated_calories": total_calories,
        "item_count": len(results),
    }


@router.post("/api/v1/calories/log")
async def log_nutrition(req: NutritionLogRequest):
    """Log a meal to the user's daily nutrition tracker."""
    db = get_supabase()

    try:
        total_cal = sum(item.get("calories", 0) for item in req.food_items)
        total_protein = sum(item.get("protein_g", 0) for item in req.food_items)
        total_carbs = sum(item.get("carbs_g", 0) for item in req.food_items)
        total_fat = sum(item.get("fat_g", 0) for item in req.food_items)

        db.table("nutrition_logs").insert({
            "user_id": req.user_id,
            "meal_type": req.meal_type,
            "food_items": json.dumps(req.food_items),
            "total_calories": total_cal,
            "total_protein_g": total_protein,
            "total_carbs_g": total_carbs,
            "total_fat_g": total_fat,
            "notes": req.notes,
            "logged_at": datetime.now().isoformat(),
        }).execute()

        return {"status": "success", "total_calories": total_cal}

    except Exception as e:
        logger.error(f"[Calories] Log failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/api/v1/calories/daily/{user_id}")
async def get_daily_nutrition(user_id: str, date: Optional[str] = None):
    """Get a user's nutrition summary for a specific date."""
    db = get_supabase()

    target_date = date or datetime.now().strftime("%Y-%m-%d")

    try:
        logs = (
            db.table("nutrition_logs")
            .select("*")
            .eq("user_id", user_id)
            .gte("logged_at", f"{target_date}T00:00:00")
            .lte("logged_at", f"{target_date}T23:59:59")
            .order("logged_at")
            .execute()
        )

        total_cal = sum(log.get("total_calories", 0) for log in logs.data)
        total_protein = sum(log.get("total_protein_g", 0) for log in logs.data)
        total_carbs = sum(log.get("total_carbs_g", 0) for log in logs.data)
        total_fat = sum(log.get("total_fat_g", 0) for log in logs.data)

        return {
            "date": target_date,
            "meals": logs.data,
            "totals": {
                "calories": total_cal,
                "protein_g": total_protein,
                "carbs_g": total_carbs,
                "fat_g": total_fat,
            },
            "goal": 2000,  # default daily goal, can be user-specific later
        }

    except Exception as e:
        logger.error(f"[Calories] Daily fetch failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


def _estimate_serving(category: str) -> int:
    """Estimate a typical serving size in grams based on category."""
    cat = category.lower()
    serving_map = {
        "vegetable": 150, "fruit": 130, "protein": 150, "meat": 150,
        "seafood": 120, "dairy": 200, "grain": 80, "baking": 30,
        "seasoning": 5, "condiment": 15, "oil": 15, "legume": 100,
        "nut": 30, "beverage": 250, "snack": 50,
    }
    return serving_map.get(cat, 100)
