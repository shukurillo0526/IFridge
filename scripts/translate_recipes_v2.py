"""
Plately — Recipe Translation Script (v2)
==========================================
Translates all recipes from English to KO, UZ, UZ_Cyrl, RU using qwen3:14b.
Writes to recipe_translations table with proper status tracking.

Usage:
  python translate_recipes_v2.py              # Translate missing only
  python translate_recipes_v2.py --force      # Re-translate everything
  python translate_recipes_v2.py --lang ko    # Single language only
"""

import asyncio
import os
import sys
import json
from pathlib import Path

# Add backend to path
backend_dir = Path(__file__).parent.parent / "backend"
sys.path.append(str(backend_dir))

from dotenv import load_dotenv
load_dotenv(backend_dir / ".env")

sys.stdout.reconfigure(encoding='utf-8')

from app.db.supabase_client import get_supabase
from app.services.ollama_service import get_ollama_service

# ── Culinary glossary — preserve these terms across languages ──
GLOSSARY = {
    "ko": {
        "gochujang": "고추장", "doenjang": "된장", "kimchi": "김치",
        "bibimbap": "비빔밥", "bulgogi": "불고기", "tteokbokki": "떡볶이",
        "japchae": "잡채", "samgyeopsal": "삼겹살", "ramen": "라면",
        "sashimi": "사시미", "teriyaki": "데리야키", "tempura": "튀김",
        "miso": "미소", "tofu": "두부", "udon": "우동",
    },
    "uz": {
        "plov": "palov", "samsa": "somsa", "lagman": "lagman",
        "manti": "manti", "shashlik": "shashlik", "naan": "non",
        "hummus": "hummus", "kebab": "kabob", "stroganoff": "stroganoff",
        "nuggets": "naggets", "teriyaki": "teriyaki", "sushi": "sushi",
        "pasta": "makaron", "burger": "burger", "steak": "steyk",
    },
    "uz_Cyrl": {
        "plov": "палов", "samsa": "сомса", "lagman": "лағмон",
        "manti": "манти", "shashlik": "шашлик", "naan": "нон",
        "hummus": "ҳуммус", "kebab": "кабоб", "stroganoff": "строганов",
        "nuggets": "наггетс", "teriyaki": "терияки", "sushi": "суши",
        "pasta": "макарон", "burger": "бургер", "steak": "стейк",
    },
    "ru": {
        "plov": "плов", "stroganoff": "строганов", "borsch": "борщ",
        "hummus": "хумус", "kebab": "кебаб", "teriyaki": "терияки",
        "sushi": "суши", "ramen": "рамен", "kimchi": "кимчи",
        "gochujang": "кочхуджан", "tofu": "тофу", "miso": "мисо",
        "nuggets": "наггетсы", "pasta": "паста", "burger": "бургер",
    },
}

LANG_NAMES = {
    "ko": "Korean (한국어)",
    "uz": "Uzbek Latin (O'zbekcha)",
    "uz_Cyrl": "Uzbek Cyrillic (Ўзбекча)",
    "ru": "Russian (Русский)",
}

MODEL = "qwen3:14b"


def build_prompt(title, description, ingredients, steps, lang):
    """Build a high-quality translation prompt with glossary context."""
    glossary = GLOSSARY.get(lang, {})
    glossary_str = "\n".join(f"  - {k} → {v}" for k, v in glossary.items()) if glossary else "  (none)"

    return f"""You are a professional culinary translator. Translate this recipe from English to {LANG_NAMES.get(lang, lang)}.

## RULES:
1. Keep all measurements EXACT (do not convert units)
2. Make cooking instructions sound natural, not machine-translated
3. Preserve cultural dish names — do NOT literally translate everything:
   - "Chicken Teriyaki Bowl" → keep "Teriyaki" as-is, translate "Chicken" and "Bowl"
   - "Beef Stroganoff" → keep "Stroganoff", translate "Beef"
   - "Hummus" → keep as "Hummus" (or use glossary form)
4. Use the glossary below for known culinary terms

## GLOSSARY for {lang}:
{glossary_str}

## SOURCE RECIPE:
Title: {title}
Description: {description or "N/A"}
Ingredients: {json.dumps(ingredients, ensure_ascii=False) if ingredients else "[]"}
Steps: {json.dumps(steps, ensure_ascii=False) if steps else "[]"}

## OUTPUT FORMAT (strict JSON only, no markdown):
{{
  "title": "translated title",
  "short_description": "1-2 sentence description in target language",
  "ingredients": {json.dumps([{"name": "...", "quantity": "number", "unit": "...", "prep_note": "..."}], ensure_ascii=False)},
  "steps": {json.dumps([{"step_number": 1, "text": "...", "timer_seconds": "null or number"}], ensure_ascii=False)}
}}

/no_think"""


