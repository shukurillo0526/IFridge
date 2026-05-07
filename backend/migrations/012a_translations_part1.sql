-- ============================================================
-- I-Fridge — Migration 012: Ingredient Translations (UZ + RU)
-- Part 1: Vegetables, Fruits, Proteins
-- ============================================================

-- ── Vegetables (45) ──
UPDATE public.ingredients SET display_name_uz = 'Artishok',        display_name_ru = 'Артишок'         WHERE canonical_name = 'artichoke';
UPDATE public.ingredients SET display_name_uz = 'Qushqo''nmas',    display_name_ru = 'Спаржа'          WHERE canonical_name = 'asparagus';
UPDATE public.ingredients SET display_name_uz = 'Bambuk novdasi',  display_name_ru = 'Побеги бамбука'  WHERE canonical_name = 'bamboo_shoots';
UPDATE public.ingredients SET display_name_uz = 'Unib chiqqan loviya', display_name_ru = 'Пророщенная фасоль' WHERE canonical_name = 'bean_sprouts';
UPDATE public.ingredients SET display_name_uz = 'Lavlagi',         display_name_ru = 'Свёкла'          WHERE canonical_name = 'beet';
UPDATE public.ingredients SET display_name_uz = 'Bolgar qalampiri',display_name_ru = 'Болгарский перец' WHERE canonical_name = 'bell_pepper';
UPDATE public.ingredients SET display_name_uz = 'Brokkoli',        display_name_ru = 'Брокколи'        WHERE canonical_name = 'broccoli';
UPDATE public.ingredients SET display_name_uz = 'Bryussel karamchasi', display_name_ru = 'Брюссельская капуста' WHERE canonical_name = 'brussels_sprouts';
UPDATE public.ingredients SET display_name_uz = 'Karam',           display_name_ru = 'Капуста'         WHERE canonical_name = 'cabbage';
UPDATE public.ingredients SET display_name_uz = 'Sabzi',           display_name_ru = 'Морковь'         WHERE canonical_name = 'carrot';
UPDATE public.ingredients SET display_name_uz = 'Gulkaram',        display_name_ru = 'Цветная капуста' WHERE canonical_name = 'cauliflower';
UPDATE public.ingredients SET display_name_uz = 'Selderey',        display_name_ru = 'Сельдерей'       WHERE canonical_name = 'celery';
UPDATE public.ingredients SET display_name_uz = 'Makkajo''xori',   display_name_ru = 'Кукуруза'        WHERE canonical_name = 'corn';
UPDATE public.ingredients SET display_name_uz = 'Bodring',         display_name_ru = 'Огурец'          WHERE canonical_name = 'cucumber';
UPDATE public.ingredients SET display_name_uz = 'Baqlajon',        display_name_ru = 'Баклажан'        WHERE canonical_name = 'eggplant';
UPDATE public.ingredients SET display_name_uz = 'Ukrop',           display_name_ru = 'Укроп'           WHERE canonical_name = 'dill';
UPDATE public.ingredients SET display_name_uz = 'Sarimsoq',        display_name_ru = 'Чеснок'          WHERE canonical_name = 'garlic';
UPDATE public.ingredients SET display_name_uz = 'Zanjabil',        display_name_ru = 'Имбирь'          WHERE canonical_name = 'ginger';
UPDATE public.ingredients SET display_name_uz = 'Ko''k piyoz',     display_name_ru = 'Зелёный лук'     WHERE canonical_name = 'green_onion';
UPDATE public.ingredients SET display_name_uz = 'Ko''k turp',      display_name_ru = 'Зелёная редька'  WHERE canonical_name = 'green_radish';
UPDATE public.ingredients SET display_name_uz = 'Kale',            display_name_ru = 'Кейл'            WHERE canonical_name = 'kale';
UPDATE public.ingredients SET display_name_uz = 'Porra',           display_name_ru = 'Лук-порей'       WHERE canonical_name = 'leek';
UPDATE public.ingredients SET display_name_uz = 'Ko''kmat',        display_name_ru = 'Салат'            WHERE canonical_name = 'lettuce';
UPDATE public.ingredients SET display_name_uz = 'Qo''ziqorin',     display_name_ru = 'Грибы'           WHERE canonical_name = 'mushroom';
UPDATE public.ingredients SET display_name_uz = 'Bamiya',          display_name_ru = 'Бамия'           WHERE canonical_name = 'okra';
UPDATE public.ingredients SET display_name_uz = 'Piyoz',           display_name_ru = 'Лук'             WHERE canonical_name = 'onion';
UPDATE public.ingredients SET display_name_uz = 'Petrushka',       display_name_ru = 'Петрушка'        WHERE canonical_name = 'parsley';
UPDATE public.ingredients SET display_name_uz = 'No''xat',         display_name_ru = 'Горох'           WHERE canonical_name = 'peas';
UPDATE public.ingredients SET display_name_uz = 'Kartoshka',       display_name_ru = 'Картофель'       WHERE canonical_name = 'potato';
UPDATE public.ingredients SET display_name_uz = 'Oshqovoq',        display_name_ru = 'Тыква'           WHERE canonical_name = 'pumpkin';
UPDATE public.ingredients SET display_name_uz = 'Turp',            display_name_ru = 'Редис'           WHERE canonical_name = 'radish';
UPDATE public.ingredients SET display_name_uz = 'Qizil karam',     display_name_ru = 'Краснокочанная капуста' WHERE canonical_name = 'red_cabbage';
UPDATE public.ingredients SET display_name_uz = 'Sholg''om',       display_name_ru = 'Репа'            WHERE canonical_name = 'turnip';
UPDATE public.ingredients SET display_name_uz = 'Ismaloq',         display_name_ru = 'Шпинат'          WHERE canonical_name = 'spinach';
UPDATE public.ingredients SET display_name_uz = 'Tatlimosh',       display_name_ru = 'Батат'           WHERE canonical_name = 'sweet_potato';
UPDATE public.ingredients SET display_name_uz = 'Pomidor',         display_name_ru = 'Помидор'         WHERE canonical_name = 'tomato';
UPDATE public.ingredients SET display_name_uz = 'Qovoqcha',        display_name_ru = 'Кабачок'         WHERE canonical_name = 'zucchini';
UPDATE public.ingredients SET display_name_uz = 'Shalot',          display_name_ru = 'Шалот'           WHERE canonical_name = 'shallot';
UPDATE public.ingredients SET display_name_uz = 'Ukrop',           display_name_ru = 'Фенхель'         WHERE canonical_name = 'fennel';
UPDATE public.ingredients SET display_name_uz = 'Xalapeno',        display_name_ru = 'Халапеньо'       WHERE canonical_name = 'jalapeno';
UPDATE public.ingredients SET display_name_uz = 'Pak-choy',        display_name_ru = 'Бок-чой'         WHERE canonical_name = 'bok_choy';
UPDATE public.ingredients SET display_name_uz = 'Suv sedanasi',    display_name_ru = 'Кресс-салат'     WHERE canonical_name = 'watercress';
UPDATE public.ingredients SET display_name_uz = 'Daikon',          display_name_ru = 'Дайкон'          WHERE canonical_name = 'daikon';

