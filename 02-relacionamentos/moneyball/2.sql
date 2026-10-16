SELECT "salaries"."year", "salaries"."salary"
FROM "salaries"
JOIN "players"
    ON "players"."id" = "salaries"."player_id"
WHERE "players"."first_name" = 'Cal'
AND "last_name" LIKE '%Ripken%'
ORDER BY "salaries"."year" DESC;
