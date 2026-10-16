--SELECT substr("sentence", 98, 4)
--FROM "sentences"
--WHERE "id" = 14;
--'find'

--SELECT substr("sentence", 3, 5)
--FROM "sentences"
--WHERE "id" = 114;
--'me in'

CREATE VIEW "message" AS
WITH "resolution" ("sequence", "sentence_id", "start", "length") AS (
    VALUES
        (1, 14, 98, 4),
        (2, 114, 3, 5),
        (3, 618, 72, 9),
        (4, 630, 7, 3),
        (5, 932, 12, 5),
        (6, 2230, 50, 7),
        (7, 2346, 44, 10),
        (8, 3041, 14, 5)
)
SELECT substr(
    "sentences"."sentence",
    "resolution"."start",
    "resolution"."length"
) AS "phrase"
FROM "resolution"
JOIN "sentences"
    ON "resolution"."sentence_id" = "sentences"."id"
ORDER BY "resolution"."sequence";

--| find       |
--| me in      |
--| the place  |
--| you        |
--| least      |
--| expect.    |
--| behind the |
--| books      |
-- find me in the place you least expect. behind the books --
