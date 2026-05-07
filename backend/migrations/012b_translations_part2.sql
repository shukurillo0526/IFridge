-- ============================================================
-- I-Fridge — Migration 012b: Ingredient Translations (UZ + RU)
-- Part 2: Dairy, Grains, Seasonings, Condiments, Baking,
--         Legumes, Nuts, Seafood, Oils, Beverages
-- ============================================================

-- ── Dairy (26) ──
UPDATE public.ingredients SET display_name_uz = 'Sariyog''',       display_name_ru = 'Сливочное масло'  WHERE canonical_name = 'butter';
UPDATE public.ingredients SET display_name_uz = 'Cheddar pishloq', display_name_ru = 'Сыр чеддер'      WHERE canonical_name = 'cheddar_cheese';
UPDATE public.ingredients SET display_name_uz = 'Pishloq',         display_name_ru = 'Сыр'             WHERE canonical_name = 'cheese';
UPDATE public.ingredients SET display_name_uz = 'Quyuq sut',       display_name_ru = 'Сгущённое молоко' WHERE canonical_name = 'condensed_milk';
UPDATE public.ingredients SET display_name_uz = 'Krem pishloq',    display_name_ru = 'Сливочный сыр'   WHERE canonical_name = 'cream_cheese';
UPDATE public.ingredients SET display_name_uz = 'Qaymoq',          display_name_ru = 'Сливки'          WHERE canonical_name = 'cream';
UPDATE public.ingredients SET display_name_uz = 'Yuqori yog''li qaymoq', display_name_ru = 'Жирные сливки' WHERE canonical_name = 'heavy_cream';
UPDATE public.ingredients SET display_name_uz = 'Sut',             display_name_ru = 'Молоко'          WHERE canonical_name = 'milk';
UPDATE public.ingredients SET display_name_uz = 'Mozarella',       display_name_ru = 'Моцарелла'       WHERE canonical_name = 'mozzarella';
UPDATE public.ingredients SET display_name_uz = 'Parmezan',        display_name_ru = 'Пармезан'        WHERE canonical_name = 'parmesan';
UPDATE public.ingredients SET display_name_uz = 'Smetana',         display_name_ru = 'Сметана'         WHERE canonical_name = 'sour_cream';
UPDATE public.ingredients SET display_name_uz = 'Tabiiy sut',      display_name_ru = 'Цельное молоко'  WHERE canonical_name = 'whole_milk';
UPDATE public.ingredients SET display_name_uz = 'Qatiq',           display_name_ru = 'Йогурт'         WHERE canonical_name = 'yogurt';
UPDATE public.ingredients SET display_name_uz = 'Suzma',           display_name_ru = 'Сузьма'          WHERE canonical_name = 'suzma';
UPDATE public.ingredients SET display_name_uz = 'Qurt',            display_name_ru = 'Курт'            WHERE canonical_name = 'kurt';
UPDATE public.ingredients SET display_name_uz = 'Qaymok',          display_name_ru = 'Каймак'          WHERE canonical_name = 'kaymak';
UPDATE public.ingredients SET display_name_uz = 'Ayron',           display_name_ru = 'Айран'           WHERE canonical_name = 'ayran';
UPDATE public.ingredients SET display_name_uz = 'Kefir',           display_name_ru = 'Кефир'           WHERE canonical_name = 'kefir';
UPDATE public.ingredients SET display_name_uz = 'Buttermilk',      display_name_ru = 'Пахта'           WHERE canonical_name = 'buttermilk';
UPDATE public.ingredients SET display_name_uz = 'Kokos suti',      display_name_ru = 'Кокосовое молоко' WHERE canonical_name = 'coconut_milk';
UPDATE public.ingredients SET display_name_uz = 'Maskarpone',      display_name_ru = 'Маскарпоне'      WHERE canonical_name = 'mascarpone';
UPDATE public.ingredients SET display_name_uz = 'Rikotta',         display_name_ru = 'Рикотта'         WHERE canonical_name = 'ricotta';
UPDATE public.ingredients SET display_name_uz = 'Echki pishloq',   display_name_ru = 'Козий сыр'       WHERE canonical_name = 'goat_cheese';

