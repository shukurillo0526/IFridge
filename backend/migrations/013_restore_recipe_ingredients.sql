-- ============================================================
-- I-Fridge — Migration 013: Restore Relational Recipe-Ingredients
-- ============================================================
-- Phase 1: Add 41 missing canonical ingredients
-- Phase 2: Recreate recipe_ingredients relational table
-- ============================================================

-- ══════════════════════════════════════════════════
-- PHASE 1: Add missing canonical ingredients
-- ══════════════════════════════════════════════════

INSERT INTO public.ingredients (canonical_name, display_name_en, display_name_ko, display_name_uz, display_name_ru, category, default_unit, sealed_shelf_life_days, opened_shelf_life_days, storage_zone)
VALUES
  ('water',              'Water',              '물',           'Suv',                'Вода',                  'beverage',   'ml',    9999, 9999, 'pantry'),
  ('beef_broth',         'Beef Broth',         '소고기 육수',   'Mol go''shti sho''rvasi', 'Говяжий бульон',   'condiment',  'ml',    365,  5,  'pantry'),
  ('chicken_broth',      'Chicken Broth',      '닭 육수',      'Tovuq sho''rvasi',   'Куриный бульон',        'condiment',  'ml',    365,  5,  'pantry'),
  ('vegetable_broth',    'Vegetable Broth',    '채소 육수',     'Sabzavot sho''rvasi', 'Овощной бульон',       'condiment',  'ml',    365,  5,  'pantry'),
  ('ground_beef',        'Ground Beef',        '소고기 다짐',   'Mol qiymasi',        'Говяжий фарш',         'protein',    'g',     3,    2,  'fridge'),
  ('ground_chicken',     'Ground Chicken',     '닭 다짐',      'Tovuq qiymasi',      'Куриный фарш',         'protein',    'g',     2,    1,  'fridge'),
  ('ground_pork',        'Ground Pork',        '돼지 다짐',    'Cho''chqa qiymasi',  'Свиной фарш',          'protein',    'g',     3,    2,  'fridge'),
  ('chicken_drumstick',  'Chicken Drumstick',  '닭 다리',      'Tovuq boldir go''shti', 'Куриная голень',     'protein',    'piece', 3,    2,  'fridge'),
  ('cherry_tomato',      'Cherry Tomato',      '방울토마토',    'Gilospomidor',       'Помидоры черри',        'vegetable',  'piece', 10,   5,  'fridge'),
  ('canned_tomato',      'Canned Tomato',      '토마토 통조림', 'Tomat konservasi',   'Консервированные томаты','condiment', 'can',   730,  5,  'pantry'),
  ('tomato_sauce',       'Tomato Sauce',       '토마토 소스',   'Pomidor sousi',      'Томатный соус',         'condiment',  'ml',    365,  7,  'pantry'),
  ('chili_powder',       'Chili Powder',       '고춧가루',      'Achchiq qalampir kukuni', 'Порошок чили',     'seasoning',  'tsp',   365, 180, 'pantry'),
  ('cayenne_pepper',     'Cayenne Pepper',     '카이엔 페퍼',   'Kayenn qalampiri',   'Кайенский перец',       'seasoning',  'tsp',   365, 180, 'pantry'),
  ('garlic_powder',      'Garlic Powder',      '마늘 가루',     'Sarimsoq kukuni',    'Чесночный порошок',     'seasoning',  'tsp',   365, 180, 'pantry'),
  ('onion_powder',       'Onion Powder',       '양파 가루',     'Piyoz kukuni',       'Луковый порошок',       'seasoning',  'tsp',   365, 180, 'pantry'),
  ('italian_seasoning',  'Italian Seasoning',  '이탈리안 시즈닝','Italyan ziravor',    'Итальянские травы',     'seasoning',  'tsp',   365, 180, 'pantry'),
  ('garam_masala',       'Garam Masala',       '가람 마살라',   'Garam masala',       'Гарам масала',          'seasoning',  'tsp',   365, 180, 'pantry'),
  ('cloves',             'Cloves',             '정향',          'Mixak',              'Гвоздика',              'seasoning',  'tsp',   730, 365, 'pantry'),
  ('chives',             'Chives',             '부추',          'Piyozcha',           'Шнитт-лук',             'vegetable',  'piece', 7,    3,  'fridge'),
  ('green_beans',        'Green Beans',        '껍질콩',        'Ko''k loviya',       'Стручковая фасоль',     'vegetable',  'g',     7,    3,  'fridge'),
  ('mixed_vegetables',   'Mixed Vegetables',   '혼합 야채',     'Aralash sabzavotlar','Овощная смесь',         'vegetable',  'g',     365,  3,  'fridge'),
  ('kimchi',             'Kimchi',             '김치',          'Kimchi',             'Кимчи',                 'condiment',  'g',     365, 30,  'fridge'),
  ('dashima',            'Dashima (Kelp)',     '다시마',        'Dashima',            'Дасима (водоросли)',     'condiment',  'sheet', 730, 365, 'pantry'),
  ('nori',               'Nori Sheets',        '김',            'Nori',               'Нори',                  'condiment',  'sheet', 365, 30,  'pantry'),
  ('fish_cake',          'Fish Cake',          '어묵',          'Baliq keki',         'Рыбный пирог',          'protein',    'piece', 14,   5,  'fridge'),
  ('rice_cakes',         'Rice Cakes',         '떡',            'Guruch keki',        'Рисовые лепёшки',       'grain',      'g',     365, 3,   'fridge'),
  ('chocolate_chips',    'Chocolate Chips',    '초콜릿 칩',     'Shokolad parchasi',  'Шоколадная крошка',      'baking',     'cup',   365, 90,  'pantry'),
  ('lemongrass',         'Lemongrass',         '레몬그라스',    'Limon o''ti',        'Лемонграсс',             'seasoning',  'stalk', 14,   7,  'fridge'),
  ('tamarind',           'Tamarind Paste',     '타마린드',      'Tamarind pastasi',   'Тамаринд',               'condiment',  'tbsp',  365, 30,  'pantry'),
  ('wonton_wrappers',    'Wonton Wrappers',    '완탕 피',       'Vonton qobig''i',    'Обёртки для вонтонов',    'grain',      'piece', 14,   5,  'fridge'),
  ('ghee',               'Ghee',               '기(버터)',      'Sari yog''',         'Топлёное масло',          'oil',        'tbsp',  180, 90,  'pantry'),
  ('gruyere',            'Gruyère Cheese',     '그뤼에르 치즈',  'Gruyyer pishloq',   'Грюйер',                 'dairy',      'g',     60,  14,  'fridge'),
  ('kidney_beans',       'Kidney Beans',       '강낭콩',        'Loviya',             'Красная фасоль',         'legume',     'cup',   365,  5,  'pantry'),
  ('sesame',             'Sesame Seeds',       '참깨',          'Kunjut',             'Кунжут',                 'seasoning',  'tbsp',  365, 180, 'pantry'),
  ('panko',              'Panko Breadcrumbs',  '빵가루',        'Panko',              'Панко',                  'grain',      'cup',   365, 30,  'pantry'),
  ('vanilla',            'Vanilla',            '바닐라',        'Vanil',              'Ваниль',                 'baking',     'tsp',   730, 365, 'pantry'),
  ('peanut_butter',      'Peanut Butter',      '땅콩버터',      'Yeryong''oq yog''i', 'Арахисовая паста',       'condiment',  'tbsp',  365, 90,  'pantry'),
  ('feta',               'Feta Cheese',        '페타 치즈',     'Feta pishloq',       'Фета',                  'dairy',      'g',     60,  14,  'fridge'),
  ('rice_wine',          'Rice Wine / Sake',   '청주/사케',     'Guruch vinosi',      'Рисовое вино',           'beverage',   'ml',    365, 30,  'pantry'),
  ('dill',               'Dill',               '딜',            'Ukrop',              'Укроп',                  'vegetable',  'piece', 7,    3,  'fridge'),
  ('lemon_juice',        'Lemon Juice',        '레몬즙',        'Limon suvi',         'Лимонный сок',           'condiment',  'ml',    365, 14,  'fridge')
