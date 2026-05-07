"""Deep audit: recipes, ingredients, and how they relate."""
import json
from app.db.supabase_client import get_supabase

db = get_supabase()

# 1. Count recipes
recipes = db.table("recipes").select("id, title, ingredients, steps").execute()
print(f"=== RECIPES: {len(recipes.data)} total ===")

# 2. Check recipe_ingredients table existence
try:
    ri = db.table("recipe_ingredients").select("*").limit(5).execute()
    print(f"\n=== RECIPE_INGREDIENTS TABLE: {len(ri.data)} rows (showing 5) ===")
    for row in ri.data[:5]:
        print(f"  {row}")
except Exception as e:
    print(f"\n=== RECIPE_INGREDIENTS TABLE: DOES NOT EXIST ===")
    print(f"  Error: {e}")

# 3. Count canonical ingredients
ings = db.table("ingredients").select("id, canonical_name, display_name_en").execute()
print(f"\n=== INGREDIENTS TABLE: {len(ings.data)} canonical entries ===")

# 4. Check recipe_translations
try:
    rt = db.table("recipe_translations").select("*").limit(5).execute()
    print(f"\n=== RECIPE_TRANSLATIONS: {len(rt.data)} rows (showing 5) ===")
    for row in rt.data[:5]:
        print(f"  recipe_id={row.get('recipe_id')}, lang={row.get('language_code')}, title={row.get('title_translated','')[:50]}")
except Exception as e:
    print(f"\n=== RECIPE_TRANSLATIONS: Error: {e}")

# 5. Examine how ingredients are stored in recipes
print("\n=== RECIPE INGREDIENTS FORMAT (sample) ===")
for r in recipes.data[:3]:
    print(f"\nRecipe: {r['title']}")
    ings_data = r.get('ingredients', [])
    if isinstance(ings_data, str):
        ings_data = json.loads(ings_data)
    print(f"  Type: {type(ings_data).__name__}, Count: {len(ings_data) if ings_data else 0}")
    if ings_data:
        for ing in ings_data[:3]:
            print(f"    {ing}")

# 6. Extract ALL unique ingredient names used across all recipes
all_recipe_ingredients = set()
for r in recipes.data:
    ings_data = r.get('ingredients', [])
    if isinstance(ings_data, str):
        ings_data = json.loads(ings_data)
    if ings_data:
        for ing in ings_data:
            if isinstance(ing, dict):
                name = ing.get('name', ing.get('ingredient', ''))
            elif isinstance(ing, str):
                name = ing
            else:
                name = str(ing)
            if name:
                all_recipe_ingredients.add(name.strip().lower())

print(f"\n=== UNIQUE INGREDIENT NAMES IN RECIPES: {len(all_recipe_ingredients)} ===")
# Show first 30
for name in sorted(all_recipe_ingredients)[:30]:
    print(f"  {name}")
print(f"  ... ({len(all_recipe_ingredients)} total)")

# 7. Check how many recipe ingredients match canonical
canonical_names = {i['canonical_name'] for i in db.table("ingredients").select("canonical_name").execute().data}
en_names = {i['display_name_en'].strip().lower() for i in db.table("ingredients").select("display_name_en").execute().data if i.get('display_name_en')}

matched = all_recipe_ingredients & (canonical_names | en_names)
unmatched = all_recipe_ingredients - (canonical_names | en_names)

print(f"\n=== MATCHING ANALYSIS ===")
print(f"  Matched to canonical DB: {len(matched)}/{len(all_recipe_ingredients)}")
print(f"  UNMATCHED (not in DB):   {len(unmatched)}")
if unmatched:
    for name in sorted(unmatched)[:30]:
        print(f"    ❌ {name}")
