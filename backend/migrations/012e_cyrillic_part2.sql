-- ============================================================
-- Plately — Migration 012e: Full Cyrillic Uzbek (Part 2)
-- Grains, Seasonings, Condiments, Baking, Legumes,
-- Nuts, Seafood, Oils, Beverages
-- ============================================================

-- ── Grains ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ун'                  WHERE canonical_name = 'flour';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Гуруч'              WHERE canonical_name = 'rice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Нон'                WHERE canonical_name = 'bread';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Макарон'             WHERE canonical_name = 'pasta';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Нон уви'             WHERE canonical_name = 'breadcrumbs';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Жигарранг гуруч'    WHERE canonical_name = 'brown_rice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Басмати гуруч'       WHERE canonical_name = 'basmati_rice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Юлаф'                WHERE canonical_name = 'oats';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ўзбек нони'         WHERE canonical_name = 'non_bread';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Гречиха'             WHERE canonical_name = 'buckwheat';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Булгур'              WHERE canonical_name = 'bulgur';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Жўхори уни'         WHERE canonical_name = 'cornmeal';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кускус'              WHERE canonical_name = 'couscous';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Киноа'               WHERE canonical_name = 'quinoa';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Полента'             WHERE canonical_name = 'polenta';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Гуруч нудл'         WHERE canonical_name = 'rice_noodles';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Макарон'             WHERE canonical_name = 'macaroni';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Тортилла'            WHERE canonical_name = 'tortilla';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Спагетти'            WHERE canonical_name = 'spaghetti';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Оддий ун'            WHERE canonical_name = 'all_purpose_flour';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Жасмин гуруч'        WHERE canonical_name = 'jasmine_rice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Суши гуручи'         WHERE canonical_name = 'sushi_rice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Бўғдой уни'          WHERE canonical_name = 'whole_wheat_flour';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Рамен'               WHERE canonical_name = 'ramen_noodles';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Удон'                WHERE canonical_name = 'udon';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Наан нони'           WHERE canonical_name = 'naan';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Панко'               WHERE canonical_name = 'panko';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Музлатилган чучвара' WHERE canonical_name = 'frozen_dumplings';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Донадор шакар'       WHERE canonical_name = 'granulated_sugar';

-- ── Seasonings ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Райҳон'              WHERE canonical_name = 'basil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Дафна барги'         WHERE canonical_name = 'bay_leaf';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қора мурч'          WHERE canonical_name = 'black_pepper';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зира'               WHERE canonical_name = 'cumin';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кашнич'              WHERE canonical_name = 'cilantro';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Долчин'              WHERE canonical_name = 'cinnamon';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Аччиқ қалампир бўлакчалари' WHERE canonical_name = 'chili_flakes';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Аччиқ қалампир кукуни' WHERE canonical_name = 'chili_powder';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кашнич уруғи'        WHERE canonical_name = 'coriander';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кари'                WHERE canonical_name = 'curry_powder';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Укроп'               WHERE canonical_name = 'dill_weed';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ялпиз'               WHERE canonical_name = 'mint';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мускат ёнғоғи'       WHERE canonical_name = 'nutmeg';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Орегано'             WHERE canonical_name = 'oregano';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Паприка'             WHERE canonical_name = 'paprika';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Розмарин'            WHERE canonical_name = 'rosemary';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Туз'                WHERE canonical_name = 'salt';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зафарон'             WHERE canonical_name = 'saffron';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кунжут'              WHERE canonical_name = 'sesame';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Каклик ўти'          WHERE canonical_name = 'thyme';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сариқ илдиз'         WHERE canonical_name = 'turmeric';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ванил'               WHERE canonical_name = 'vanilla';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зирк'              WHERE canonical_name = 'barberry';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сумак'               WHERE canonical_name = 'sumac';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Седана уруғи'        WHERE canonical_name = 'nigella_seed';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кардамон'            WHERE canonical_name = 'cardamom';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Оқ мурч'             WHERE canonical_name = 'white_pepper';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Корея қалампири'     WHERE canonical_name = 'korean_chili_flakes';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Беш хил зираворлар'  WHERE canonical_name = 'five_spice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Глутамат'            WHERE canonical_name = 'msg';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ванил экстракти'     WHERE canonical_name = 'vanilla_extract';

-- ── Condiments ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Соя соуси'           WHERE canonical_name = 'soy_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Томат пастаси'       WHERE canonical_name = 'tomato_paste';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кетчуп'              WHERE canonical_name = 'ketchup';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Майонез'             WHERE canonical_name = 'mayonnaise';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Хантал'              WHERE canonical_name = 'mustard';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сирка'               WHERE canonical_name = 'vinegar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Балиқ соуси'         WHERE canonical_name = 'fish_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Аччиқ соус'          WHERE canonical_name = 'hot_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Тахини'              WHERE canonical_name = 'tahini';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мисо пастаси'        WHERE canonical_name = 'miso_paste';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Харисса'             WHERE canonical_name = 'harissa';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Дижон ханталли'      WHERE canonical_name = 'dijon_mustard';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Вустер соуси'        WHERE canonical_name = 'worcestershire';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Анор шираси'         WHERE canonical_name = 'pomegranate_molasses';
UPDATE public.ingredients SET display_name_uz_cyrl = 'BBQ соуси'           WHERE canonical_name = 'bbq_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Томат соуси'         WHERE canonical_name = 'tomato_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Помидор консерваси'  WHERE canonical_name = 'canned_tomato';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Корея чили пастаси'  WHERE canonical_name = 'gochujang';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Корея соя пастаси'   WHERE canonical_name = 'doenjang';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мирин'               WHERE canonical_name = 'mirin';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Гуруч сиркаси'       WHERE canonical_name = 'rice_vinegar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ойстер соуси'        WHERE canonical_name = 'oyster_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Хойсин соуси'        WHERE canonical_name = 'hoisin_sauce';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Срирача'             WHERE canonical_name = 'sriracha';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Табашо'              WHERE canonical_name = 'tabasco';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Балсам сиркаси'      WHERE canonical_name = 'balsamic_vinegar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Олма сиркаси'        WHERE canonical_name = 'apple_cider_vinegar';