-- ── Grains (26) ──
UPDATE public.ingredients SET display_name_uz = 'Un',              display_name_ru = 'Мука'            WHERE canonical_name = 'flour';
UPDATE public.ingredients SET display_name_uz = 'Guruch',          display_name_ru = 'Рис'             WHERE canonical_name = 'rice';
UPDATE public.ingredients SET display_name_uz = 'Non',             display_name_ru = 'Хлеб'            WHERE canonical_name = 'bread';
UPDATE public.ingredients SET display_name_uz = 'Makaron',         display_name_ru = 'Макароны'        WHERE canonical_name = 'pasta';
UPDATE public.ingredients SET display_name_uz = 'Non uvi',         display_name_ru = 'Панировочные сухари' WHERE canonical_name = 'breadcrumbs';
UPDATE public.ingredients SET display_name_uz = 'Jigarrang guruch', display_name_ru = 'Бурый рис'     WHERE canonical_name = 'brown_rice';
UPDATE public.ingredients SET display_name_uz = 'Basmati guruch',  display_name_ru = 'Рис басмати'     WHERE canonical_name = 'basmati_rice';
UPDATE public.ingredients SET display_name_uz = 'Yulaf',           display_name_ru = 'Овсянка'         WHERE canonical_name = 'oats';
UPDATE public.ingredients SET display_name_uz = 'O''zbek noni',    display_name_ru = 'Лепёшка'         WHERE canonical_name = 'non_bread';
UPDATE public.ingredients SET display_name_uz = 'Grechixa',        display_name_ru = 'Гречка'          WHERE canonical_name = 'buckwheat';
UPDATE public.ingredients SET display_name_uz = 'Bulgur',          display_name_ru = 'Булгур'          WHERE canonical_name = 'bulgur';
UPDATE public.ingredients SET display_name_uz = 'Jo''xori uni',    display_name_ru = 'Кукурузная мука' WHERE canonical_name = 'cornmeal';
UPDATE public.ingredients SET display_name_uz = 'Kuskus',          display_name_ru = 'Кускус'          WHERE canonical_name = 'couscous';
UPDATE public.ingredients SET display_name_uz = 'Kinoa',           display_name_ru = 'Киноа'           WHERE canonical_name = 'quinoa';
UPDATE public.ingredients SET display_name_uz = 'Polenta',         display_name_ru = 'Полента'         WHERE canonical_name = 'polenta';
UPDATE public.ingredients SET display_name_uz = 'Guruch noodle',   display_name_ru = 'Рисовая лапша'   WHERE canonical_name = 'rice_noodles';
UPDATE public.ingredients SET display_name_uz = 'Makaron',         display_name_ru = 'Макароны'        WHERE canonical_name = 'macaroni';
UPDATE public.ingredients SET display_name_uz = 'Tortilla',        display_name_ru = 'Тортилья'        WHERE canonical_name = 'tortilla';
UPDATE public.ingredients SET display_name_uz = 'Spagetti',        display_name_ru = 'Спагетти'        WHERE canonical_name = 'spaghetti';

