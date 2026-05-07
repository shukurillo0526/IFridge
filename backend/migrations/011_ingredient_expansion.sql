-- ============================================================
-- I-Fridge — Migration 011: Ingredient Expansion
-- ============================================================
-- Phase 1: Data quality fixes
-- Phase 2: Central Asian essentials (~30 items)
-- Phase 3: Global gaps (~30 items)
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- PHASE 1: Data Quality Fixes
-- ────────────────────────────────────────────────────────────

-- Fix "Grain" → "grain" (Macaroni)
UPDATE public.ingredients SET category = 'grain' WHERE category = 'Grain';

-- Fix "fat" → "oil" (Olive Oil)
UPDATE public.ingredients SET category = 'oil' WHERE category = 'fat';

-- Fix "snack" → "nut" (Peanuts) — avoid duplicate if 'peanut' already exists in nut
UPDATE public.ingredients SET category = 'nut' WHERE category = 'snack';

-- ────────────────────────────────────────────────────────────
-- PHASE 2: Central Asian Essentials
-- ────────────────────────────────────────────────────────────

INSERT INTO public.ingredients
    (canonical_name, display_name_en, display_name_ko, category, sub_category,
     default_unit, sealed_shelf_life_days, opened_shelf_life_days, storage_zone, calories_per_100g)
VALUES
    -- ── Proteins ──
    ('lamb',              'Lamb',                '양고기',       'protein',   'red_meat',     'g',     5,   3,   'fridge',  294),
    ('lamb_shoulder',     'Lamb Shoulder',       '양 어깨살',    'protein',   'red_meat',     'g',     5,   3,   'fridge',  235),
    ('lamb_leg',          'Lamb Leg',            '양다리',       'protein',   'red_meat',     'g',     5,   3,   'fridge',  230),
    ('lamb_ribs',         'Lamb Ribs',           '양 갈비',      'protein',   'red_meat',     'g',     4,   2,   'fridge',  291),
    ('horse_meat',        'Horse Meat',          '말고기',       'protein',   'red_meat',     'g',     4,   2,   'fridge',  175),
    ('lamb_fat',          'Lamb Tail Fat',       '양 꼬리기름',   'protein',   'fat',          'g',     7,   5,   'fridge',  750),
    ('quail',             'Quail',               '메추리',       'protein',   'poultry',      'g',     3,   2,   'fridge',  134),

    -- ── Dairy & Fermented ──
    ('suzma',             'Suzma (Strained Yogurt)', '수즈마',   'dairy',     'fermented',    'g',     14,  7,   'fridge',  70),
    ('kurt',              'Kurt (Dried Yogurt)',      '쿠르트',   'dairy',     'fermented',    'piece', 365, 365, 'pantry',  300),
    ('kaymak',            'Kaymak (Clotted Cream)',   '카이막',   'dairy',     'cream',        'g',     7,   3,   'fridge',  350),
    ('ayran',             'Ayran (Yogurt Drink)',     '아이란',   'dairy',     'fermented',    'ml',    10,  3,   'fridge',  35),
    ('kefir',             'Kefir',                    '케피르',   'dairy',     'fermented',    'ml',    14,  7,   'fridge',  60),

    -- ── Grains & Breads ──
    ('non_bread',         'Non (Uzbek Flatbread)',    '논 빵',    'grain',     'bread',        'piece', 3,   1,   'pantry',  260),
    ('mung_bean',         'Mung Beans',               '녹두',     'legume',    'bean',         'cup',   365, 5,   'pantry',  347),
    ('buckwheat',         'Buckwheat',                '메밀',     'grain',     'whole_grain',  'cup',   365, 180, 'pantry',  343),
    ('bulgur',            'Bulgur Wheat',             '불구르',   'grain',     'whole_grain',  'cup',   365, 180, 'pantry',  342),
    ('cornmeal',          'Cornmeal',                 '옥수수가루', 'grain',   'flour',        'cup',   365, 180, 'pantry',  362),

    -- ── Vegetables ──
    ('green_radish',      'Green Radish',             '청무',     'vegetable', 'root',         'piece', 21,  10,  'fridge',  20),
    ('quince',            'Quince',                   '모과',     'fruit',     'pome',         'piece', 60,  7,   'fridge',  57),
    ('turnip',            'Turnip',                   '순무',     'vegetable', 'root',         'piece', 21,  10,  'fridge',  28),
    ('sweet_potato',      'Sweet Potato',             '고구마',   'vegetable', 'root',         'piece', 30,  7,   'pantry',  86),
    ('shallot',           'Shallot',                  '샬롯',     'vegetable', 'allium',       'piece', 30,  14,  'pantry',  72),
    ('leek',              'Leek',                     '대파',     'vegetable', 'allium',       'piece', 14,  7,   'fridge',  61),
    ('fennel',            'Fennel',                   '회향',     'vegetable', 'bulb',         'piece', 14,  7,   'fridge',  31),
    ('jalapeno',          'Jalapeño',                 '할라피뇨',  'vegetable', 'pepper',       'piece', 14,  5,   'fridge',  29),

    -- ── Spices & Seasonings (Central Asian) ──
    ('barberry',          'Barberry (Dried)',         '매자나무 열매', 'seasoning', 'spice',    'tsp',   730, 365, 'pantry',  316),
    ('sumac',             'Sumac',                    '수막',         'seasoning', 'spice',    'tsp',   730, 365, 'pantry',  239),
    ('nigella_seed',      'Nigella Seeds',            '니겔라씨',     'seasoning', 'seed',     'tsp',   730, 365, 'pantry',  345),
    ('dried_apricot',     'Dried Apricots',           '건살구',       'fruit',     'dried',    'g',     365, 30,  'pantry',  241),
    ('raisins',           'Raisins',                  '건포도',       'fruit',     'dried',    'g',     365, 30,  'pantry',  299),
    ('cotton_oil',        'Cottonseed Oil',           '면실유',       'oil',       'seed_oil', 'ml',    365, 180, 'pantry',  884)

