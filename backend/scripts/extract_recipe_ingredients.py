"""
Phase 1: Extract all recipe ingredient names, normalize them,
and produce a mapping to canonical ingredient names.
"""
import json, re
from collections import Counter
from app.db.supabase_client import get_supabase

db = get_supabase()

# 1. Get all recipes
recipes = db.table("recipes").select("id, title, ingredients").execute()
print(f"Total recipes: {len(recipes.data)}")

# 2. Extract every ingredient name
raw_names = []
recipe_ingredient_map = {}  # recipe_id -> [{name, quantity, unit, prep_note}]

for r in recipes.data:
    ings = r.get("ingredients", [])
    if isinstance(ings, str):
        ings = json.loads(ings)
    items = []
    for ing in (ings or []):
        if isinstance(ing, dict):
            name = ing.get("name", ing.get("ingredient", "")).strip()
        elif isinstance(ing, str):
            name = ing.strip()
        else:
            continue
        if name:
            raw_names.append(name)
            items.append({
                "raw_name": name,
                "quantity": ing.get("quantity") if isinstance(ing, dict) else None,
                "unit": ing.get("unit", "") if isinstance(ing, dict) else "",
                "prep_note": ing.get("prep_note", "") if isinstance(ing, dict) else "",
            })
    recipe_ingredient_map[r["id"]] = items

# 3. Count unique names (case-insensitive)
name_counts = Counter(n.lower() for n in raw_names)
unique_names = sorted(name_counts.keys())
print(f"Total ingredient mentions: {len(raw_names)}")
print(f"Unique ingredient names: {len(unique_names)}")

# 4. Get existing canonical ingredients
existing = db.table("ingredients").select("id, canonical_name, display_name_en").execute()
canonical_map = {}  # canonical_name -> id
en_map = {}         # display_name_en.lower() -> canonical_name

for ing in existing.data:
    canonical_map[ing["canonical_name"]] = ing["id"]
    if ing.get("display_name_en"):
        en_map[ing["display_name_en"].strip().lower()] = ing["canonical_name"]