-- ── Seasonings (30) ──
UPDATE public.ingredients SET display_name_uz = 'Rayhon',          display_name_ru = 'Базилик'         WHERE canonical_name = 'basil';
UPDATE public.ingredients SET display_name_uz = 'Dafna bargi',     display_name_ru = 'Лавровый лист'   WHERE canonical_name = 'bay_leaf';
UPDATE public.ingredients SET display_name_uz = 'Qora murch',      display_name_ru = 'Чёрный перец'    WHERE canonical_name = 'black_pepper';
UPDATE public.ingredients SET display_name_uz = 'Zira',            display_name_ru = 'Зира'            WHERE canonical_name = 'cumin';
UPDATE public.ingredients SET display_name_uz = 'Kashnich',        display_name_ru = 'Кинза'           WHERE canonical_name = 'cilantro';
UPDATE public.ingredients SET display_name_uz = 'Dolchin',         display_name_ru = 'Корица'          WHERE canonical_name = 'cinnamon';
UPDATE public.ingredients SET display_name_uz = 'Achchiq qalampir bo''lakchalari', display_name_ru = 'Хлопья чили' WHERE canonical_name = 'chili_flakes';
UPDATE public.ingredients SET display_name_uz = 'Achchiq qalampir kukuni', display_name_ru = 'Порошок чили' WHERE canonical_name = 'chili_powder';
UPDATE public.ingredients SET display_name_uz = 'Kashnich urug''i', display_name_ru = 'Семена кориандра' WHERE canonical_name = 'coriander';
UPDATE public.ingredients SET display_name_uz = 'Kari',            display_name_ru = 'Карри'           WHERE canonical_name = 'curry_powder';
UPDATE public.ingredients SET display_name_uz = 'Ukrop',           display_name_ru = 'Укроп'           WHERE canonical_name = 'dill_weed';
UPDATE public.ingredients SET display_name_uz = 'Yalpiz',          display_name_ru = 'Мята'            WHERE canonical_name = 'mint';
UPDATE public.ingredients SET display_name_uz = 'Muskat yong''og''i', display_name_ru = 'Мускатный орех' WHERE canonical_name = 'nutmeg';
UPDATE public.ingredients SET display_name_uz = 'Oregano',         display_name_ru = 'Орегано'         WHERE canonical_name = 'oregano';
UPDATE public.ingredients SET display_name_uz = 'Paprika',         display_name_ru = 'Паприка'         WHERE canonical_name = 'paprika';
UPDATE public.ingredients SET display_name_uz = 'Petrushka',       display_name_ru = 'Петрушка'        WHERE canonical_name = 'parsley_dried';
UPDATE public.ingredients SET display_name_uz = 'Rozmarin',        display_name_ru = 'Розмарин'        WHERE canonical_name = 'rosemary';
UPDATE public.ingredients SET display_name_uz = 'Tuz',             display_name_ru = 'Соль'            WHERE canonical_name = 'salt';
UPDATE public.ingredients SET display_name_uz = 'Zafaron',         display_name_ru = 'Шафран'          WHERE canonical_name = 'saffron';
UPDATE public.ingredients SET display_name_uz = 'Kunjut',          display_name_ru = 'Кунжут'          WHERE canonical_name = 'sesame';
UPDATE public.ingredients SET display_name_uz = 'Kaklik o''ti',    display_name_ru = 'Тимьян'          WHERE canonical_name = 'thyme';
UPDATE public.ingredients SET display_name_uz = 'Sariq ildiz',     display_name_ru = 'Куркума'         WHERE canonical_name = 'turmeric';
UPDATE public.ingredients SET display_name_uz = 'Vanil',           display_name_ru = 'Ваниль'          WHERE canonical_name = 'vanilla';
UPDATE public.ingredients SET display_name_uz = 'Zirk',            display_name_ru = 'Барбарис'        WHERE canonical_name = 'barberry';
UPDATE public.ingredients SET display_name_uz = 'Sumak',           display_name_ru = 'Сумах'           WHERE canonical_name = 'sumac';
UPDATE public.ingredients SET display_name_uz = 'Sedana urug''i',  display_name_ru = 'Чернушка'        WHERE canonical_name = 'nigella_seed';
UPDATE public.ingredients SET display_name_uz = 'Kardamon',        display_name_ru = 'Кардамон'        WHERE canonical_name = 'cardamom';

-- ── Condiments (23) ──
UPDATE public.ingredients SET display_name_uz = 'Soya sousi',      display_name_ru = 'Соевый соус'     WHERE canonical_name = 'soy_sauce';
UPDATE public.ingredients SET display_name_uz = 'Tomat pastasi',   display_name_ru = 'Томатная паста'  WHERE canonical_name = 'tomato_paste';
UPDATE public.ingredients SET display_name_uz = 'Ketchup',         display_name_ru = 'Кетчуп'          WHERE canonical_name = 'ketchup';
UPDATE public.ingredients SET display_name_uz = 'Mayonez',         display_name_ru = 'Майонез'         WHERE canonical_name = 'mayonnaise';
UPDATE public.ingredients SET display_name_uz = 'Xantal',          display_name_ru = 'Горчица'         WHERE canonical_name = 'mustard';
UPDATE public.ingredients SET display_name_uz = 'Sirka',           display_name_ru = 'Уксус'           WHERE canonical_name = 'vinegar';
UPDATE public.ingredients SET display_name_uz = 'Baliq sousi',     display_name_ru = 'Рыбный соус'     WHERE canonical_name = 'fish_sauce';
UPDATE public.ingredients SET display_name_uz = 'Achchiq sous',    display_name_ru = 'Острый соус'     WHERE canonical_name = 'hot_sauce';
UPDATE public.ingredients SET display_name_uz = 'Taxini',          display_name_ru = 'Тахини'          WHERE canonical_name = 'tahini';
UPDATE public.ingredients SET display_name_uz = 'Miso pastasi',    display_name_ru = 'Паста мисо'      WHERE canonical_name = 'miso_paste';
UPDATE public.ingredients SET display_name_uz = 'Xarissa',         display_name_ru = 'Харисса'         WHERE canonical_name = 'harissa';
UPDATE public.ingredients SET display_name_uz = 'Dijon xantali',   display_name_ru = 'Дижонская горчица' WHERE canonical_name = 'dijon_mustard';
UPDATE public.ingredients SET display_name_uz = 'Vuster sousi',    display_name_ru = 'Вустерский соус' WHERE canonical_name = 'worcestershire';
UPDATE public.ingredients SET display_name_uz = 'Anor shirasi',    display_name_ru = 'Гранатовый соус' WHERE canonical_name = 'pomegranate_molasses';
UPDATE public.ingredients SET display_name_uz = 'BBQ sousi',       display_name_ru = 'Соус барбекю'    WHERE canonical_name = 'bbq_sauce';