ON CONFLICT (canonical_name) DO UPDATE SET
  display_name_en = EXCLUDED.display_name_en,
  display_name_ko = EXCLUDED.display_name_ko,
  display_name_uz = EXCLUDED.display_name_uz,
  display_name_ru = EXCLUDED.display_name_ru,
  category        = EXCLUDED.category;


-- ══════════════════════════════════════════════════
-- PHASE 2: Recreate recipe_ingredients table
-- ══════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.recipe_ingredients (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_id     UUID NOT NULL REFERENCES public.recipes(id) ON DELETE CASCADE,
    ingredient_id UUID NOT NULL REFERENCES public.ingredients(id) ON DELETE CASCADE,
    quantity      NUMERIC,
    unit          TEXT,
    prep_note     TEXT,
    is_optional   BOOLEAN DEFAULT false,
    display_order INT DEFAULT 0,
    UNIQUE(recipe_id, ingredient_id)
);

-- Indexes for fast lookups
CREATE INDEX IF NOT EXISTS idx_ri_recipe ON public.recipe_ingredients(recipe_id);
CREATE INDEX IF NOT EXISTS idx_ri_ingredient ON public.recipe_ingredients(ingredient_id);

-- RLS
ALTER TABLE public.recipe_ingredients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "recipe_ingredients_read_all" ON public.recipe_ingredients FOR SELECT USING (true);