-- ── Baking ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пиширишь кукуни'     WHERE canonical_name = 'baking_powder';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ош содаси'           WHERE canonical_name = 'baking_soda';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Жигарранг шакар'     WHERE canonical_name = 'brown_sugar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Шоколад'             WHERE canonical_name = 'chocolate';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Какао кукуни'        WHERE canonical_name = 'cocoa_powder';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Асал'               WHERE canonical_name = 'honey';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Шакар'              WHERE canonical_name = 'sugar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Крахмал'             WHERE canonical_name = 'cornstarch';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қуруқ хамиртуруш'    WHERE canonical_name = 'yeast_active';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Желатин'             WHERE canonical_name = 'gelatin';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Заранг шираси'       WHERE canonical_name = 'maple_syrup';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қора шираси'         WHERE canonical_name = 'molasses';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Шакар кукуни'        WHERE canonical_name = 'powdered_sugar';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Хамиртуруш'          WHERE canonical_name = 'yeast';

-- ── Legumes ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ловия'               WHERE canonical_name = 'beans';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қора ловия'          WHERE canonical_name = 'black_bean';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Нўхат'              WHERE canonical_name = 'chickpea';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кўк ясмиқ'          WHERE canonical_name = 'green_lentil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ясмиқ'               WHERE canonical_name = 'lentils';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Нўхат'               WHERE canonical_name = 'peas';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мош'                WHERE canonical_name = 'mung_bean';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Эдамаме'             WHERE canonical_name = 'edamame';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қизил ясмиқ'         WHERE canonical_name = 'red_lentil';

-- ── Nuts ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Бодом'               WHERE canonical_name = 'almond';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кажу'                WHERE canonical_name = 'cashew';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Чиа уруғи'           WHERE canonical_name = 'chia_seeds';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зиғир уруғи'         WHERE canonical_name = 'flax_seeds';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ерёнғоқ'             WHERE canonical_name = 'peanut';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ёнғоқ'               WHERE canonical_name = 'walnut';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Писта'               WHERE canonical_name = 'pistachio';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қуёш уруғи'         WHERE canonical_name = 'sunflower_seeds';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Финдиқ'              WHERE canonical_name = 'hazelnut';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Долзин ёнғоқ'        WHERE canonical_name = 'pine_nut';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ерёнғоқ'             WHERE canonical_name = 'peanuts';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пекан ёнғоқ'         WHERE canonical_name = 'pecan';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Макадамия'           WHERE canonical_name = 'macadamia';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Канакунжут уруғи'    WHERE canonical_name = 'hemp_seeds';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кўкнор уруғи'       WHERE canonical_name = 'poppy_seeds';

-- ── Seafood ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Анчоус'              WHERE canonical_name = 'anchovy';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Балиқ'               WHERE canonical_name = 'cod';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қисқичбақа'          WHERE canonical_name = 'crab';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Лосос'               WHERE canonical_name = 'salmon';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қисқичбақа гўшти'   WHERE canonical_name = 'shrimp';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Тунa'                WHERE canonical_name = 'tuna';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Каламар'             WHERE canonical_name = 'squid';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Чиғаноқ'             WHERE canonical_name = 'clam';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Скумбрия'            WHERE canonical_name = 'mackerel';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Мидия'               WHERE canonical_name = 'mussel';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Саккиз оёқ'          WHERE canonical_name = 'octopus';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сардин'              WHERE canonical_name = 'sardine';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Тилапия'             WHERE canonical_name = 'tilapia';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қистирғич'           WHERE canonical_name = 'lobster';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Оқ балиқ филеси'     WHERE canonical_name = 'white_fish_fillet';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Консерваланган тунa' WHERE canonical_name = 'canned_tuna';

-- ── Oils ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Зайтун ёғи'        WHERE canonical_name = 'olive_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Ўсимлик ёғи'        WHERE canonical_name = 'cooking_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кокос ёғи'           WHERE canonical_name = 'coconut_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кунжут ёғи'          WHERE canonical_name = 'sesame_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кунгабоқар ёғи'     WHERE canonical_name = 'sunflower_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пахта ёғи'          WHERE canonical_name = 'cotton_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Авокадо ёғи'         WHERE canonical_name = 'avocado_oil';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Канола ёғи'          WHERE canonical_name = 'canola_oil';

-- ── Beverages ──
UPDATE public.ingredients SET display_name_uz_cyrl = 'Олма шарбати'        WHERE canonical_name = 'apple_juice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Пиво'                WHERE canonical_name = 'beer';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Қоҳва'              WHERE canonical_name = 'coffee';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Кўк чой'            WHERE canonical_name = 'green_tea';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Лимон шарбати'       WHERE canonical_name = 'lemon_juice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сув'                 WHERE canonical_name = 'water';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Шароб'               WHERE canonical_name = 'wine';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Апелсин шарбати'     WHERE canonical_name = 'orange_juice';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Сода суви'           WHERE canonical_name = 'soda_water';
UPDATE public.ingredients SET display_name_uz_cyrl = 'Чой'                 WHERE canonical_name = 'tea';
