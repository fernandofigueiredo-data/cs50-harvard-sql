SELECT "first_name" || ' ' || "last_name" AS "Brazilian Players",
       "birth_city",
       "birth_state",
       "birth_year"
FROM "players"
WHERE "birth_country" = 'Brazil'
ORDER BY "birth_year";
