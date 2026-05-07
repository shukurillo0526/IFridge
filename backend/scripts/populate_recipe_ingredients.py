"""
Phase 2: Populate recipe_ingredients from JSONB data.
Run AFTER migration 013 has been executed in Supabase.

This script:
1. Loads the ingredient mapping from Phase 1
2. For each recipe, reads its JSONB ingredients
3. Maps each ingredient name -> canonical ingredient_id
4. Inserts into recipe_ingredients table
"""
import json, sys
from app.db.supabase_client import get_supabase

# Load the full mapping from Phase 1
NORMALIZE_MAP = {
    "all-purpose flour": "all_purpose_flour",
    "active dry yeast": "yeast",
    "anchovy broth or water": "anchovy",
    "anchovy or dashima broth": "anchovy",
    "arborio rice": "rice",
    "asian pear or apple": "pear",
    "baby spinach": "spinach",
    "baguette": "bread",
    "balsamic vinegar": "balsamic_vinegar",
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
    "chicken pieces": "chicken",
    "chicken thighs": "chicken_thigh",
    "chicken wings or drumettes": "chicken_wing",
    "chickpeas": "chickpea",
    "chili paste (gochugaru or red pepper flakes)": "korean_chili_flakes",
    "chili powder": "chili_powder",
    "chives": "chives",
    "chocolate chips": "chocolate_chips",
    "cinnamon stick": "cinnamon",
    "cinnamon sticks": "cinnamon",
    "cocoa powder or chocolate": "cocoa_powder",
    "cold water": "water",
    "cooked chicken": "chicken",
    "cooked chicken breast": "chicken_breast",
    "cooked rice": "rice",
    "cooked white rice": "rice",
    "cooking oil or ghee": "cooking_oil",
    "coriander powder": "coriander",
    "corn kernels": "corn",
    "corn on the cob": "corn",
    "cornstarch slurry": "cornstarch",
    "cream cheese (softened)": "cream_cheese",
    "cream cheese block": "cream_cheese",
    "croutons": "breadcrumbs",
    "crushed peanuts": "peanuts",
    "cumin powder": "cumin",
    "cumin seeds": "cumin",
    "dark soy sauce": "soy_sauce",
    "dashima (kelp)": "dashima",
    "day-old bread": "bread",
    "dried chickpeas": "chickpea",
    "dried chili peppers": "chili_flakes",
    "dried lasagna noodles": "pasta",
    "dried red chili peppers": "chili_flakes",
    "dry red wine": "wine",
    "dry white wine": "wine",
    "egg noodles": "pasta",
    "egg yolk": "egg",
    "egg yolks": "egg",
    "eggs": "egg",
    "extra-firm tofu": "firm_tofu",
    "feta cheese": "feta",
    "fish cake": "fish_cake",
    "fish sauce (optional)": "fish_sauce",
    "flat-leaf parsley": "parsley",
    "flour tortillas": "tortilla",
    "fresh basil": "basil",
    "fresh basil or cilantro": "basil",
    "fresh berries": "blueberry",
    "fresh cilantro": "cilantro",
    "fresh dill": "dill",
    "fresh ginger": "ginger",
    "fresh herbs": "parsley",
    "fresh mozzarella": "mozzarella",
    "fresh parsley": "parsley",
    "fresh spinach": "spinach",
    "fresh thyme": "thyme",
    "frozen mixed vegetables": "mixed_vegetables",
    "frozen peas": "peas",
    "frozen peas and carrots": "peas",
    "galangal or ginger": "ginger",
    "garam masala": "garam_masala",
    "garlic cloves": "garlic",
    "garlic powder": "garlic_powder",
    "ghee or oil": "ghee",
    "ginger paste": "ginger",
    "gochugaru": "korean_chili_flakes",
    "gochugaru (korean red pepper flakes)": "korean_chili_flakes",
    "gochujang (korean chili paste)": "gochujang",
    "graham cracker crumbs": "breadcrumbs",
    "greek yogurt": "yogurt",
    "green beans": "green_beans",
    "green bell pepper": "bell_pepper",
    "green chili": "chili_pepper",
    "green onions": "green_onion",
    "green or brown lentils": "lentils",
    "green peas": "peas",
    "green pepper": "bell_pepper",
    "ground beef": "ground_beef",
    "ground beef or lamb": "ground_beef",
    "ground chicken or turkey": "ground_chicken",
    "ground cinnamon": "cinnamon",
    "ground cloves": "cloves",
    "ground cumin": "cumin",
    "ground lamb": "lamb",
    "ground lamb or beef": "lamb",
    "ground pork": "ground_pork",
    "ground turmeric": "turmeric",
    "gruyere cheese": "gruyere",
    "guanciale or pancetta": "bacon",
    "hand-pulled noodles or thick spaghetti": "pasta",
    "hard-boiled egg": "egg",
    "heavy cream or coconut cream": "heavy_cream",
    "hoisin sauce": "hoisin_sauce",
    "hot green pepper": "chili_pepper",
    "hot water": "water",
    "ice": "water",
    "instant noodles": "ramen_noodles",
    "italian sausage": "sausage",
    "italian seasoning": "italian_seasoning",
    "jasmine or basmati rice": "jasmine_rice",
    "kaffir lime leaves": "lime",
    "kidney beans": "kidney_beans",
    "kimchi": "kimchi",
    "korean chili paste": "gochujang",
    "korean radish (mu) or daikon": "daikon",
    "lamb chops": "lamb_ribs",
    "lamb leg or shoulder": "lamb_leg",
    "lamb or beef": "lamb",
    "lamb or beef on the bone": "lamb",
    "lamb or horse meat": "lamb",
    "lamb ribs or beef": "lamb_ribs",
    "lamb shoulder": "lamb_shoulder",
    "lard or vegetable shortening": "cooking_oil",
    "large eggs": "egg",
    "lemon juice": "lemon_juice",
    "lemon wedges": "lemon",
    "lemon zest": "lemon",
    "lemongrass": "lemongrass",
    "lettuce leaves": "lettuce",
    "lime juice": "lime",
    "long grain rice": "rice",
    "low-sodium soy sauce": "soy_sauce",
    "malt vinegar": "vinegar",
    "milk or yogurt": "milk",
    "mirin": "mirin",
    "mixed vegetables": "mixed_vegetables",
    "mushrooms": "mushroom",
    "napa cabbage": "cabbage",
    "nori sheets": "nori",
    "nutella or jam": "chocolate",
    "olive oil or butter": "olive_oil",
    "onion powder": "onion_powder",
    "onions": "onion",
    "orange zest": "orange",
    "panko breadcrumbs": "panko",
    "parmesan cheese": "parmesan",
    "parmesan rind": "parmesan",
    "peanut butter": "peanut_butter",
    "peanuts (crushed)": "peanuts",
    "pecorino romano": "parmesan",
    "penne pasta": "pasta",
    "pickled radish": "radish",
    "pizza dough": "flour",
    "plain flour": "flour",
    "plain yogurt": "yogurt",
    "potatoes": "potato",
    "powdered sugar (for dusting)": "powdered_sugar",
    "puff pastry sheet": "flour",
    "ramen noodles": "ramen_noodles",
    "ranch or yogurt sauce": "yogurt",
    "raw shrimp": "shrimp",
    "red bell pepper": "bell_pepper",
    "red grapes": "grape",
    "red kidney beans": "kidney_beans",
    "red lentils": "red_lentil",
    "red onion": "red_onion",
    "red pepper flakes": "chili_flakes",
    "red wine vinegar": "vinegar",
    "rice cakes": "rice_cakes",
    "ripe banana": "banana",
    "ripe bananas": "banana",
    "ripe tomatoes": "tomato",
    "roasted sesame seeds": "sesame",
    "romaine lettuce": "lettuce",
    "russet potatoes": "potato",
    "sake or rice wine": "rice_wine",
    "salsa": "tomato_sauce",
    "salted butter": "butter",
    "san marzano tomatoes": "canned_tomato",
    "scallions": "green_onion",
    "sesame oil": "sesame_oil",
    "sesame seeds": "sesame",
    "shredded mozzarella cheese": "mozzarella",
    "shrimp or chicken": "shrimp",
    "sliced cheese": "cheese",
    "small pasta": "pasta",
    "smoked paprika": "paprika",
    "soft-boiled eggs": "egg",
    "sour cream or yogurt": "sour_cream",
    "spaghetti noodles": "spaghetti",
    "spam or pork belly": "pork",
    "split peas": "peas",
    "spring onions": "green_onion",
    "stewing lamb": "lamb",
    "sweet potato": "sweet_potato",
    "sweet potato noodles": "sweet_potato",
    "sweet soy sauce": "soy_sauce",
    "taco shells": "tortilla",
    "tamarind paste": "tamarind",
    "thai basil": "basil",
    "thai chili": "chili_pepper",
    "thick-cut bacon": "bacon",
    "toasted sesame seeds": "sesame",
    "tomato paste": "tomato_paste",
    "tomato puree": "tomato_paste",
    "tomato sauce": "tomato_sauce",
    "tomatoes": "tomato",
    "unsalted butter": "unsalted_butter",
    "vanilla": "vanilla",
    "vanilla extract": "vanilla_extract",
    "vegetable broth": "vegetable_broth",
    "vegetable oil": "cooking_oil",
    "walnuts": "walnut",
    "warm water": "water",
    "water": "water",
    "water or broth": "water",
    "white fish fillets": "white_fish_fillet",
    "white onion": "onion",
    "white sugar": "sugar",
    "white wine": "wine",
    "whole chicken": "chicken",
    "whole egg": "egg",
    "whole wheat flour": "whole_wheat_flour",
    "wonton wrappers": "wonton_wrappers",
    "yellow onion": "yellow_onion",
    "yogurt or sour cream": "yogurt",
    "zucchini": "zucchini",
}

