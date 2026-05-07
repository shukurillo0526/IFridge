-- ============================================================
-- Plately — Migration 012c: Fill Remaining Translations
-- Covers: 66 missing UZ/RU + 3 missing KO
-- Also adds display_name_uz_cyrl column for Cyrillic Uzbek
-- ============================================================

-- 1. Add Cyrillic Uzbek column
ALTER TABLE public.ingredients ADD COLUMN IF NOT EXISTS display_name_uz_cyrl TEXT;

-- 2. Fill missing Korean (3 items)
UPDATE public.ingredients SET display_name_ko = '땅콩'        WHERE canonical_name = 'peanuts';
UPDATE public.ingredients SET display_name_ko = '흰살생선 필레' WHERE canonical_name = 'white_fish_fillet';
UPDATE public.ingredients SET display_name_ko = '마카로니'     WHERE canonical_name = 'macaroni';

-- 3. Fill remaining 66 missing UZ + RU
UPDATE public.ingredients SET display_name_uz = 'Ramen',           display_name_ru = 'Рамен'            WHERE canonical_name = 'ramen_noodles';
UPDATE public.ingredients SET display_name_uz = 'Udon',            display_name_ru = 'Удон'             WHERE canonical_name = 'udon';
UPDATE public.ingredients SET display_name_uz = 'Naan noni',       display_name_ru = 'Наан'             WHERE canonical_name = 'naan';
UPDATE public.ingredients SET display_name_uz = 'Muzlatilgan chuchvara', display_name_ru = 'Замороженные пельмени' WHERE canonical_name = 'frozen_dumplings';
UPDATE public.ingredients SET display_name_uz = 'Sariq piyoz',     display_name_ru = 'Жёлтый лук'       WHERE canonical_name = 'yellow_onion';
UPDATE public.ingredients SET display_name_uz = 'Tuzsiz sariyog''', display_name_ru = 'Несолёное масло'  WHERE canonical_name = 'unsalted_butter';
UPDATE public.ingredients SET display_name_uz = 'Oddiy un',        display_name_ru = 'Пшеничная мука'   WHERE canonical_name = 'all_purpose_flour';
UPDATE public.ingredients SET display_name_uz = 'Donador shakar',  display_name_ru = 'Сахар-песок'       WHERE canonical_name = 'granulated_sugar';
UPDATE public.ingredients SET display_name_uz = 'Jasmin guruch',   display_name_ru = 'Жасминовый рис'   WHERE canonical_name = 'jasmine_rice';
UPDATE public.ingredients SET display_name_uz = 'Qattiq tofu',    display_name_ru = 'Твёрдый тофу'     WHERE canonical_name = 'firm_tofu';
UPDATE public.ingredients SET display_name_uz = 'Yeryong''oq',    display_name_ru = 'Арахис'           WHERE canonical_name = 'peanuts';
UPDATE public.ingredients SET display_name_uz = 'Oq baliq filesi', display_name_ru = 'Филе белой рыбы'  WHERE canonical_name = 'white_fish_fillet';
UPDATE public.ingredients SET display_name_uz = 'Bug''doy uni',   display_name_ru = 'Цельнозерновая мука' WHERE canonical_name = 'whole_wheat_flour';
UPDATE public.ingredients SET display_name_uz = 'Shakar kukuni',   display_name_ru = 'Сахарная пудра'   WHERE canonical_name = 'powdered_sugar';
UPDATE public.ingredients SET display_name_uz = 'Xamirturush',     display_name_ru = 'Дрожжи'           WHERE canonical_name = 'yeast';
UPDATE public.ingredients SET display_name_uz = 'Vanil ekstrakti', display_name_ru = 'Ванильный экстракт' WHERE canonical_name = 'vanilla_extract';
UPDATE public.ingredients SET display_name_uz = 'Oq murch',       display_name_ru = 'Белый перец'       WHERE canonical_name = 'white_pepper';
UPDATE public.ingredients SET display_name_uz = 'Koreya qalampiri', display_name_ru = 'Хлопья корейского перца' WHERE canonical_name = 'korean_chili_flakes';
UPDATE public.ingredients SET display_name_uz = 'Besh xil ziravorlar', display_name_ru = 'Пять специй' WHERE canonical_name = 'five_spice';
UPDATE public.ingredients SET display_name_uz = 'Glutamat',        display_name_ru = 'Глутамат натрия'  WHERE canonical_name = 'msg';
UPDATE public.ingredients SET display_name_uz = 'Qizil piyoz',    display_name_ru = 'Красный лук'      WHERE canonical_name = 'red_onion';
UPDATE public.ingredients SET display_name_uz = 'Achchiq qalampir', display_name_ru = 'Перец чили'      WHERE canonical_name = 'chili_pepper';
UPDATE public.ingredients SET display_name_uz = 'Pomidor sousi',   display_name_ru = 'Томатный соус'    WHERE canonical_name = 'tomato_sauce';
UPDATE public.ingredients SET display_name_uz = 'Sushi guruchi',   display_name_ru = 'Рис для суши'     WHERE canonical_name = 'sushi_rice';
UPDATE public.ingredients SET display_name_uz = 'Panko',           display_name_ru = 'Панко'            WHERE canonical_name = 'panko';
UPDATE public.ingredients SET display_name_uz = 'Koreya chili pastasi', display_name_ru = 'Кочхуджан'  WHERE canonical_name = 'gochujang';
UPDATE public.ingredients SET display_name_uz = 'Koreya soya pastasi', display_name_ru = 'Твенджан'    WHERE canonical_name = 'doenjang';
UPDATE public.ingredients SET display_name_uz = 'Mirin',           display_name_ru = 'Мирин'            WHERE canonical_name = 'mirin';
UPDATE public.ingredients SET display_name_uz = 'Guruch sirkasi',  display_name_ru = 'Рисовый уксус'    WHERE canonical_name = 'rice_vinegar';
UPDATE public.ingredients SET display_name_uz = 'Oyster sousi',    display_name_ru = 'Устричный соус'   WHERE canonical_name = 'oyster_sauce';
UPDATE public.ingredients SET display_name_uz = 'Hoisin sousi',    display_name_ru = 'Хойсин соус'      WHERE canonical_name = 'hoisin_sauce';
UPDATE public.ingredients SET display_name_uz = 'Sriracha',        display_name_ru = 'Шрирача'          WHERE canonical_name = 'sriracha';
UPDATE public.ingredients SET display_name_uz = 'Tabasho',         display_name_ru = 'Табаско'          WHERE canonical_name = 'tabasco';
UPDATE public.ingredients SET display_name_uz = 'Tomat konservasi', display_name_ru = 'Консервированные томаты' WHERE canonical_name = 'canned_tomato';
UPDATE public.ingredients SET display_name_uz = 'Edamame',         display_name_ru = 'Эдамаме'          WHERE canonical_name = 'edamame';
UPDATE public.ingredients SET display_name_uz = 'Qizil yasmiq',   display_name_ru = 'Красная чечевица' WHERE canonical_name = 'red_lentil';
UPDATE public.ingredients SET display_name_uz = 'Tofu terisi',    display_name_ru = 'Тофу (шёлковый)'  WHERE canonical_name = 'silken_tofu';
UPDATE public.ingredients SET display_name_uz = 'Pekan yong''oq',  display_name_ru = 'Пекан'            WHERE canonical_name = 'pecan';
UPDATE public.ingredients SET display_name_uz = 'Makadamiya',      display_name_ru = 'Макадамия'        WHERE canonical_name = 'macadamia';
UPDATE public.ingredients SET display_name_uz = 'Kanakunjut urug''i', display_name_ru = 'Семена конопли' WHERE canonical_name = 'hemp_seeds';
UPDATE public.ingredients SET display_name_uz = 'Ko''knor urug''i', display_name_ru = 'Маковые семена'  WHERE canonical_name = 'poppy_seeds';
UPDATE public.ingredients SET display_name_uz = 'Chig''anoq',      display_name_ru = 'Моллюски'         WHERE canonical_name = 'clam';
UPDATE public.ingredients SET display_name_uz = 'Skumbriya',       display_name_ru = 'Скумбрия'         WHERE canonical_name = 'mackerel';
UPDATE public.ingredients SET display_name_uz = 'Midiya',          display_name_ru = 'Мидии'            WHERE canonical_name = 'mussel';
UPDATE public.ingredients SET display_name_uz = 'Sakkiz oyoq',    display_name_ru = 'Осьминог'         WHERE canonical_name = 'octopus';
UPDATE public.ingredients SET display_name_uz = 'Sardin',          display_name_ru = 'Сардины'          WHERE canonical_name = 'sardine';
UPDATE public.ingredients SET display_name_uz = 'Tilapiya',        display_name_ru = 'Тилапия'          WHERE canonical_name = 'tilapia';
UPDATE public.ingredients SET display_name_uz = 'Qistirgich',      display_name_ru = 'Лобстер'          WHERE canonical_name = 'lobster';
UPDATE public.ingredients SET display_name_uz = 'Kanola yog''i',   display_name_ru = 'Рапсовое масло'   WHERE canonical_name = 'canola_oil';
UPDATE public.ingredients SET display_name_uz = 'Cho''chqa go''shti beli', display_name_ru = 'Свиная отбивная' WHERE canonical_name = 'pork_chop';
UPDATE public.ingredients SET display_name_uz = 'Cho''chqa go''shti beli', display_name_ru = 'Свиная корейка' WHERE canonical_name = 'pork_loin';
UPDATE public.ingredients SET display_name_uz = 'Apelsin sharbati', display_name_ru = 'Апельсиновый сок' WHERE canonical_name = 'orange_juice';
UPDATE public.ingredients SET display_name_uz = 'Soda suvi',       display_name_ru = 'Газированная вода' WHERE canonical_name = 'soda_water';
UPDATE public.ingredients SET display_name_uz = 'Choy',            display_name_ru = 'Чай'              WHERE canonical_name = 'tea';
UPDATE public.ingredients SET display_name_uz = 'Konservalangan tuna', display_name_ru = 'Консервированный тунец' WHERE canonical_name = 'canned_tuna';
UPDATE public.ingredients SET display_name_uz = 'Balsam sirkasi',  display_name_ru = 'Бальзамический уксус' WHERE canonical_name = 'balsamic_vinegar';
UPDATE public.ingredients SET display_name_uz = 'Olma sirkasi',    display_name_ru = 'Яблочный уксус'   WHERE canonical_name = 'apple_cider_vinegar';