# 5. Build normalization rules
# Map raw recipe strings -> canonical_name
NORMALIZE_MAP = {
    # ── Already matched in pass 1 ──
    "all-purpose flour": "all_purpose_flour",
    "active dry yeast": "yeast",
    "anchovy broth or water": "anchovy",
    "anchovy or dashima broth": "anchovy",
    "arborio rice": "rice",
    "asian pear or apple": "pear",
    "baby spinach": "spinach",
    "baguette": "bread",
    "beef broth": "beef_broth",
    "beef chuck": "beef",
    "beef or lamb": "beef",
    "beef sirloin": "beef_steak",
    "beer or sparkling water": "beer",
    "bell peppers": "bell_pepper",
    "black beans": "black_bean",
    "boiling water": "water",
    "broth from meat": "beef_broth",
    "brown lentils": "lentils",
    "butter beans (lima beans)": "beans",
    "butter or lamb fat": "butter",
    "butter or oil": "butter",
    "canned chickpeas": "chickpea",
    "canned crushed tomatoes": "canned_tomato",
    "canned diced tomatoes": "canned_tomato",
    "canned navy beans": "beans",
    "canned white beans": "beans",
    "carrots": "carrot",
    "cayenne pepper": "cayenne_pepper",
    "chashu pork or chicken": "pork",
    "cherry tomatoes": "cherry_tomato",
    "chicken broth": "chicken_broth",
    "chicken breasts": "chicken_breast",
    "chicken drumsticks": "chicken_drumstick",
    "chicken thighs": "chicken_thigh",
    "chili paste (gochugaru or red pepper flakes)": "korean_chili_flakes",
    "cinnamon sticks": "cinnamon",
    "cocoa powder or chocolate": "cocoa_powder",
    "cold water": "water",
    "cooking oil or ghee": "cooking_oil",
    "corn kernels": "corn",
    "cornstarch slurry": "cornstarch",
    "cooked white rice": "rice",
    "cream cheese (softened)": "cream_cheese",
    "cream cheese block": "cream_cheese",
    "cumin powder": "cumin",
    "cumin seeds": "cumin",
    "dark soy sauce": "soy_sauce",
    "dashima (kelp)": "dashima",
    "dried chili peppers": "chili_flakes",
    "dried lasagna noodles": "pasta",
    "dried red chili peppers": "chili_flakes",
    "dry red wine": "wine",
    "dry white wine": "wine",
    "egg noodles": "pasta",
    "eggs": "egg",
    "extra-firm tofu": "firm_tofu",
    "feta cheese": "feta",
    "fish sauce (optional)": "fish_sauce",
    "flat-leaf parsley": "parsley",
    "fresh ginger": "ginger",
    "fresh parsley": "parsley",
    "fresh spinach": "spinach",
    "fresh thyme": "thyme",
    "garlic cloves": "garlic",
    "garlic powder": "garlic_powder",
    "ginger paste": "ginger",
    "gochugaru (korean red pepper flakes)": "korean_chili_flakes",
    "gochujang (korean chili paste)": "gochujang",
    "graham cracker crumbs": "breadcrumbs",
    "green beans": "green_beans",
    "green bell pepper": "bell_pepper",
    "green or brown lentils": "lentils",
    "green onions": "green_onion",
    "ground beef": "ground_beef",
    "ground beef or lamb": "ground_beef",
    "ground chicken or turkey": "ground_chicken",
    "ground cinnamon": "cinnamon",
    "ground cloves": "cloves",
    "ground cumin": "cumin",
    "ground lamb": "lamb",
    "ground pork": "ground_pork",
    "ground turmeric": "turmeric",
    "heavy cream or coconut cream": "heavy_cream",
    "hot water": "water",
    "instant noodles": "ramen_noodles",
    "italian sausage": "sausage",
    "jasmine or basmati rice": "jasmine_rice",
    "kimchi": "kimchi",
    "korean radish (mu) or daikon": "daikon",
    "lamb chops": "lamb_ribs",
    "lamb leg or shoulder": "lamb_leg",
    "lamb shoulder": "lamb_shoulder",
    "large eggs": "egg",
    "lemon juice": "lemon_juice",
    "lemon zest": "lemon",
    "lettuce leaves": "lettuce",
    "lime juice": "lime",
    "long grain rice": "rice",
    "low-sodium soy sauce": "soy_sauce",
    "mixed vegetables": "mixed_vegetables",
    "napa cabbage": "cabbage",
    "olive oil or butter": "olive_oil",
    "onions": "onion",
    "orange zest": "orange",
    "panko breadcrumbs": "panko",
    "peanut butter": "peanut_butter",
    "peanuts (crushed)": "peanuts",
    "pickled radish": "radish",
    "plain flour": "flour",
    "plain yogurt": "yogurt",
    "potatoes": "potato",
    "powdered sugar (for dusting)": "powdered_sugar",
    "ramen noodles": "ramen_noodles",
    "raw shrimp": "shrimp",
    "red bell pepper": "bell_pepper",
    "red kidney beans": "kidney_beans",
    "red onion": "red_onion",
    "red pepper flakes": "chili_flakes",
    "ripe tomatoes": "tomato",
    "roasted sesame seeds": "sesame",
    "salted butter": "butter",
    "scallions": "green_onion",
    "sesame oil": "sesame_oil",
    "sesame seeds": "sesame",
    "shredded mozzarella cheese": "mozzarella",
    "sliced cheese": "cheese",
    "sour cream or yogurt": "sour_cream",
    "spaghetti noodles": "spaghetti",
    "spring onions": "green_onion",
    "stewing lamb": "lamb",
    "sweet potato": "sweet_potato",
    "sweet soy sauce": "soy_sauce",
    "thai basil": "basil",
    "thick-cut bacon": "bacon",
    "toasted sesame seeds": "sesame",
    "tomato paste": "tomato_paste",
    "tomatoes": "tomato",
    "unsalted butter": "unsalted_butter",
    "vanilla extract": "vanilla_extract",
    "vegetable broth": "vegetable_broth",
    "vegetable oil": "cooking_oil",
    "warm water": "water",
    "water": "water",
    "white onion": "onion",
    "white sugar": "sugar",
    "whole chicken": "chicken",
    "whole wheat flour": "whole_wheat_flour",
    "wonton wrappers": "wonton_wrappers",
    "yellow onion": "yellow_onion",
    "yogurt or sour cream": "yogurt",
    "zucchini": "zucchini",
    
    # ── Pass 2: remaining 101 unmatched ──
    "balsamic vinegar": "balsamic_vinegar",
    "chicken pieces": "chicken",
    "chicken wings or drumettes": "chicken_wing",
    "chickpeas": "chickpea",
    "chili powder": "chili_powder",
    "chives": "chives",
    "chocolate chips": "chocolate_chips",
    "cinnamon stick": "cinnamon",
    "cooked chicken": "chicken",
    "cooked chicken breast": "chicken_breast",
    "cooked rice": "rice",
    "coriander powder": "coriander",
    "corn on the cob": "corn",
    "croutons": "breadcrumbs",
    "crushed peanuts": "peanuts",
    "day-old bread": "bread",
    "dried chickpeas": "chickpea",
    "egg yolk": "egg",
    "egg yolks": "egg",
    "fish cake": "fish_cake",
    "flour tortillas": "tortilla",
    "fresh basil": "basil",
    "fresh basil or cilantro": "basil",
    "fresh berries": "blueberry",
    "fresh cilantro": "cilantro",
    "fresh dill": "dill",
    "fresh herbs": "parsley",
    "fresh mozzarella": "mozzarella",
    "frozen mixed vegetables": "mixed_vegetables",
    "frozen peas": "peas",
    "frozen peas and carrots": "peas",
    "galangal or ginger": "ginger",
    "garam masala": "garam_masala",
    "ghee or oil": "ghee",
    "gochugaru": "korean_chili_flakes",
    "greek yogurt": "yogurt",
    "green chili": "chili_pepper",
    "green peas": "peas",
    "green pepper": "bell_pepper",
    "ground lamb or beef": "lamb",
    "gruyere cheese": "gruyere",
    "guanciale or pancetta": "bacon",
    "hand-pulled noodles or thick spaghetti": "pasta",
    "hard-boiled egg": "egg",
    "hoisin sauce": "hoisin_sauce",
    "hot green pepper": "chili_pepper",
    "ice": "water",
    "italian seasoning": "italian_seasoning",
    "kaffir lime leaves": "lime",
    "kidney beans": "kidney_beans",
    "korean chili paste": "gochujang",
    "lamb or beef": "lamb",
    "lamb or beef on the bone": "lamb",
    "lamb or horse meat": "lamb",
    "lamb ribs or beef": "lamb_ribs",
    "lard or vegetable shortening": "cooking_oil",
    "lemon wedges": "lemon",
    "lemongrass": "lemongrass",
    "malt vinegar": "vinegar",
    "milk or yogurt": "milk",
    "mirin": "mirin",
    "mushrooms": "mushroom",
    "nori sheets": "nori",
    "nutella or jam": "chocolate",
    "onion powder": "onion_powder",
    "parmesan cheese": "parmesan",
    "parmesan rind": "parmesan",
    "pecorino romano": "parmesan",
    "penne pasta": "pasta",
    "pizza dough": "flour",
    "puff pastry sheet": "flour",
    "ranch or yogurt sauce": "yogurt",
    "red grapes": "grape",
    "red lentils": "red_lentil",
    "red wine vinegar": "vinegar",
    "rice cakes": "rice_cakes",
    "ripe banana": "banana",
    "ripe bananas": "banana",
    "romaine lettuce": "lettuce",
    "russet potatoes": "potato",
    "sake or rice wine": "rice_wine",
    "salsa": "tomato_sauce",
    "san marzano tomatoes": "canned_tomato",
    "shrimp or chicken": "shrimp",
    "small pasta": "pasta",
    "smoked paprika": "paprika",
    "soft-boiled eggs": "egg",
    "spam or pork belly": "pork",
    "split peas": "peas",
    "sweet potato noodles": "sweet_potato",
    "taco shells": "tortilla",
    "tamarind paste": "tamarind",
    "thai chili": "chili_pepper",
    "tomato puree": "tomato_paste",
    "tomato sauce": "tomato_sauce",
    "vanilla": "vanilla",
    "walnuts": "walnut",
    "water or broth": "water",
    "white fish fillets": "white_fish_fillet",
    "white wine": "wine",
    "whole egg": "egg",
}