def main():
    db = get_supabase()
    
    # 1. Build canonical_name -> ingredient_id lookup
    existing = db.table("ingredients").select("id, canonical_name, display_name_en").execute()
    canonical_to_id = {}
    en_to_canonical = {}
    for ing in existing.data:
        canonical_to_id[ing["canonical_name"]] = ing["id"]
        if ing.get("display_name_en"):
            en_to_canonical[ing["display_name_en"].strip().lower()] = ing["canonical_name"]
    
    print(f"Canonical ingredients in DB: {len(canonical_to_id)}")
    
    # 2. Get all recipes
    recipes = db.table("recipes").select("id, title, ingredients").execute()
    print(f"Recipes to process: {len(recipes.data)}")
    
    # 3. Process each recipe
    total_inserted = 0
    total_skipped = 0
    failed_recipes = []
    
    for r in recipes.data:
        ings = r.get("ingredients", [])
        if isinstance(ings, str):
            ings = json.loads(ings)
        if not ings:
            continue
        
        rows_for_recipe = []
        for idx, ing in enumerate(ings):
            if isinstance(ing, dict):
                raw_name = ing.get("name", ing.get("ingredient", "")).strip()
                quantity = ing.get("quantity")
                unit = ing.get("unit", "")
                prep_note = ing.get("prep_note", "")
            elif isinstance(ing, str):
                raw_name = ing.strip()
                quantity = None
                unit = ""
                prep_note = ""
            else:
                continue
            
            if not raw_name:
                continue
            
            # Resolve canonical name
            raw_lower = raw_name.lower()
            canonical = NORMALIZE_MAP.get(raw_lower)
            if not canonical:
                # Try direct canonical match
                canonical_try = raw_lower.replace(" ", "_").replace("-", "_")
                if canonical_try in canonical_to_id:
                    canonical = canonical_try
                elif raw_lower in en_to_canonical:
                    canonical = en_to_canonical[raw_lower]
            
            if not canonical or canonical not in canonical_to_id:
                print(f"  ⚠ Recipe '{r['title']}': unmapped ingredient '{raw_name}' -> '{canonical}'")
                total_skipped += 1
                continue
            
            ingredient_id = canonical_to_id[canonical]
            
            # Avoid duplicate ingredient_id per recipe
            if any(row["ingredient_id"] == ingredient_id for row in rows_for_recipe):
                continue
            
            rows_for_recipe.append({
                "recipe_id": r["id"],
                "ingredient_id": ingredient_id,
                "quantity": float(quantity) if quantity else None,
                "unit": unit or None,
                "prep_note": prep_note or None,
                "is_optional": False,
                "display_order": idx + 1,
            })
        
        # Insert batch for this recipe
        if rows_for_recipe:
            try:
                db.table("recipe_ingredients").insert(rows_for_recipe).execute()
                total_inserted += len(rows_for_recipe)
            except Exception as e:
                print(f"  ❌ Failed recipe '{r['title']}': {e}")
                failed_recipes.append(r["title"])
    
    print(f"\n=== RESULTS ===")
    print(f"  Rows inserted: {total_inserted}")
    print(f"  Skipped (unmapped): {total_skipped}")
    print(f"  Failed recipes: {len(failed_recipes)}")
    if failed_recipes:
        for name in failed_recipes:
            print(f"    ❌ {name}")
    
    # 4. Verify
    total = db.table("recipe_ingredients").select("id", count="exact").execute()
    print(f"\n  recipe_ingredients table total rows: {total.count}")

if __name__ == "__main__":
    main()