-- ── Fruits (29) ──
UPDATE public.ingredients SET display_name_uz = 'Olma',            display_name_ru = 'Яблоко'          WHERE canonical_name = 'apple';
UPDATE public.ingredients SET display_name_uz = 'Avokado',         display_name_ru = 'Авокадо'         WHERE canonical_name = 'avocado';
UPDATE public.ingredients SET display_name_uz = 'Banan',           display_name_ru = 'Банан'           WHERE canonical_name = 'banana';
UPDATE public.ingredients SET display_name_uz = 'Ko''k gilos',     display_name_ru = 'Черника'         WHERE canonical_name = 'blueberry';
UPDATE public.ingredients SET display_name_uz = 'Gilos',           display_name_ru = 'Вишня'           WHERE canonical_name = 'cherry';
UPDATE public.ingredients SET display_name_uz = 'Kokos',           display_name_ru = 'Кокос'           WHERE canonical_name = 'coconut';
UPDATE public.ingredients SET display_name_uz = 'Uzum',            display_name_ru = 'Виноград'        WHERE canonical_name = 'grape';
UPDATE public.ingredients SET display_name_uz = 'Greypfrut',       display_name_ru = 'Грейпфрут'       WHERE canonical_name = 'grapefruit';
UPDATE public.ingredients SET display_name_uz = 'Kivi',            display_name_ru = 'Киви'            WHERE canonical_name = 'kiwi';
UPDATE public.ingredients SET display_name_uz = 'Limon',           display_name_ru = 'Лимон'           WHERE canonical_name = 'lemon';
UPDATE public.ingredients SET display_name_uz = 'Laym',            display_name_ru = 'Лайм'            WHERE canonical_name = 'lime';
UPDATE public.ingredients SET display_name_uz = 'Mango',           display_name_ru = 'Манго'           WHERE canonical_name = 'mango';
UPDATE public.ingredients SET display_name_uz = 'Qovun',           display_name_ru = 'Дыня'            WHERE canonical_name = 'melon';
UPDATE public.ingredients SET display_name_uz = 'Apelsin',         display_name_ru = 'Апельсин'        WHERE canonical_name = 'orange';
UPDATE public.ingredients SET display_name_uz = 'Shaftoli',        display_name_ru = 'Персик'          WHERE canonical_name = 'peach';
UPDATE public.ingredients SET display_name_uz = 'Nok',             display_name_ru = 'Груша'           WHERE canonical_name = 'pear';
UPDATE public.ingredients SET display_name_uz = 'Ananas',          display_name_ru = 'Ананас'          WHERE canonical_name = 'pineapple';
UPDATE public.ingredients SET display_name_uz = 'O''rik',          display_name_ru = 'Слива'           WHERE canonical_name = 'plum';
UPDATE public.ingredients SET display_name_uz = 'Anor',            display_name_ru = 'Гранат'          WHERE canonical_name = 'pomegranate';
UPDATE public.ingredients SET display_name_uz = 'Malina',          display_name_ru = 'Малина'          WHERE canonical_name = 'raspberry';
UPDATE public.ingredients SET display_name_uz = 'Qulupnay',        display_name_ru = 'Клубника'        WHERE canonical_name = 'strawberry';
UPDATE public.ingredients SET display_name_uz = 'Tarvuz',          display_name_ru = 'Арбуз'           WHERE canonical_name = 'watermelon';
UPDATE public.ingredients SET display_name_uz = 'Quritilgan o''rik',display_name_ru = 'Курага'         WHERE canonical_name = 'dried_apricot';
UPDATE public.ingredients SET display_name_uz = 'Mayiz',           display_name_ru = 'Изюм'            WHERE canonical_name = 'raisins';
UPDATE public.ingredients SET display_name_uz = 'Behi',            display_name_ru = 'Айва'            WHERE canonical_name = 'quince';
UPDATE public.ingredients SET display_name_uz = 'Fuji olma',       display_name_ru = 'Яблоко Фуджи'   WHERE canonical_name = 'fuji_apple';
UPDATE public.ingredients SET display_name_uz = 'Mandalina',       display_name_ru = 'Мандарин'        WHERE canonical_name = 'tangerine';
UPDATE public.ingredients SET display_name_uz = 'Xurmo',           display_name_ru = 'Хурма'           WHERE canonical_name = 'persimmon';
UPDATE public.ingredients SET display_name_uz = 'Anjir',           display_name_ru = 'Инжир'           WHERE canonical_name = 'fig';