# 6. Auto-match: try canonical_name and en_map
auto_matched = {}
unmatched = []

for raw_name in unique_names:
    # Check explicit mapping first
    if raw_name in NORMALIZE_MAP:
        auto_matched[raw_name] = NORMALIZE_MAP[raw_name]
        continue
    
    # Try direct canonical match
    canonical_try = raw_name.replace(" ", "_").replace("-", "_")
    if canonical_try in canonical_map:
        auto_matched[raw_name] = canonical_try
        continue
    
    # Try display_name_en match
    if raw_name in en_map:
        auto_matched[raw_name] = en_map[raw_name]
        continue
    
    unmatched.append(raw_name)

print(f"\n=== MATCHING RESULTS ===")
print(f"  Auto-matched: {len(auto_matched)}/{len(unique_names)}")
print(f"  Unmatched: {len(unmatched)}")

if unmatched:
    print(f"\n=== STILL UNMATCHED ({len(unmatched)}) ===")
    for name in unmatched:
        print(f"  ❌ {name} (used {name_counts[name]}x)")

# 7. Find which canonical names are referenced but don't exist yet
needed_new = set()
for raw, canonical in auto_matched.items():
    if canonical not in canonical_map:
        needed_new.add(canonical)

# Also check NORMALIZE_MAP targets
for canonical in NORMALIZE_MAP.values():
    if canonical not in canonical_map:
        needed_new.add(canonical)

print(f"\n=== NEW CANONICAL INGREDIENTS NEEDED: {len(needed_new)} ===")
for name in sorted(needed_new):
    print(f"  + {name}")

# 8. Save the full mapping for the next step
mapping_output = {
    "total_recipes": len(recipes.data),
    "total_unique_names": len(unique_names),
    "auto_matched": len(auto_matched),
    "unmatched_count": len(unmatched),
    "unmatched": unmatched,
    "new_canonical_needed": sorted(needed_new),
    "mapping": {**auto_matched},
}

import os
os.makedirs("data", exist_ok=True)
with open("data/ingredient_mapping.json", "w", encoding="utf-8") as f:
    json.dump(mapping_output, f, indent=2, ensure_ascii=False)
print(f"\nMapping saved to data/ingredient_mapping.json")
