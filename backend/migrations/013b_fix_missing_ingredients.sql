-- Fix: Add 5 missing canonical ingredients that were skipped
INSERT INTO public.ingredients (canonical_name, display_name_en, display_name_ko, display_name_uz, display_name_ru, category, default_unit, sealed_shelf_life_days, opened_shelf_life_days, storage_zone)
VALUES
  ('hoisin_sauce',      'Hoisin Sauce',      '호이신 소스',   'Hoisin sousi',       'Хойсин соус',           'condiment',  'tbsp', 365, 30, 'pantry'),
  ('balsamic_vinegar',  'Balsamic Vinegar',  '발사믹 식초',   'Balsam sirkasi',     'Бальзамический уксус',  'condiment',  'tbsp', 730, 180, 'pantry'),
  ('red_onion',         'Red Onion',         '적양파',        'Qizil piyoz',        'Красный лук',           'vegetable',  'piece', 60, 10, 'pantry'),
  ('mirin',             'Mirin',             '미림',          'Mirin',              'Мирин',                 'condiment',  'tbsp', 365, 90, 'pantry'),
  ('chili_pepper',      'Chili Pepper',      '고추',          'Achchiq qalampir',   'Перец чили',            'vegetable',  'piece', 14,  7, 'fridge')
ON CONFLICT (canonical_name) DO UPDATE SET
  display_name_en = EXCLUDED.display_name_en,
  display_name_ko = EXCLUDED.display_name_ko,
  display_name_uz = EXCLUDED.display_name_uz,
  display_name_ru = EXCLUDED.display_name_ru;