-- 4. Backfill Cyrillic Uzbek for ALL ingredients
-- Cyrillic Uzbek uses the same words but in Cyrillic script (still widely used)
UPDATE public.ingredients SET display_name_uz_cyrl = 'Олма'                WHERE canonical_name = 'apple';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Авокадо'             WHERE canonical_name = 'avocado';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Банан'               WHERE canonical_name = 'banana';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Лимон'               WHERE canonical_name = 'lemon';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Апелсин'             WHERE canonical_name = 'orange';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Помидор'             WHERE canonical_name = 'tomato';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Бодринг'             WHERE canonical_name = 'cucumber';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Картошка'            WHERE canonical_name = 'potato';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сабзи'               WHERE canonical_name = 'carrot';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пиёз'                WHERE canonical_name = 'onion';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Саримсоқ'            WHERE canonical_name = 'garlic';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Исмалоқ'             WHERE canonical_name = 'spinach';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Гуруч'               WHERE canonical_name = 'rice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Нон'                 WHERE canonical_name = 'bread';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ун'                  WHERE canonical_name = 'flour';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Тухум'               WHERE canonical_name = 'egg';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Товуқ'               WHERE canonical_name = 'chicken';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мол гўшти'           WHERE canonical_name = 'beef';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қўй гўшти'          WHERE canonical_name = 'lamb';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Думба ёғи'           WHERE canonical_name = 'lamb_fat';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сут'                 WHERE canonical_name = 'milk';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сариёғ'              WHERE canonical_name = 'butter';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пишлоқ'              WHERE canonical_name = 'cheese';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қатиқ'               WHERE canonical_name = 'yogurt';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сузма'               WHERE canonical_name = 'suzma';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қурт'                WHERE canonical_name = 'kurt';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қаймоқ'              WHERE canonical_name = 'kaymak';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Айрон'               WHERE canonical_name = 'ayran';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Туз'                 WHERE canonical_name = 'salt';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қора мурч'           WHERE canonical_name = 'black_pepper';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зира'                WHERE canonical_name = 'cumin';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зирк'                WHERE canonical_name = 'barberry';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Шакар'               WHERE canonical_name = 'sugar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Асал'                WHERE canonical_name = 'honey';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зайтун ёғи'         WHERE canonical_name = 'olive_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пахта ёғи'          WHERE canonical_name = 'cotton_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мош'                 WHERE canonical_name = 'mung_bean';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Нўхат'               WHERE canonical_name = 'chickpea';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ўзбек нони'         WHERE canonical_name = 'non_bread';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Анор'                WHERE canonical_name = 'pomegranate';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Беҳи'               WHERE canonical_name = 'quince';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Майиз'               WHERE canonical_name = 'raisins';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қоҳва'              WHERE canonical_name = 'coffee';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кўк чой'            WHERE canonical_name = 'green_tea';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Товуқ кўкрак гўшти' WHERE canonical_name = 'chicken_breast';