-- ── Baking (17) ──
UPDATE public.ingredients SET display_name_uz = 'Pishirish kukuni', display_name_ru = 'Разрыхлитель'   WHERE canonical_name = 'baking_powder';
UPDATE public.ingredients SET display_name_uz = 'Osh sodasi',      display_name_ru = 'Сода'            WHERE canonical_name = 'baking_soda';
UPDATE public.ingredients SET display_name_uz = 'Jigarrang shakar', display_name_ru = 'Коричневый сахар' WHERE canonical_name = 'brown_sugar';
UPDATE public.ingredients SET display_name_uz = 'Shokolad',        display_name_ru = 'Шоколад'         WHERE canonical_name = 'chocolate';
UPDATE public.ingredients SET display_name_uz = 'Kakao kukuni',    display_name_ru = 'Какао-порошок'   WHERE canonical_name = 'cocoa_powder';
UPDATE public.ingredients SET display_name_uz = 'Asal',            display_name_ru = 'Мёд'             WHERE canonical_name = 'honey';
UPDATE public.ingredients SET display_name_uz = 'Shakar',          display_name_ru = 'Сахар'           WHERE canonical_name = 'sugar';
UPDATE public.ingredients SET display_name_uz = 'Kraxmal',         display_name_ru = 'Крахмал'         WHERE canonical_name = 'cornstarch';
UPDATE public.ingredients SET display_name_uz = 'Quruq xamirturush', display_name_ru = 'Сухие дрожжи'  WHERE canonical_name = 'yeast_active';
UPDATE public.ingredients SET display_name_uz = 'Jelatin',         display_name_ru = 'Желатин'         WHERE canonical_name = 'gelatin';
UPDATE public.ingredients SET display_name_uz = 'Zarang shirasi',  display_name_ru = 'Кленовый сироп'  WHERE canonical_name = 'maple_syrup';
UPDATE public.ingredients SET display_name_uz = 'Qora shirasi',    display_name_ru = 'Патока'          WHERE canonical_name = 'molasses';

-- ── Legumes (11) ──
UPDATE public.ingredients SET display_name_uz = 'Loviya',          display_name_ru = 'Фасоль'          WHERE canonical_name = 'beans';
UPDATE public.ingredients SET display_name_uz = 'Qora loviya',     display_name_ru = 'Чёрная фасоль'   WHERE canonical_name = 'black_bean';
UPDATE public.ingredients SET display_name_uz = 'No''xat',         display_name_ru = 'Нут'             WHERE canonical_name = 'chickpea';
UPDATE public.ingredients SET display_name_uz = 'Ko''k yasmiq',    display_name_ru = 'Зелёная чечевица' WHERE canonical_name = 'green_lentil';
UPDATE public.ingredients SET display_name_uz = 'Yasmiq',          display_name_ru = 'Чечевица'        WHERE canonical_name = 'lentils';
UPDATE public.ingredients SET display_name_uz = 'No''xat',         display_name_ru = 'Горох'           WHERE canonical_name = 'peas';
UPDATE public.ingredients SET display_name_uz = 'Mosh',            display_name_ru = 'Маш'             WHERE canonical_name = 'mung_bean';