-- ── Proteins (27) ──
UPDATE public.ingredients SET display_name_uz = 'Bekon',           display_name_ru = 'Бекон'           WHERE canonical_name = 'bacon';
UPDATE public.ingredients SET display_name_uz = 'Mol go''shti',    display_name_ru = 'Говядина'        WHERE canonical_name = 'beef';
UPDATE public.ingredients SET display_name_uz = 'Mol go''shti steyk', display_name_ru = 'Стейк'       WHERE canonical_name = 'beef_steak';
UPDATE public.ingredients SET display_name_uz = 'Tovuq',           display_name_ru = 'Курица'          WHERE canonical_name = 'chicken';
UPDATE public.ingredients SET display_name_uz = 'Tovuq ko''krak go''shti', display_name_ru = 'Куриная грудка' WHERE canonical_name = 'chicken_breast';
UPDATE public.ingredients SET display_name_uz = 'Tovuq soni',      display_name_ru = 'Куриное бедро'   WHERE canonical_name = 'chicken_thigh';
UPDATE public.ingredients SET display_name_uz = 'Tovuq qanoti',    display_name_ru = 'Куриные крылья'  WHERE canonical_name = 'chicken_wing';
UPDATE public.ingredients SET display_name_uz = 'O''rdak',         display_name_ru = 'Утка'            WHERE canonical_name = 'duck';
UPDATE public.ingredients SET display_name_uz = 'Tuxum',           display_name_ru = 'Яйцо'           WHERE canonical_name = 'egg';
UPDATE public.ingredients SET display_name_uz = 'Mol qiymasi',     display_name_ru = 'Говяжий фарш'   WHERE canonical_name = 'ground_beef';
UPDATE public.ingredients SET display_name_uz = 'Tovuq qiymasi',   display_name_ru = 'Куриный фарш'   WHERE canonical_name = 'ground_chicken';
UPDATE public.ingredients SET display_name_uz = 'Cho''chqa qiymasi', display_name_ru = 'Свиной фарш'  WHERE canonical_name = 'ground_pork';
UPDATE public.ingredients SET display_name_uz = 'Kurka go''shti',  display_name_ru = 'Индейка'         WHERE canonical_name = 'turkey';
UPDATE public.ingredients SET display_name_uz = 'Jambon',          display_name_ru = 'Ветчина'         WHERE canonical_name = 'ham';
UPDATE public.ingredients SET display_name_uz = 'Qo''y go''shti',  display_name_ru = 'Баранина'        WHERE canonical_name = 'lamb';
UPDATE public.ingredients SET display_name_uz = 'Qo''y yelkasi',   display_name_ru = 'Лопатка баранины' WHERE canonical_name = 'lamb_shoulder';
UPDATE public.ingredients SET display_name_uz = 'Qo''y oyog''i',   display_name_ru = 'Нога баранины'   WHERE canonical_name = 'lamb_leg';
UPDATE public.ingredients SET display_name_uz = 'Qo''y qovurg''asi', display_name_ru = 'Бараньи рёбра' WHERE canonical_name = 'lamb_ribs';
UPDATE public.ingredients SET display_name_uz = 'Dumba yog''i',    display_name_ru = 'Курдючный жир'   WHERE canonical_name = 'lamb_fat';
UPDATE public.ingredients SET display_name_uz = 'Ot go''shti',     display_name_ru = 'Конина'          WHERE canonical_name = 'horse_meat';
UPDATE public.ingredients SET display_name_uz = 'Bedana',          display_name_ru = 'Перепёлка'       WHERE canonical_name = 'quail';
UPDATE public.ingredients SET display_name_uz = 'Cho''chqa go''shti', display_name_ru = 'Свинина'     WHERE canonical_name = 'pork';
UPDATE public.ingredients SET display_name_uz = 'Kolbasa',         display_name_ru = 'Сосиски'         WHERE canonical_name = 'sausage';
UPDATE public.ingredients SET display_name_uz = 'Tofu',            display_name_ru = 'Тофу'            WHERE canonical_name = 'tofu';
UPDATE public.ingredients SET display_name_uz = 'Tempe',           display_name_ru = 'Темпе'           WHERE canonical_name = 'tempeh';
UPDATE public.ingredients SET display_name_uz = 'Buzoq go''shti',  display_name_ru = 'Телятина'        WHERE canonical_name = 'veal';
UPDATE public.ingredients SET display_name_uz = 'Dana go''shti',   display_name_ru = 'Мясо'            WHERE canonical_name = 'meat';
