"""Fix: insert 5 missing canonicals and re-link the 12 skipped recipe ingredients."""
import json
from app.db.supabase_client import get_supabase

db = get_supabase()

# 1. Insert missing ingredients
missing = [
    {"canonical_name": "hoisin_sauce",     "display_name_en": "Hoisin Sauce",     "display_name_ko": "호이신 소스", "display_name_uz": "Hoisin sousi",     "display_name_ru": "Хойсин соус",          "category": "condiment", "default_unit": "tbsp"},
    {"canonical_name": "balsamic_vinegar", "display_name_en": "Balsamic Vinegar", "display_name_ko": "발사믹 식초", "display_name_uz": "Balsam sirkasi",   "display_name_ru": "Бальзамический уксус", "category": "condiment", "default_unit": "tbsp"},
    {"canonical_name": "red_onion",        "display_name_en": "Red Onion",        "display_name_ko": "적양파",     "display_name_uz": "Qizil piyoz",      "display_name_ru": "Красный лук",          "category": "vegetable", "default_unit": "piece"},
    {"canonical_name": "mirin",            "display_name_en": "Mirin",            "display_name_ko": "미림",       "display_name_uz": "Mirin",            "display_name_ru": "Мирин",                "category": "condiment", "default_unit": "tbsp"},
    {"canonical_name": "chili_pepper",     "display_name_en": "Chili Pepper",     "display_name_ko": "고추",       "display_name_uz": "Achchiq qalampir", "display_name_ru": "Перец чили",            "category": "vegetable", "default_unit": "piece"},
]

for ing in missing:
    try:
        db.table("ingredients").insert(ing).execute()
        print(f"  ✅ Added: {ing['canonical_name']}")
    except Exception as e:
        if "duplicate" in str(e).lower() or "23505" in str(e):
            print(f"  ⏭ Already exists: {ing['canonical_name']}")
        else:
            print(f"  ❌ Failed: {ing['canonical_name']}: {e}")

# 2. Re-build lookup
existing = db.table("ingredients").select("id, canonical_name, display_name_en").execute()
canonical_to_id = {i["canonical_name"]: i["id"] for i in existing.data}
en_to_canonical = {}
for i in existing.data:
    if i.get("display_name_en"):
        en_to_canonical[i["display_name_en"].strip().lower()] = i["canonical_name"]

print(f"\nTotal ingredients now: {len(canonical_to_id)}")

# 3. The normalize map entries for the 12 skipped items
FIX_MAP = {
    "hoisin sauce": "hoisin_sauce",
    "balsamic vinegar": "balsamic_vinegar",
    "red onion": "red_onion",
    "mirin": "mirin",
    "thai chili": "chili_pepper",
    "green chili": "chili_pepper",
    "hot green pepper": "chili_pepper",
}

# 4. Find recipes that need fixing
recipes = db.table("recipes").select("id, title, ingredients").execute()
fixed = 0

for r in recipes.data:
    ings = r.get("ingredients", [])
    if isinstance(ings, str):
        ings = json.loads(ings)
    if not ings:
        continue
    
    for idx, ing in enumerate(ings):
        if isinstance(ing, dict):
            raw_name = ing.get("name", "").strip()
            quantity = ing.get("quantity")
            unit = ing.get("unit", "")
            prep_note = ing.get("prep_note", "")
        else:
            continue
        
        raw_lower = raw_name.lower()
        canonical = FIX_MAP.get(raw_lower)
        if not canonical:
            continue
        
        if canonical not in canonical_to_id:
            print(f"  ⚠ Still missing: {canonical}")
            continue
        
        ingredient_id = canonical_to_id[canonical]
        
        # Check if already linked
        check = db.table("recipe_ingredients").select("id").eq("recipe_id", r["id"]).eq("ingredient_id", ingredient_id).execute()
        if check.data:
            continue
        
        try:
            db.table("recipe_ingredients").insert({
                "recipe_id": r["id"],
                "ingredient_id": ingredient_id,
                "quantity": float(quantity) if quantity else None,
                "unit": unit or None,
                "prep_note": prep_note or None,
                "is_optional": False,
                "display_order": idx + 1,
            }).execute()
            fixed += 1
            print(f"  ✅ Linked: '{r['title']}' <- {raw_name} ({canonical})")
        except Exception as e:
            print(f"  ❌ {r['title']}: {e}")

print(f"\nFixed {fixed} links")

# 5. Final count
total = db.table("recipe_ingredients").select("id", count="exact").execute()
print(f"Total recipe_ingredients rows: {total.count}")