async def main():
    force = "--force" in sys.argv
    lang_filter = None
    if "--lang" in sys.argv:
        idx = sys.argv.index("--lang")
        lang_filter = sys.argv[idx + 1] if idx + 1 < len(sys.argv) else None

    print("=" * 60)
    print("Plately Recipe Translator v2")
    print(f"Model: {MODEL}")
    print(f"Mode: {'FORCE re-translate' if force else 'Missing only'}")
    print(f"Languages: {lang_filter or 'all (ko, uz, uz_Cyrl, ru)'}")
    print("=" * 60)

    db = get_supabase()
    ollama = get_ollama_service()

    if not await ollama.is_available():
        print("❌ Ollama is not running. Start with: ollama serve")
        return

    models = await ollama.list_models()
    print(f"Available models: {models}")

    if not any(MODEL.split(":")[0] in m for m in models):
        print(f"⚠ {MODEL} not found. Pull it: ollama pull {MODEL}")
        print(f"  Will fall back to best available text model.")

    # Fetch all recipes with steps JSON
    response = db.table("recipes").select(
        "id, title, description, cuisine, difficulty, prep_time_minutes, steps"
    ).execute()
    recipes = response.data
    print(f"\n📖 Found {len(recipes)} recipes to translate.\n")

    # Also fetch recipe ingredients with names for better translation
    ri_response = db.table("recipe_ingredients").select(
        "recipe_id, quantity, unit, prep_note, ingredients(display_name_en)"
    ).execute()
    ri_by_recipe = {}
    for ri in ri_response.data:
        rid = ri["recipe_id"]
        ri_by_recipe.setdefault(rid, [])
        ing_name = ri.get("ingredients", {}).get("display_name_en", "Unknown") if ri.get("ingredients") else "Unknown"
        ri_by_recipe[rid].append({
            "name": ing_name,
            "quantity": ri.get("quantity", ""),
            "unit": ri.get("unit", ""),
            "prep_note": ri.get("prep_note", ""),
        })

    target_langs = [lang_filter] if lang_filter else ["ko", "uz", "uz_Cyrl", "ru"]

    # Stats
    total = 0
    translated = 0
    skipped = 0
    errors = 0

    for i, recipe in enumerate(recipes):
        recipe_id = recipe["id"]
        title = recipe["title"]
        description = recipe.get("description", "")
        ingredients = ri_by_recipe.get(recipe_id, [])
        steps = recipe.get("steps", [])

        for lang in target_langs:
            total += 1

            # Check if already translated
            if not force:
                existing = db.table("recipe_translations") \
                    .select("recipe_id") \
                    .eq("recipe_id", recipe_id) \
                    .eq("language_code", lang) \
                    .eq("translation_status", "completed") \
                    .execute()
                if existing.data:
                    skipped += 1
                    continue

            print(f"[{i+1}/{len(recipes)}] 🌐 '{title}' → {lang}...", end=" ", flush=True)

            prompt = build_prompt(title, description, ingredients, steps, lang)
            system = "You are a professional culinary translator. Return only valid JSON."

            try:
                result = await ollama.generate_text_json(
                    prompt,
                    system_prompt=system,
                    model=MODEL,
                )

                if "error" in result:
                    print(f"❌ {result['error']}")
                    errors += 1
                    continue

                translated_title = result.get("title", title)
                short_desc = result.get("short_description", "")
                translated_ingredients = result.get("ingredients", ingredients)
                translated_steps = result.get("steps", steps)

                # Upsert into recipe_translations
                row = {
                    "recipe_id": recipe_id,
                    "language_code": lang,
                    "title": translated_title,
                    "short_description": short_desc,
                    "ingredients": translated_ingredients,
                    "steps": translated_steps,
                    "translation_method": "ai_glossary",
                    "translation_status": "completed",
                }

                # Delete existing if force
                if force:
                    db.table("recipe_translations") \
                        .delete() \
                        .eq("recipe_id", recipe_id) \
                        .eq("language_code", lang) \
                        .execute()

                db.table("recipe_translations").upsert(row).execute()
                print(f"✅ '{translated_title}'")
                translated += 1

            except Exception as e:
                print(f"❌ Error: {e}")
                errors += 1

    print("\n" + "=" * 60)
    print(f"📊 RESULTS:")
    print(f"   Total:      {total}")
    print(f"   Translated: {translated}")
    print(f"   Skipped:    {skipped}")
    print(f"   Errors:     {errors}")
    print("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())