-- ── Nuts (14) ──
UPDATE public.ingredients SET display_name_uz = 'Bodom',           display_name_ru = 'Миндаль'         WHERE canonical_name = 'almond';
UPDATE public.ingredients SET display_name_uz = 'Kaju',            display_name_ru = 'Кешью'           WHERE canonical_name = 'cashew';
UPDATE public.ingredients SET display_name_uz = 'Chia urug''i',    display_name_ru = 'Семена чиа'      WHERE canonical_name = 'chia_seeds';
UPDATE public.ingredients SET display_name_uz = 'Zig''ir urug''i', display_name_ru = 'Льняные семена'  WHERE canonical_name = 'flax_seeds';
UPDATE public.ingredients SET display_name_uz = 'Yeryong''oq',     display_name_ru = 'Арахис'          WHERE canonical_name = 'peanut';
UPDATE public.ingredients SET display_name_uz = 'Yong''oq',        display_name_ru = 'Грецкий орех'    WHERE canonical_name = 'walnut';
UPDATE public.ingredients SET display_name_uz = 'Pista',           display_name_ru = 'Фисташки'        WHERE canonical_name = 'pistachio';
UPDATE public.ingredients SET display_name_uz = 'Quyosh urug''i',  display_name_ru = 'Семечки'         WHERE canonical_name = 'sunflower_seeds';
UPDATE public.ingredients SET display_name_uz = 'Findiq',          display_name_ru = 'Фундук'          WHERE canonical_name = 'hazelnut';
UPDATE public.ingredients SET display_name_uz = 'Dolzin yong''oq', display_name_ru = 'Кедровые орехи'  WHERE canonical_name = 'pine_nut';

-- ── Seafood (14) ──
UPDATE public.ingredients SET display_name_uz = 'Anchous',         display_name_ru = 'Анчоус'          WHERE canonical_name = 'anchovy';
UPDATE public.ingredients SET display_name_uz = 'Baliq',           display_name_ru = 'Треска'          WHERE canonical_name = 'cod';
UPDATE public.ingredients SET display_name_uz = 'Qisqichbaqa',    display_name_ru = 'Краб'            WHERE canonical_name = 'crab';
UPDATE public.ingredients SET display_name_uz = 'Losos',           display_name_ru = 'Лосось'          WHERE canonical_name = 'salmon';
UPDATE public.ingredients SET display_name_uz = 'Qisqichbaqa go''shti', display_name_ru = 'Креветки' WHERE canonical_name = 'shrimp';
UPDATE public.ingredients SET display_name_uz = 'Tuna',            display_name_ru = 'Тунец'           WHERE canonical_name = 'tuna';
UPDATE public.ingredients SET display_name_uz = 'Kalamar',         display_name_ru = 'Кальмар'         WHERE canonical_name = 'squid';

-- ── Oils (7) ──
UPDATE public.ingredients SET display_name_uz = 'Zaytun yog''i',   display_name_ru = 'Оливковое масло' WHERE canonical_name = 'olive_oil';
UPDATE public.ingredients SET display_name_uz = 'O''simlik yog''i', display_name_ru = 'Растительное масло' WHERE canonical_name = 'cooking_oil';
UPDATE public.ingredients SET display_name_uz = 'Kokos yog''i',    display_name_ru = 'Кокосовое масло' WHERE canonical_name = 'coconut_oil';
UPDATE public.ingredients SET display_name_uz = 'Kunjut yog''i',   display_name_ru = 'Кунжутное масло' WHERE canonical_name = 'sesame_oil';
UPDATE public.ingredients SET display_name_uz = 'Kungaboqar yog''i', display_name_ru = 'Подсолнечное масло' WHERE canonical_name = 'sunflower_oil';
UPDATE public.ingredients SET display_name_uz = 'Paxta yog''i',    display_name_ru = 'Хлопковое масло' WHERE canonical_name = 'cotton_oil';
UPDATE public.ingredients SET display_name_uz = 'Avokado yog''i',  display_name_ru = 'Масло авокадо'   WHERE canonical_name = 'avocado_oil';

-- ── Beverages (9) ──
UPDATE public.ingredients SET display_name_uz = 'Olma sharbati',   display_name_ru = 'Яблочный сок'    WHERE canonical_name = 'apple_juice';
UPDATE public.ingredients SET display_name_uz = 'Pivo',            display_name_ru = 'Пиво'            WHERE canonical_name = 'beer';
UPDATE public.ingredients SET display_name_uz = 'Qahva',           display_name_ru = 'Кофе'            WHERE canonical_name = 'coffee';
UPDATE public.ingredients SET display_name_uz = 'Ko''k choy',      display_name_ru = 'Зелёный чай'     WHERE canonical_name = 'green_tea';
UPDATE public.ingredients SET display_name_uz = 'Limon sharbati',  display_name_ru = 'Лимонный сок'    WHERE canonical_name = 'lemon_juice';
UPDATE public.ingredients SET display_name_uz = 'Suv',             display_name_ru = 'Вода'            WHERE canonical_name = 'water';
UPDATE public.ingredients SET display_name_uz = 'Sharob',          display_name_ru = 'Вино'            WHERE canonical_name = 'wine';
