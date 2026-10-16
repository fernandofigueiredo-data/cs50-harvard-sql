-- Dados de exemplo do enunciado, para provar que o schema os representa.
-- Uso: sqlite3 atl.db ".read schema.sql" ".read dados_exemplo.sql"

INSERT INTO "passengers" ("first_name", "last_name", "age")
VALUES ('Amelia', 'Earhart', 39);

INSERT INTO "airlines" ("name") VALUES ('Delta');

INSERT INTO "airline_concourses" ("airline_id", "concourse")
SELECT "id", "concourse"
FROM "airlines", (
    SELECT 'A' AS "concourse" UNION ALL SELECT 'B' UNION ALL SELECT 'C'
    UNION ALL SELECT 'D' UNION ALL SELECT 'T'
)
WHERE "name" = 'Delta';

INSERT INTO "flights" (
    "flight_number", "airline_id", "departure_airport", "arrival_airport",
    "datetime_departure", "datetime_arrival"
)
SELECT 300, "id", 'ATL', 'BOS', '2023-08-03 18:46', '2023-08-03 21:09'
FROM "airlines" WHERE "name" = 'Delta';

INSERT INTO "check_ins" ("passenger_id", "flight_id", "datetime")
SELECT "passengers"."id", "flights"."id", '2023-08-03 15:03'
FROM "passengers", "flights"
WHERE "passengers"."first_name" = 'Amelia' AND "passengers"."last_name" = 'Earhart'
AND "flights"."flight_number" = 300 AND "flights"."departure_airport" = 'ATL';
