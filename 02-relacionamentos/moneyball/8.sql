SELECT "salary"
FROM "salaries"
JOIN "performances"
    ON "performances"."player_id" = "salaries"."player_id"
    AND "performances"."year" = "salaries"."year"
WHERE "salaries"."year" = 2001
AND "performances"."HR" = (
    SELECT MAX("HR")
    FROM "performances"
    WHERE "year" = 2001
);
