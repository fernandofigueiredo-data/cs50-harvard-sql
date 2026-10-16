SELECT
    "players"."first_name",
    "players"."last_name"
FROM "players"
WHERE "players"."id" IN (
    SELECT "players"."id"
    FROM "players"
    JOIN "salaries"
        ON "salaries"."player_id" = "players"."id"
        AND "salaries"."year" = 2001
    JOIN "performances"
        ON "performances"."player_id" = "players"."id"
        AND "performances"."year" = 2001
    WHERE "performances"."H" > 0
    ORDER BY "salaries"."salary" / "performances"."H" ASC
    LIMIT 10
)
AND "players"."id" IN (
    SELECT "players"."id"
    FROM "players"
    JOIN "salaries"
        ON "salaries"."player_id" = "players"."id"
        AND "salaries"."year" = 2001
    JOIN "performances"
        ON "performances"."player_id" = "players"."id"
        AND "performances"."year" = 2001
    WHERE "performances"."RBI" > 0
    ORDER BY "salaries"."salary" / "performances"."RBI" ASC
    LIMIT 10
)
ORDER BY "players"."id" ASC;