ON CONFLICT (canonical_name) DO UPDATE SET
    display_name_en        = EXCLUDED.display_name_en,
    display_name_ko        = EXCLUDED.display_name_ko,
    category               = EXCLUDED.category,
    sub_category           = EXCLUDED.sub_category,
    default_unit           = EXCLUDED.default_unit,
    sealed_shelf_life_days = EXCLUDED.sealed_shelf_life_days,
    opened_shelf_life_days = EXCLUDED.opened_shelf_life_days,
    storage_zone           = EXCLUDED.storage_zone,
    calories_per_100g      = EXCLUDED.calories_per_100g;


-- ────────────────────────────────────────────────────────────
-- PHASE 3: Global Gaps
-- ────────────────────────────────────────────────────────────

INSERT INTO public.ingredients
    (canonical_name, display_name_en, display_name_ko, category, sub_category,
     default_unit, sealed_shelf_life_days, opened_shelf_life_days, storage_zone, calories_per_100g)
VALUES
    -- ── Dairy ──
    ('heavy_cream',       'Heavy Cream',              '생크림',       'dairy',     'cream',        'ml',    30,  7,   'fridge',  340),
    ('buttermilk',        'Buttermilk',               '버터밀크',     'dairy',     'fermented',    'ml',    14,  7,   'fridge',  40),
    ('coconut_milk',      'Coconut Milk',             '코코넛 밀크',  'dairy',     'plant_milk',   'ml',    365, 5,   'pantry',  230),
    ('mascarpone',        'Mascarpone',               '마스카포네',   'dairy',     'cheese',       'g',     14,  5,   'fridge',  429),
    ('ricotta',           'Ricotta Cheese',           '리코타 치즈',  'dairy',     'cheese',       'g',     14,  5,   'fridge',  174),
    ('goat_cheese',       'Goat Cheese',              '염소 치즈',    'dairy',     'cheese',       'g',     21,  7,   'fridge',  364),

    -- ── Condiments ──
    ('tahini',            'Tahini',                   '타히니',       'condiment', 'paste',        'tbsp',  365, 90,  'pantry',  595),
    ('miso_paste',        'Miso Paste',               '미소',         'condiment', 'paste',        'tbsp',  365, 90,  'fridge',  199),
    ('harissa',           'Harissa Paste',            '하리사',       'condiment', 'paste',        'tbsp',  365, 30,  'pantry',  77),
    ('dijon_mustard',     'Dijon Mustard',            '디종 머스타드', 'condiment', 'mustard',     'tsp',   365, 180, 'fridge',  66),
    ('worcestershire',    'Worcestershire Sauce',     '우스터 소스',   'condiment', 'sauce',       'ml',    730, 365, 'pantry',  78),
    ('pomegranate_molasses','Pomegranate Molasses',   '석류 시럽',     'condiment', 'syrup',       'ml',    365, 90,  'pantry',  260),

    -- ── Baking ──
    ('cornstarch',        'Cornstarch',               '옥수수 전분',  'baking',    'thickener',    'tbsp',  730, 365, 'pantry',  381),
    ('yeast_active',      'Active Dry Yeast',         '활성 건조효모', 'baking',    'leavening',   'tsp',   365, 120, 'pantry',  325),
    ('gelatin',           'Gelatin',                  '젤라틴',       'baking',    'thickener',    'g',     730, 365, 'pantry',  335),
    ('maple_syrup',       'Maple Syrup',              '메이플 시럽',  'baking',    'sweetener',    'ml',    365, 180, 'pantry',  260),
    ('molasses',          'Molasses',                 '당밀',         'baking',    'sweetener',    'ml',    365, 180, 'pantry',  290),

    -- ── Grains ──
    ('couscous',          'Couscous',                 '쿠스쿠스',     'grain',     'pasta',        'cup',   365, 180, 'pantry',  376),
    ('quinoa',            'Quinoa',                   '퀴노아',       'grain',     'whole_grain',  'cup',   365, 180, 'pantry',  368),
    ('polenta',           'Polenta',                  '폴렌타',       'grain',     'corn',         'cup',   365, 5,   'pantry',  362),
    ('rice_noodles',      'Rice Noodles',             '쌀국수',       'grain',     'noodle',       'g',     365, 3,   'pantry',  360),

    -- ── Vegetables ──
    ('kale',              'Kale',                     '케일',         'vegetable', 'leafy_green',  'bunch', 7,   3,   'fridge',  49),
    ('brussels_sprouts',  'Brussels Sprouts',         '방울양배추',    'vegetable', 'cruciferous', 'g',     10,  5,   'fridge',  43),
    ('bok_choy',          'Bok Choy',                 '청경채',       'vegetable', 'leafy_green',  'bunch', 7,   3,   'fridge',  13),
    ('watercress',        'Watercress',               '물냉이',       'vegetable', 'leafy_green',  'bunch', 5,   2,   'fridge',  11),
    ('daikon',            'Daikon Radish',            '무',           'vegetable', 'root',         'piece', 21,  10,  'fridge',  18),

    -- ── Proteins ──
    ('duck',              'Duck',                     '오리고기',     'protein',   'poultry',      'g',     3,   2,   'fridge',  337),
    ('turkey',            'Turkey',                   '칠면조',       'protein',   'poultry',      'g',     3,   2,   'fridge',  189),
    ('veal',              'Veal',                     '송아지고기',    'protein',   'red_meat',    'g',     5,   3,   'fridge',  172),
    ('tempeh',            'Tempeh',                   '템페',         'protein',   'plant',        'g',     14,  5,   'fridge',  192),

    -- ── Nuts & Seeds ──
    ('pine_nut',          'Pine Nuts',                '잣',           'nut',       'seed',         'g',     180, 60,  'pantry',  673),
    ('hemp_seeds',        'Hemp Seeds',               '대마씨',       'nut',       'seed',         'g',     365, 90,  'pantry',  553),
    ('poppy_seeds',       'Poppy Seeds',              '양귀비씨',     'nut',       'seed',         'tsp',   365, 180, 'pantry',  525)

ON CONFLICT (canonical_name) DO UPDATE SET
    display_name_en        = EXCLUDED.display_name_en,
    display_name_ko        = EXCLUDED.display_name_ko,
    category               = EXCLUDED.category,
    sub_category           = EXCLUDED.sub_category,
    default_unit           = EXCLUDED.default_unit,
    sealed_shelf_life_days = EXCLUDED.sealed_shelf_life_days,
    opened_shelf_life_days = EXCLUDED.opened_shelf_life_days,
    storage_zone           = EXCLUDED.storage_zone,
    calories_per_100g      = EXCLUDED.calories_per_100g;
